import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDescription = 'Heads-Up Banner for critical alerts';

  static final FlutterLocalNotificationsPlugin _fln =
      FlutterLocalNotificationsPlugin();

  /// Initialisiert Local Notifications & legt den Channel an
  static Future<void> init() async {
    // Android Init Settings (Notification-Icon muss in res/drawable liegen)
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/ic_stat_notification');

    const InitializationSettings settings =
        InitializationSettings(android: androidInit);

    await _fln.initialize(settings);

    // High-Importance Channel erstellen
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.max, // Wichtig: max für Heads-Up
      playSound: true,
      enableVibration: true,
    );

    await _fln
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Android 13+ → Push-Berechtigung anfragen
    if (Platform.isAndroid) {
      final fm = FirebaseMessaging.instance;
      final settings = await fm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (kDebugMode) {
        print('Push permission: ${settings.authorizationStatus}');
      }
    }
  }

  /// Zeigt eine Heads-Up Notification im Vordergrund
  static Future<void> showForegroundNotification({
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
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

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _fln.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: data != null ? data.toString() : null,
    );
  }
}
