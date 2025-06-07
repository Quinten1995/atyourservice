import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your Premium Plan',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 22),
            _planCard(
              context,
              title: 'SILVER',
              color: Colors.grey[200]!,
              badge: Icons.verified,
              priceText: '€ 4.99 / month',
              features: const [
                'Auftragsradius: 30 km',
                'Normale Sichtbarkeit',
                'Standard Support',
              ],
              onTap: () {
                // Hier später echte IAP-Logik für Silver einbauen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Silver purchase coming soon!')),
                );
              },
            ),
            const SizedBox(height: 18),
            _planCard(
              context,
              title: 'GOLD',
              color: Colors.amber[200]!,
              badge: Icons.workspace_premium,
              priceText: '€ 9.99 / month',
              features: const [
                'Auftragsradius: 70 km',
                'Hervorgehobenes Profil',
                'Premium Support',
              ],
              onTap: () {
                // Hier später echte IAP-Logik für Gold einbauen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gold purchase coming soon!')),
                );
              },
            ),
            const SizedBox(height: 34),
            const Text(
              'Hinweis: Alle Zahlungen werden sicher über Apple oder Google abgewickelt. Du kannst dein Abo jederzeit im Store kündigen oder verwalten.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planCard(
    BuildContext context, {
    required String title,
    required Color color,
    required IconData badge,
    required String priceText,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(badge, color: Colors.amber[800], size: 30),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  priceText,
                  style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                      const SizedBox(width: 7),
                      Text(f, style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                )),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                child: Text('Choose $title'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
