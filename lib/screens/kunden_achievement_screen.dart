import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class KundenAchievementScreen extends StatelessWidget {
  const KundenAchievementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Die Badge-Liste für den Kunden – KEIN Fortschrittsbalken, ALLE sind sichtbar
    final List<_AchievementBadge> badges = [
      _AchievementBadge(
        icon: Icons.workspace_premium,
        title: l10n.goldBadgeLabel,
        description: l10n.goldBadgeDesc,
        color: Colors.amber[700],
      ),
      _AchievementBadge(
        icon: Icons.workspace_premium,
        title: l10n.silverBadgeLabel,
        description: l10n.silverBadgeDesc,
        color: Colors.grey[600],
      ),
      _AchievementBadge(
        icon: Icons.star,
        title: l10n.topBewertetBadgeLabel,
        description: l10n.topBewertetBadgeDesc,
        color: Colors.amber,
      ),
      _AchievementBadge(
        icon: Icons.verified,
        title: l10n.badgeCertified,
        description: l10n.badgeCertifiedDesc,
        color: Colors.lightBlue[700],
      ),
      _AchievementBadge(
        icon: Icons.star_half,
        title: l10n.badgeExperienced,
        description: l10n.badgeExperiencedDesc,
        color: Colors.orange[800],
      ),
      _AchievementBadge(
        icon: Icons.star,
        title: l10n.badgeExpert,
        description: l10n.badgeExpertDesc,
        color: Colors.deepPurple[400],
      ),
      _AchievementBadge(
        icon: Icons.military_tech,
        title: l10n.badgeMaster,
        description: l10n.badgeMasterDesc,
        color: Colors.green[700],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.achievementTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          // Kleine Info ganz oben
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              l10n.badgeInfoText,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          // Liste der Badges
          ListView.separated(
            shrinkWrap: true,
            itemCount: badges.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (context, i) {
              final badge = badges[i];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: badge.color?.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        padding: const EdgeInsets.all(13),
                        child: Icon(badge.icon, color: badge.color, size: 32),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              badge.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              badge.description,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// internes Modell für die Anzeige eines Badges (nur hier genutzt)
class _AchievementBadge {
  final IconData icon;
  final String title;
  final String description;
  final Color? color;

  _AchievementBadge({
    required this.icon,
    required this.title,
    required this.description,
    this.color,
  });
}
