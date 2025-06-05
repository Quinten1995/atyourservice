import 'package:flutter/material.dart';
import 'login_kunde_screen.dart';
import 'login_dienstleister_screen.dart';
import 'impressum_screen.dart';
import 'datenschutz_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rechtliches'),
        content: const Text('Hier findest du das Impressum und die Datenschutzerklärung.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ImpressumScreen()),
              );
            },
            child: const Text('Impressum'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DatenschutzScreen()),
              );
            },
            child: const Text('Datenschutz'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), // Dialog schließen
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3876BF);
    const accentColor = Color(0xFFE7ECEF);

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text(
          'atyourservice',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Rechtliches',
            onPressed: () => _showInfoDialog(context),
            color: primaryColor,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
