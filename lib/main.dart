import 'package:flutter/material.dart';
import 'utils/supabase_client.dart'; // Supabase Client Manager
import 'screens/start_screen.dart';  // StartScreen importieren

// NEU: Firebase-Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Zuerst Firebase initialisieren
  await Firebase.initializeApp();
  // Dann Supabase initialisieren
  await SupabaseClientManager.init();

  // NEU: FCM-Token ausgeben (zu Testzwecken)
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $fcmToken');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            borderSide: const BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: const TextStyle(color: Colors.deepPurple),
        ),
      ),
      home: const StartScreen(),
      // home: const SupabaseTestScreen(), // Zum Testen
    );
  }
}

// (SupabaseTestScreen bleibt unverändert)
