import 'dart:async';
import 'package:flutter/material.dart';

// Supabase + Screens
import 'utils/supabase_client.dart';
import 'utils/notification_service.dart'; // High-Importance Channel + Permission
import 'screens/start_screen.dart';
import 'screens/new_password_screen.dart';

// Deeplink mit app_links
import 'package:app_links/app_links.dart';

// Lokalisierung
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';

// Supabase
import 'package:supabase_flutter/supabase_flutter.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Supabase starten
  await SupabaseClientManager.init();

  // 2) Firebase (für FCM) starten
  await Firebase.initializeApp();

  // 3) Notification-Service initialisieren
  //    - legt High-Importance Channel an
  //    - fragt auf Android 13+ die Push-Permission an
  await NotificationService.init();

  // 4) Token holen und in Supabase speichern (falls eingeloggt)
  await _saveFcmTokenToSupabase();

  // 5) Token-Refresh automatisch aktualisieren
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    _saveFcmTokenToSupabase(newToken);
  });

  // 6) Auf Login/Logout reagieren -> Token korrekt binden/lösen
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.signedIn) {
      _saveFcmTokenToSupabase();
    } else if (data.event == AuthChangeEvent.signedOut) {
      _clearFcmTokenInSupabase();
    }
  });

  // 7) Foreground-Handler für Heads-Up Banner
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final title =
        message.notification?.title ?? message.data['title'] ?? 'Benachrichtigung';
    final body =
        message.notification?.body ?? message.data['body'] ?? '';
    NotificationService.showForegroundNotification(
      title: title,
      body: body,
      data: message.data.map((k, v) => MapEntry(k, v.toString())),
    );
  });

  runApp(const MyApp());
}

// === Helper-Funktionen für Token <-> Supabase ===============================

/// Stellt sicher, dass ein `users`-Datensatz existiert (falls RLS/Upserts genutzt werden)
Future<void> _ensureUserRow() async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) {
    print('⚠️ _ensureUserRow: Kein eingeloggter User.');
    return;
  }
  try {
    final resp = await Supabase.instance.client
        .from('users')
        .upsert({'id': user.id}, onConflict: 'id')
        .select()
        .maybeSingle();
    print('✅ ensureUserRow: ${resp != null ? 'Row vorhanden/angelegt' : 'keine Row'}');
  } catch (e) {
    print('❌ ensureUserRow Fehler: $e');
  }
}

/// Bindet den aktuellen Geräte-Token eindeutig an den eingeloggten User.
/// Verwendet die RPC `set_user_push_token` (macht Token bei anderen Usern frei).
Future<void> _saveFcmTokenToSupabase([String? token]) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) {
    print('⚠️ Kein eingeloggter User – Token nicht gespeichert.');
    return;
  }

  // optional, falls der users-Datensatz noch nicht existiert
  await _ensureUserRow();

  final t = token ?? await FirebaseMessaging.instance.getToken();
  print('🧪 Debug: currentUser.id=${user.id}, fcmToken=$t');
  if (t == null || t.isEmpty) {
    print('⚠️ Kein FCM-Token verfügbar.');
    return;
  }

  try {
    await Supabase.instance.client.rpc('set_user_push_token', params: {
      'p_user': user.id,
      'p_token': t,
    });
    print('✅ push_token via RPC gesetzt (unique bind).');
  } catch (e) {
    // Fallback: direkter Update (nicht ideal, aber verhindert Stillstand)
    print('❌ RPC set_user_push_token Fehler: $e — Fallback auf direktes Update.');
    try {
      final updated = await Supabase.instance.client
          .from('users')
          .update({'push_token': t})
          .eq('id', user.id)
          .select()
          .maybeSingle();
      print('✅ Fallback gespeichert: ${updated?['push_token']}');
    } catch (e2) {
      print('❌ Fallback-Update Fehler: $e2');
    }
  }
}

/// Entfernt die Token-Zuordnung beim Logout (RPC erlaubt NULL als „löschen“)
Future<void> _clearFcmTokenInSupabase() async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return;
  try {
    await Supabase.instance.client.rpc('set_user_push_token', params: {
      'p_user': user.id,
      'p_token': null,
    });
    print('✅ push_token via RPC gelöscht.');
  } catch (e) {
    print('❌ RPC clear Fehler: $e — Fallback auf direktes Update.');
    try {
      await Supabase.instance.client
          .from('users')
          .update({'push_token': null})
          .eq('id', user.id);
      print('✅ Fallback: push_token auf NULL gesetzt.');
    } catch (e2) {
      print('❌ Fallback-Update Fehler: $e2');
    }
  }
}

// === App-Widget =============================================================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri>? _deeplinkSub;
  StreamSubscription<AuthState>? _authSubPersistent;
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();

    // 1) Initiale URI (kalter Start)
    _handleInitialUri();

    // 2) Laufende Deeplinks
    _deeplinkSub = _appLinks.uriLinkStream.listen((uri) {
      _handleIncomingUri(uri);
    }, onError: (_) {});

    // 3) Persistenter Auth-State-Listener (Password Recovery)
    _authSubPersistent =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        _goToReset();
      }
    });
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await _appLinks.getInitialAppLink();
      await _handleIncomingUri(uri);
    } catch (_) {/* ignore */}
  }

  bool _isOurCallback(Uri? uri) =>
      uri != null &&
      uri.scheme == 'atyourservice' &&
      uri.host == 'login-callback';

  String? _supabaseType(Uri? uri) {
    if (uri == null) return null;
    final frag = uri.fragment.toLowerCase();
    final query = uri.query.toLowerCase();
    if (frag.contains('type=recovery') || query.contains('type=recovery')) {
      return 'recovery';
    }
    if (frag.contains('type=signup') || query.contains('type=signup')) {
      return 'signup';
    }
    if (frag.contains('type=magiclink') || query.contains('type=magiclink')) {
      return 'magiclink';
    }
    if (frag.contains('type=invite') || query.contains('type=invite')) {
      return 'invite';
    }
    return null;
  }

  Future<void> _handleIncomingUri(Uri? uri) async {
    if (!_isOurCallback(uri)) return;
    final incoming = uri!;

    try {
      await Supabase.instance.client.auth
          .getSessionFromUrl(incoming, storeSession: true);
    } catch (_) {}

    final t = _supabaseType(incoming);
    if (t == 'recovery') {
      _goToReset();
      return;
    }

    final completer = Completer<void>();
    late final StreamSubscription<AuthState> sub;
    bool navigated = false;

    sub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery && !navigated) {
        navigated = true;
        sub.cancel();
        _goToReset();
        if (!completer.isCompleted) completer.complete();
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!navigated) {
        sub.cancel();
        _goToStart();
        if (!completer.isCompleted) completer.complete();
      }
    });

    await completer.future;
  }

  void _goToStart() {
    _navKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StartScreen()),
      (_) => false,
    );
  }

  void _goToReset() {
    _navKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const NewPasswordScreen()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _deeplinkSub?.cancel();
    _authSubPersistent?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      title: 'Mein Handwerker-App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            minimumSize: const Size(250, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          headlineSmall: TextStyle(fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: const TextStyle(color: Colors.deepPurple),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
        Locale('fr'),
        Locale('es'),
        Locale('tr'),
        Locale('it'),
        Locale('nl'),
      ],
      home: const StartScreen(),
    );
  }
}
