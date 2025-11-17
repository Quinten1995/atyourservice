import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDescription =
      'Heads-Up Banner for critical alerts';

  static final FlutterLocalNotificationsPlugin _fln =
      FlutterLocalNotificationsPlugin();

  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Initialisiert Local Notifications & FCM (Android + iOS)
  static Future<void> init() async {
    // iOS + Android Init
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _fln.initialize(initSettings);

    // iOS: Banner/Sound/Badge auch im Vordergrund zeigen
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // iOS & Android: Permission anfragen
    final perm = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    if (kDebugMode) {
      print('🔔 FCM permission: ${perm.authorizationStatus}');
    }

    // Android: High-Importance Channel anlegen (Heads-Up)
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      await _fln
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }
  }

  /// Heads-Up (Android) / normale (iOS) Notification im Vordergrund
  static Future<void> showForegroundNotification({
    required String title,
    required String body,
    Map<String, String>? data,
    int? id,
  }) async {
    final details = NotificationDetails(
      android: const AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        ticker: 'ticker',
      ),
      iOS: const DarwinNotificationDetails(
        // Wichtig: im Foreground Badge NICHT erhöhen
        presentBadge: false,
      ),
    );

    await _fln.show(
      id ?? (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      title,
      body,
      details,
      payload: data?.toString(),
    );
  }

  /// Alle sichtbaren System-Notifications löschen UND App-Badge entfernen
  static Future<void> clearAll() async {
    try {
      await _fln.cancelAll(); // Android & iOS: Tray leeren
    } catch (_) {}

    try {
      final supported = await FlutterAppBadger.isAppBadgeSupported();
      if (supported) {
        FlutterAppBadger.removeBadge();
      }
    } catch (_) {
      // unkritisch
    }
  }

  /// Optional: explizit eine Badge-Zahl setzen (z. B. ungelesene Zähler)
  static Future<void> setBadge(int count) async {
    try {
      final supported = await FlutterAppBadger.isAppBadgeSupported();
      if (!supported) return;
      if (count <= 0) {
        FlutterAppBadger.removeBadge();
      } else {
        FlutterAppBadger.updateBadgeCount(count);
      }
    } catch (_) {
      // unkritisch
    }
  }

  // ---------------------------------------------------------------------------
  // Remote Push über Edge Function `send_push`
  // ---------------------------------------------------------------------------

  /// Generischer Wrapper für deine Edge Function `send_push`.
  /// Nutzt `user_ids`, damit die Function die Tokens aus der users-Tabelle holt.
  static Future<void> sendRemotePush({
    required String userId,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      await _supabase.functions.invoke(
        'send_push',
        body: {
          // WICHTIG: Array, nicht user_id!
          'user_ids': [userId],
          'title': title,
          'body': body,
          if (data != null) 'data': data,
        },
      );
    } catch (e, st) {
      if (kDebugMode) {
        print('❌ sendRemotePush error: $e');
        print(st);
      }
    }
  }

  /// Push an Verkäufer: neue Bewerbung auf seinen Deal (S0 oder S1)
  static Future<void> sendNewApplicationForDeal({
    required String sellerUserId,
    required String dealId,
    required String dealTitle,
    required String applicantName,
    required bool isS1,
  }) async {
    final title = isS1
        ? 'Neue Bewerbung für deinen S1-Auftrag'
        : 'Neue Bewerbung für deinen Auftrag';
    final body = '$applicantName hat sich auf "$dealTitle" beworben.';

    await sendRemotePush(
      userId: sellerUserId,
      title: title,
      body: body,
      data: {'type': 'deal_application_new', 'deal_id': dealId},
    );
  }

  /// Push an DL: er wurde für einen Deal beauftragt
  static Future<void> sendDealAwardedPush({
    required String receiverUserId,
    required String dealId,
    required String dealTitle,
    required bool isS1,
  }) async {
    final title = isS1
        ? 'Du wurdest für einen S1-Auftrag beauftragt'
        : 'Du wurdest beauftragt';
    final body = 'Du hast den Auftrag "$dealTitle" erhalten.';

    await sendRemotePush(
      userId: receiverUserId,
      title: title,
      body: body,
      data: {'type': 'deal_awarded', 'deal_id': dealId},
    );
  }
}
