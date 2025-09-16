import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class NotificationService {
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDescription =
      'Heads-Up Banner for critical alerts';

  static final FlutterLocalNotificationsPlugin _fln =
      FlutterLocalNotificationsPlugin();

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
      // Android & iOS: Tray leeren
      await _fln.cancelAll();
    } catch (_) {}

    // iOS & (viele) Android-Launcher: Badge zurücksetzen
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
    } catch (_) {}
  }
}
