import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
      iOS: const DarwinNotificationDetails(),
    );

    await _fln.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: data?.toString(),
    );
  }

  /// Alle sichtbaren System-Notifications löschen
  static Future<void> clearAll() async {
    try {
      await _fln.cancelAll();
      // Hinweis: In deiner Plugin-Version gibt es kein iOS setBadgeCount().
      // Falls du die Badge auch auf iOS auf 0 setzen willst, brauchst du
      // entweder ein Plugin wie `flutter_app_badger` ODER ein Update auf
      // neuere flutter_local_notifications (dann per Darwin-Plugin möglich).
    } catch (_) {}
  }
}
