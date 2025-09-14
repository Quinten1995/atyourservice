import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AchievementScreen extends StatelessWidget {
  final String aboTyp;
  final bool isTopBewertet;
  final int completedJobsCount;

  // Thresholds (final)
  static const int _tCertified = 3;
  static const int _tExperienced = 10;
  static const int _tExpert = 25;
  static const int _tMaster = 50;

  const AchievementScreen({
    Key? key,
    required this.aboTyp,
    required this.isTopBewertet,
    required this.completedJobsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Titel oben OHNE Zähler (nur Labels). Unten: Progressbar + "x / y".
    final List<_AchievementBadge> allBadges = [
      // Gold
      _AchievementBadge(
        icon: Icons.workspace_premium,
        title: l10n.goldBadgeLabel,
        description: l10n.goldBadgeDesc,
        unlocked: aboTyp == 'gold',
        progress: aboTyp == 'gold' ? 1.0 : 0.0,
      ),
      // Silver
      _AchievementBadge(
        icon: Icons.workspace_premium,
        title: l10n.silverBadgeLabel,
        description: l10n.silverBadgeDesc,
        unlocked: aboTyp == 'silver',
        progress: aboTyp == 'silver' ? 1.0 : 0.0,
      ),
      // Top bewertet
      _AchievementBadge(
        icon: Icons.star,
        title: l10n.topBewertetBadgeLabel,
        description: l10n.topBewertetBadgeDesc,
        unlocked: isTopBewertet,
        progress: isTopBewertet ? 1.0 : 0.0,
      ),

      // Certified (>= 3)
      _AchievementBadge(
        icon: Icons.verified,
        title: l10n.badgeCertified, // ← nur Label
        description: l10n.badgeCertifiedDesc,
        unlocked: completedJobsCount >= _tCertified,
        progress: (completedJobsCount / _tCertified).clamp(0, 1).toDouble(),
        progressText:
            "${completedJobsCount.clamp(0, _tCertified)} / $_tCertified",
      ),
      // Experienced (>= 10)
      _AchievementBadge(
        icon: Icons.star_half,
        title: l10n.badgeExperienced, // ← nur Label
        description: l10n.badgeExperiencedDesc,
        unlocked: completedJobsCount >= _tExperienced,
        progress: (completedJobsCount / _tExperienced).clamp(0, 1).toDouble(),
        progressText:
            "${completedJobsCount.clamp(0, _tExperienced)} / $_tExperienced",
      ),
      // Expert (>= 25)
      _AchievementBadge(
        icon: Icons.star,
        title: l10n.badgeExpert, // ← nur Label
        description: l10n.badgeExpertDesc,
        unlocked: completedJobsCount >= _tExpert,
        progress: (completedJobsCount / _tExpert).clamp(0, 1).toDouble(),
        progressText: "${completedJobsCount.clamp(0, _tExpert)} / $_tExpert",
      ),
      // Master (>= 50)
      _AchievementBadge(
        icon: Icons.military_tech,
        title: l10n.badgeMaster, // ← nur Label
        description: l10n.badgeMasterDesc,
        unlocked: completedJobsCount >= _tMaster,
        progress: (completedJobsCount / _tMaster).clamp(0, 1).toDouble(),
        progressText: "${completedJobsCount.clamp(0, _tMaster)} / $_tMaster",
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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        itemCount: allBadges.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, i) {
          final badge = allBadges[i];
          return Card(
            elevation: badge.unlocked ? 6 : 2,
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
                      color: badge.unlocked
                          ? Colors.amber[50]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(13),
                    ),
                    padding: const EdgeInsets.all(13),
                    child: Icon(
                      badge.icon,
                      color: badge.unlocked ? Colors.amber[800] : Colors.grey,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Oben: nur Titel (ohne Zähler)
                        Text(
                          badge.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: badge.unlocked
                                ? Colors.black
                                : Colors.grey[500],
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
                        if (badge.progress != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 7, right: 20),
                            child: LinearProgressIndicator(
                              value: badge.progress!,
                              backgroundColor: Colors.grey[300],
                              color: badge.unlocked
                                  ? Colors.green
                                  : Colors.blueGrey,
                              minHeight: 7,
                            ),
                          ),
                        if (badge.progressText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              badge.progressText!,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (badge.unlocked)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AchievementBadge {
  final IconData icon;
  final String title; // oben: nur Label (ohne Zähler)
  final String description;
  final bool unlocked;
  final double? progress; // Fortschrittsbalken (null = keiner)
  final String? progressText; // z. B. "2 / 10"

  _AchievementBadge({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
    this.progress,
    this.progressText,
  });
}
