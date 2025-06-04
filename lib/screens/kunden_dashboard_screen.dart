import 'package:flutter/material.dart';
import 'auftrag_erstellen_screen.dart';
import 'meine_auftraege_screen.dart';

class KundenDashboardScreen extends StatelessWidget {
  const KundenDashboardScreen({Key? key}) : super(key: key);

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text('Kunden-Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Willkommen im Kundenbereich!',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 40),

              // Button: Neuer Auftrag
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AuftragErstellenScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, size: 24),
                  label: const Text(
                    'Neuen Auftrag erstellen',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 5,
                    shadowColor: primaryColor.withOpacity(0.18),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Button: Meine Aufträge
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MeineAuftraegeScreen()),
                    );
                  },
                  icon: const Icon(Icons.assignment, size: 24),
                  label: const Text(
                    'Meine Aufträge',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 3,
                    shadowColor: primaryColor.withOpacity(0.10),
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
