import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumLegalSection extends StatelessWidget {
  const PremiumLegalSection({super.key});

  static const String _privacyUrl =
      'https://docs.google.com/document/d/1JaU8nbM4EApHyEGhNglIIJeVkfTlR-O-sGaXN89q2qQ/edit?usp=drive_link';

  static const String _termsUrl =
      'https://docs.google.com/document/d/1PVqJMQAHNB_EfNGsdCoipzlaKQ7GMtNyU5k5S-GEqq8/edit?usp=drive_link';

  Future<void> _open(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          decoration: TextDecoration.underline,
          color: Theme.of(context).colorScheme.primary,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            InkWell(
              onTap: () => _open(_privacyUrl, context),
              child: Text('Privacy Policy', style: linkStyle),
            ),
            InkWell(
              onTap: () => _open(_termsUrl, context),
              child: Text('Terms of Use (EULA)', style: linkStyle),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Subscriptions renew automatically unless canceled at least 24 hours before the end '
          'of the current period. Manage or cancel your subscription in the device settings '
          'under Apple ID → Subscriptions. Payment will be charged to your Apple account.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
