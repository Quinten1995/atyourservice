import 'package:flutter/material.dart';
import 'update_checker.dart';
import '../l10n/app_localizations.dart';

class UpdateGate extends StatefulWidget {
  final Widget child;
  final Uri configUrl;

  const UpdateGate({super.key, required this.child, required this.configUrl});

  @override
  State<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends State<UpdateGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    try {
      final app = await currentVersion();
      final cfg = await fetchUpdateInfo(widget.configUrl);

      // Lokalisierte Fallback-Texte (Server message überschreibt, wenn vorhanden)
      final l = AppLocalizations.of(context)!;
      final requiredTitle = l.update_required_title;
      final requiredMsg = (cfg.message?.trim().isNotEmpty ?? false)
          ? cfg.message!.trim()
          : l.update_required_message;

      final availableTitle = l.update_available_title;
      final availableMsg = (cfg.message?.trim().isNotEmpty ?? false)
          ? cfg.message!.trim()
          : l.update_available_message;

      if (app < cfg.minSupported) {
        if (!mounted) return;
        await showDialog(
          context: context,
          barrierDismissible: false, // Zwangsupdate
          builder: (_) => AlertDialog(
            title: Text(requiredTitle),
            content: Text(requiredMsg),
            actions: [
              TextButton(
                onPressed: () => openStore(cfg),
                child: Text(l.update_action_update_now),
              ),
            ],
          ),
        );
      } else if (app < cfg.latest) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(availableTitle),
            content: Text(availableMsg),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.update_action_later),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openStore(cfg);
                },
                child: Text(l.update_action_update_now),
              ),
            ],
          ),
        );
      }
    } catch (_) {
      // still weiter (offline/Timeout/etc.)
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
