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

  /// Initialisiert Local Notifications (Android + iOS) und legt Channels an
  static Future<void> init() async {
    // --- Android ---
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/ic_stat_notification');

    // --- iOS (Darwin) ---
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      // Ab iOS 10: System fragt zur Laufzeit – wir setzen hier die Defaults
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // --- Gemeinsame Initialisierung ---
    const InitializationSettings settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _fln.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse resp) {
        if (kDebugMode) {
          print('LocalNotification tapped: ${resp.payload}');
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // --- Android Channel (Heads-Up) ---
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

    // --- Berechtigungen anfragen ---
    // Android 13+ & iOS brauchen explizite Permission
    final fm = FirebaseMessaging.instance;
    final perm = await fm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      provisional: false,
      criticalAlert: false,
    );
    if (kDebugMode) {
      print('Push permission: ${perm.authorizationStatus}');
    }

    // iOS: Foreground-Push sichtbar machen (Banner/Ton/Badezahl)
    // (Auf Android ignoriert)
    await fm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Zeigt eine Heads-Up Notification im Vordergrund (beide Plattformen)
  static Future<void> showForegroundNotification({
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    // Android Details
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          ticker: 'ticker',
        );

    // iOS Details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _fln.show(
      // einfache eindeutige ID
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: data != null ? data.toString() : null,
    );
  }
}

// Background-Handler für Taps auf Notifications (optional)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse resp) {
  if (kDebugMode) {
    print('Background notification tapped: ${resp.payload}');
  }
}
