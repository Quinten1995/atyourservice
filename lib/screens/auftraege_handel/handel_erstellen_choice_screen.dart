// lib/screens/auftraege_handel/handel_erstellen_choice_screen.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'handel_erstellen_screen.dart'; // S0 (bestehend)
import 'handel_erstellen_s1_screen.dart'; // S1 (neu) – Stelle sicher, dass diese Datei/der Screen existiert

class HandelErstellenChoiceScreen extends StatelessWidget {
  const HandelErstellenChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createDealTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              l10n.chooseDealTypeTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _ChoiceTile(
              title: l10n.dealTypeS0Title,
              subtitle: l10n.dealTypeS0Subtitle,
              icon: Icons.swap_horiz,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HandelErstellenScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _ChoiceTile(
              title: l10n.dealTypeS1Title,
              subtitle: l10n.dealTypeS1Subtitle,
              icon: Icons.account_tree, // oder Icons.handyman
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HandelErstellenS1Screen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _ChoiceTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
