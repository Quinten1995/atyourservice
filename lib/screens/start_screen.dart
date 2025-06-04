import 'package:flutter/material.dart';
import 'login_kunde_screen.dart';
import 'login_dienstleister_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Die Hauptfarbe kannst du bei Bedarf global definieren
    const primaryColor = Color(0xFF3876BF); // Modernes, ruhiges Blau
    const accentColor = Color(0xFFE7ECEF);  // Sehr helles Grau/Blau als Hintergrund

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text('atyourservice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Optional: Platz für ein Logo
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 24.0),
              //   child: Image.asset('assets/logo.png', height: 80),
              // ),
              Text(
                'Willkommen!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),

              // Kunden-Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginKundeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                    shadowColor: primaryColor.withOpacity(0.25),
                  ),
                  child: const Text(
                    'Ich suche Hilfe (Kunde)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 0.3),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Dienstleister-Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginDienstleisterScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: primaryColor, width: 1.5),
                    ),
                    elevation: 3,
                    shadowColor: primaryColor.withOpacity(0.13),
                  ),
                  child: const Text(
                    'Ich biete Hilfe an (Dienstleister)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
