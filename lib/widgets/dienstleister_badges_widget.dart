import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class DienstleisterBadgesHelper {
  final String aboTyp;
  final bool isTopBewertet;
  final int completedJobsCount;

  DienstleisterBadgesHelper({
    required this.aboTyp,
    this.isTopBewertet = false,
    this.completedJobsCount = 0,
  });

  /// Standard-Badges für AuftragDetailScreen: nur aktueller Counter (z.B. "Erfahren (7)")
  List<Widget> buildBadges(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final badges = <Widget>[];

    // 1. Abo-Badges
    if (aboTyp == 'gold') {
      badges.add(_buildBadge(
        icon: Icons.workspace_premium,
        text: l10n.goldBadgeLabel,
        color: Colors.amber[800]!,
        background: Colors.amber[100]!,
      ));
    } else if (aboTyp == 'silver') {
      badges.add(_buildBadge(
        icon: Icons.workspace_premium,
        text: l10n.silverBadgeLabel,
        color: Colors.blueGrey[400]!,
        background: Colors.grey[200]!,
      ));
    }

    // 2. Bewertungs-Badge
    if (isTopBewertet) {
      badges.add(_buildBadge(
        icon: Icons.star,
        text: l10n.topBewertetBadgeLabel,
        color: Colors.deepOrange[400]!,
        background: Colors.orange[50]!,
      ));
    }

    // 3. Auftrags-Meilenstein-Badges (immer aktueller Counter)
    if (completedJobsCount >= kMaster) {
      badges.add(_buildBadge(
        icon: Icons.military_tech,
        text: l10n.badgeMasterCounter(completedJobsCount),
        color: const Color(0xFF7B5E00),
        background: const Color(0xFFFFF6D1),
      ));
    } else if (completedJobsCount >= kExperte) {
      badges.add(_buildBadge(
        icon: Icons.star,
        text: l10n.badgeExpertCounter(completedJobsCount),
        color: Colors.amber[800]!,
        background: Colors.amber[100]!,
      ));
    } else if (completedJobsCount >= kErfahren) {
      badges.add(_buildBadge(
        icon: Icons.star_half,
        text: l10n.badgeExperiencedCounter(completedJobsCount),
        color: Colors.grey[600]!,
        background: Colors.grey[200]!,
      ));
    } else if (completedJobsCount >= kZertifiziert) {
      badges.add(_buildBadge(
        icon: Icons.verified,
        text: l10n.badgeCertifiedCounter(completedJobsCount),
        color: Colors.blue[700]!,
        background: Colors.blue[50]!,
      ));
    }

    return badges;
  }

  /// Badges mit Fortschritt & Balken, für AchievementScreen
  List<Widget> buildBadgesWithProgress(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<_BadgeData> badgeData = [
      _BadgeData(
        icon: Icons.verified,
        count: completedJobsCount,
        needed: kZertifiziert,
        labelBuilder: l10n.badgeCertifiedProgress,
        color: Colors.blue[700]!,
        background: Colors.blue[50]!,
      ),
      _BadgeData(
        icon: Icons.star_half,
        count: completedJobsCount,
        needed: kErfahren,
        labelBuilder: l10n.badgeExperiencedProgress,
        color: Colors.grey[600]!,
        background: Colors.grey[200]!,
      ),
      _BadgeData(
        icon: Icons.star,
        count: completedJobsCount,
        needed: kExperte,
        labelBuilder: l10n.badgeExpertProgress,
        color: Colors.amber[800]!,
        background: Colors.amber[100]!,
      ),
      _BadgeData(
        icon: Icons.military_tech,
        count: completedJobsCount,
        needed: kMaster,
        labelBuilder: l10n.badgeMasterProgress,
        color: const Color(0xFF7B5E00),
        background: const Color(0xFFFFF6D1),
      ),
    ];

    return badgeData.map((data) {
      final unlocked = data.count >= data.needed;
      final progress = (data.count / data.needed).clamp(0, 1).toDouble();
      final progressText = "${data.count.clamp(0, data.needed)} / ${data.needed}";
      return _buildBadgeWithProgress(
        icon: data.icon,
        text: data.labelBuilder(data.count),
        color: data.color,
        background: data.background,
        progress: progress,
        progressText: progressText,
        unlocked: unlocked,
      );
    }).toList();
  }

  static const int kZertifiziert = 1;
  static const int kErfahren = 2;
  static const int kExperte = 3;
  static const int kMaster = 4;

  Widget _buildBadge({
    required IconData icon,
    required String text,
    required Color color,
    required Color background,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.28), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeWithProgress({
    required IconData icon,
    required String text,
    required Color color,
    required Color background,
    required double progress,
    required String progressText,
    required bool unlocked,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 6.0, right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.28), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                width: 70,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  color: unlocked ? Colors.green : Colors.blueGrey,
                  minHeight: 5,
                ),
              ),
              Text(
                progressText,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (unlocked) ...[
            const SizedBox(width: 8),
            const Icon(Icons.check_circle, color: Colors.green, size: 18),
          ],
        ],
      ),
    );
  }
}

/// Interne Hilfsklasse für Fortschrittsdaten (nur für buildBadgesWithProgress)
class _BadgeData {
  final IconData icon;
  final int count;
  final int needed;
  final String Function(int) labelBuilder;
  final Color color;
  final Color background;

  _BadgeData({
    required this.icon,
    required this.count,
    required this.needed,
    required this.labelBuilder,
    required this.color,
    required this.background,
  });
}
