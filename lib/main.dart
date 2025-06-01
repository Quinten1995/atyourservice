import 'package:flutter/material.dart';
import 'utils/supabase_client.dart'; // Supabase Client Manager
import 'screens/start_screen.dart';  // StartScreen importieren

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientManager.init(); // Supabase initialisieren
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
      home: const StartScreen(), // Hier StartScreen als Startseite nutzen
      // Zum Testen kannst du vorübergehend wechseln auf:
      // home: const SupabaseTestScreen(),
    );
  }
}

class SupabaseTestScreen extends StatelessWidget {
  const SupabaseTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Test')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Teste Supabase Verbindung'),
          onPressed: () async {
            try {
              final data = await SupabaseClientManager.client
                  .from('users')
                  .select()
                  .maybeSingle();

              if (data == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Keine Nutzer gefunden')),
                );
              } else if (data is List) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erfolg! Anzahl Nutzer: ${data.length}')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erfolg! Nutzer gefunden')),
                );
              }
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fehler: $error')),
              );
            }
          },
        ),
      ),
    );
  }
}



















