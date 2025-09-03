// lib/utils/push_tokens.dart
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> upsertPushToken(SupabaseClient supabase) async {
  final fcm = FirebaseMessaging.instance;
  await fcm.requestPermission(); // iOS: Alert/Badge/Sound erlauben
  final token = await fcm.getToken();
  if (token == null) return;

  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return;

  // schreibt nur in users.push_token (vorhandenes Feld)
  await supabase.from('users').update({'push_token': token}).eq('id', uid);
}
