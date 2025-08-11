import 'dart:async';
import 'package:flutter/material.dart';

// Supabase + Screens
import 'utils/supabase_client.dart';
import 'screens/start_screen.dart';
import 'screens/new_password_screen.dart'; // ✅ korrekter Dateiname

// Deeplink mit app_links
import 'package:app_links/app_links.dart';

// Lokalisierung
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';

// Supabase
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientManager.init();
  runApp(const MyApp());
}

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

    // 2) Laufende Deeplinks (App im Vorder-/Hintergrund)
    _deeplinkSub = _appLinks.uriLinkStream.listen((uri) {
      _handleIncomingUri(uri);
    }, onError: (_) {});

    // 3) Persistenter Listener (falls Event vor Navigation kommt)
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

    // 1) Versuche, die Session direkt aus der URL zu setzen (wichtig!)
    try {
      await Supabase.instance.client.auth
          .getSessionFromUrl(incoming, storeSession: true);
    } catch (_) {
      // kann passieren, z. B. wenn Fragment fehlt – wir haben unten Fallback
    }

    // 2) Wenn eindeutig "recovery" → direkt Reset-Screen
    final t = _supabaseType(incoming);
    if (t == 'recovery') {
      _goToReset();
      return;
    }

    // 3) Fallback: kurz (bis 2s) aufs passwordRecovery-Event warten,
    //    falls Android den Fragment-Teil verschluckt hat
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
        _goToStart(); // kein Recovery → normaler Start
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
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
