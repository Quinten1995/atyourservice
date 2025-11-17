// lib/screens/auftraege_handel/deal_manage_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import 'package:atyourservice/services/deals_service.dart';
import 'handel_erstellen_screen.dart';

class DealManageScreen extends StatefulWidget {
  final Map<String, dynamic> deal;
  const DealManageScreen({super.key, required this.deal});

  @override
  State<DealManageScreen> createState() => _DealManageScreenState();
}

class _DealManageScreenState extends State<DealManageScreen> {
  static const Color _brandPrimary = Color(0xFF3876BF);
  static const double _cardRadius = 14;
  static const double _chipSpacing = 8;
  static const EdgeInsets _cardPad = EdgeInsets.all(16);

  bool _loading = true;
  List<Map<String, dynamic>> _apps = [];

  Map<String, dynamic>? _deal;
  Map<String, dynamic>? _s0;
  Map<String, dynamic>? _s1;
  Map<String, dynamic>? _ver;

  @override
  void initState() {
    super.initState();
    _deal = Map<String, dynamic>.from(widget.deal);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _markApplicationsSeen(),
    );
    _load();
  }

  String get _dealId => (_deal?['id'] ?? widget.deal['id']).toString();

  Future<void> _markApplicationsSeen() async {
    try {
      final supa = Supabase.instance.client;
      final uid = supa.auth.currentUser?.id;
      if (uid == null) return;
      await supa.from('deal_inbox_state').upsert({
        'user_id': uid,
        'deal_id': _dealId,
        'last_seen_apps_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {
      /* ignore */
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final supa = Supabase.instance.client;
    final svc = DealsService(supa);

    try {
      final row = await supa
          .from('deals')
          .select('*, deal_s0(*), deal_s1(*), verifications(*)')
          .eq('id', _dealId)
          .single();

      final rawApps = await svc.fetchApplicationsForDeal(_dealId);

      // ---- Bewerber-Namen auflösen ----
      final buyerNames = <String, String>{};

      try {
        final buyerIds = rawApps
            .map((a) => (a['buyer_id'] ?? '').toString())
            .where((id) => id.isNotEmpty)
            .toSet()
            .toList();

        if (buyerIds.isNotEmpty) {
          // 1) dienstleister_details via user_id
          final dlByUser = await supa
              .from('dienstleister_details')
              .select('user_id, company_name, name')
              .inFilter('user_id', buyerIds);

          for (final r in (dlByUser as List? ?? [])) {
            final m = Map<String, dynamic>.from(r as Map);
            final uid = (m['user_id'] ?? '').toString();
            if (uid.isEmpty) continue;
            final comp = (m['company_name'] ?? '').toString().trim();
            final nm = (m['name'] ?? '').toString().trim();
            final label = comp.isNotEmpty ? comp : (nm.isNotEmpty ? nm : '');
            if (label.isNotEmpty) buyerNames[uid] = label;
          }

          // 2) dienstleister_details via id
          final missingAfterUser = buyerIds
              .where((id) => !buyerNames.containsKey(id))
              .toList();
          if (missingAfterUser.isNotEmpty) {
            final dlById = await supa
                .from('dienstleister_details')
                .select('id, company_name, name')
                .inFilter('id', missingAfterUser);

            for (final r in (dlById as List? ?? [])) {
              final m = Map<String, dynamic>.from(r as Map);
              final id = (m['id'] ?? '').toString();
              if (id.isEmpty || buyerNames.containsKey(id)) continue;
              final comp = (m['company_name'] ?? '').toString().trim();
              final nm = (m['name'] ?? '').toString().trim();
              final label = comp.isNotEmpty ? comp : (nm.isNotEmpty ? nm : '');
              if (label.isNotEmpty) buyerNames[id] = label;
            }
          }

          // 3) users-Fallback
          final stillMissing = buyerIds
              .where((id) => !buyerNames.containsKey(id))
              .toList();
          if (stillMissing.isNotEmpty) {
            final userRows = await supa
                .from('users')
                .select('id, full_name, email')
                .inFilter('id', stillMissing);

            for (final r in (userRows as List? ?? [])) {
              final m = Map<String, dynamic>.from(r as Map);
              final id = (m['id'] ?? '').toString();
              if (id.isEmpty || buyerNames.containsKey(id)) continue;

              final full = (m['full_name'] ?? '').toString().trim();
              final mail = (m['email'] ?? '').toString().trim();

              if (full.isNotEmpty) {
                buyerNames[id] = full;
              } else if (mail.isNotEmpty) {
                buyerNames[id] = mail;
              }
            }
          }
        }
      } catch (_) {
        /* soft-fail */
      }

      if (!mounted) return;
      setState(() {
        _deal = Map<String, dynamic>.from(row as Map);
        _s0 = (_deal?['deal_s0'] as Map?)?.cast<String, dynamic>();
        _s1 = (_deal?['deal_s1'] as Map?)?.cast<String, dynamic>();
        _ver = (_deal?['verifications'] as Map?)?.cast<String, dynamic>();

        _apps = rawApps.map<Map<String, dynamic>>((a) {
          final m = Map<String, dynamic>.from(a as Map);
          final buyerId = (m['buyer_id'] ?? '').toString();

          final fromSvc =
              (m['buyer_display'] ?? m['buyer_name'] ?? m['buyer_email'])
                  ?.toString()
                  .trim();

          if (fromSvc != null && fromSvc.isNotEmpty) {
            m['buyer_display'] = fromSvc;
          } else if (buyerId.isNotEmpty && buyerNames.containsKey(buyerId)) {
            m['buyer_display'] = buyerNames[buyerId];
          } else if (buyerId.isNotEmpty) {
            m['buyer_display'] = buyerId; // letzter Fallback
          } else {
            m['buyer_display'] = '—';
          }

          return m;
        }).toList();

        _loading = false;
      });

      _markApplicationsSeen();
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.manageErrorLoading)));
    }
  }

  // ===== Publish-Check =====

  List<String> _missingForPublish(AppLocalizations l10n) {
    final d = _deal ?? {};
    final s0 = _s0;
    final s1 = _s1;
    final ver = _ver ?? {};

    final missing = <String>[];

    String requireNonEmpty(String key, String labelKey) {
      final v = (d[key] ?? '').toString().trim();
      if (v.isEmpty) missing.add(labelKey);
      return v;
    }

    requireNonEmpty('title', l10n.fieldTitle);
    requireNonEmpty('description', l10n.fieldDescription);
    requireNonEmpty('location_text', l10n.fieldLocation);
    requireNonEmpty('category', l10n.fieldCategory);

    if ((d['start_after'] ?? '').toString().isEmpty) {
      missing.add(l10n.pickStartDate);
    }
    if ((d['deadline'] ?? '').toString().isEmpty) {
      missing.add(l10n.pickDeadline);
    }

    final lat = (d['location_lat'] as num?)?.toDouble();
    final lng = (d['location_lng'] as num?)?.toDouble();
    if (lat == null || lng == null) {
      missing.add(l10n.coordMissingLabel);
    }

    if ((d['type'] ?? '') == 's0') {
      if (s0 == null) {
        missing.add(l10n.s0DetailsMissingLabel);
      } else {
        final tp = s0['target_price_cents'];
        if (tp is! int || tp <= 0) {
          missing.add(l10n.fieldTargetPriceEur);
        }

        final pv = s0['provision_value'];
        if (pv == null) {
          missing.add(
            s0['provision_type'] == 'percent'
                ? l10n.fieldProvisionValuePercent
                : l10n.fieldProvisionValueFixed,
          );
        }

        if ((s0['provision_due'] ?? 'award') == 'award') {
          final offerUrls =
              (ver['offer_urls'] as List?)?.cast<String>() ?? const [];
          if (offerUrls.isEmpty) {
            missing.add(l10n.infoReqDocForAward);
          }
        }

        final hasOk = ver['has_customer_ok'] == true;
        if (!hasOk) missing.add(l10n.errCustomerOkRequired);
      }
    } else {
      if (s1 == null) {
        missing.add(l10n.s1DetailsMissingLabel);
      } else {
        final mode = (s1['pricing_mode'] ?? 'fixed').toString();
        if (mode == 'fixed') {
          final base = s1['base_price_cents'];
          if (base is! int || base <= 0) {
            missing.add(l10n.basePriceLabel);
          }
        } else {
          final rate = s1['hourly_rate_cents'];
          if (rate is! int || rate <= 0) {
            missing.add(l10n.hourlyRateLabel);
          }
          final eh = s1['expected_hours'];
          if (eh != null && (eh is! num || eh <= 0)) {
            missing.add(l10n.expectedHoursLabel);
          }
        }
      }
    }

    return missing;
  }

  Future<void> _publish() async {
    final l10n = AppLocalizations.of(context)!;
    final missing = _missingForPublish(l10n);
    if (missing.isNotEmpty) {
      await _showPublishChecklist(missing, l10n);
      return;
    }

    final svc = DealsService(Supabase.instance.client);
    try {
      await svc.publishDeal(_dealId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.publishSuccess)));
      Navigator.pop(context, {'changed': true});
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
    }
  }

  Future<void> _showPublishChecklist(
    List<String> items,
    AppLocalizations l10n,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.publishRequirementsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...items.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(t)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _dealIsAwarded({String? expectAppId}) async {
    try {
      final supa = Supabase.instance.client;
      final row = await supa
          .from('deals')
          .select('status, awarded_application_id')
          .eq('id', _dealId)
          .maybeSingle();
      if (row == null) return false;
      final status = (row['status'] ?? '').toString();
      final awardedId = (row['awarded_application_id'] ?? '').toString();
      if (status != 'awarded') return false;
      if (expectAppId == null) return true;
      return awardedId == expectAppId;
    } catch (_) {
      return false;
    }
  }

  Future<void> _award(String applicationId) async {
    final svc = DealsService(Supabase.instance.client);
    final l10n = AppLocalizations.of(context)!;

    bool awardedOk = false;

    try {
      await svc.awardApplication(applicationId);
      awardedOk = true;
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.awardSuccess)));
    } on PostgrestException catch (_) {
      // Fallback: prüfen, ob Award trotzdem in der DB angekommen ist
      final already = await _dealIsAwarded(expectAppId: applicationId);
      if (already && mounted) {
        awardedOk = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.awardSuccess} (already set)')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
      }
    } catch (_) {
      final already = await _dealIsAwarded(expectAppId: applicationId);
      if (already && mounted) {
        awardedOk = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.awardSuccess} (already set)')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
      }
    }

    // Reload getrennt behandeln, damit ein UI-Fehler nicht den Erfolg überdeckt
    if (mounted) {
      try {
        await _load();
      } catch (_) {
        if (awardedOk) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.manageErrorLoading} — view not refreshed'),
            ),
          );
        }
      }
    }
  }

  Future<void> _editDeal() async {
    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => HandelErstellenScreen(existingDeal: _deal),
      ),
    );
    if (!mounted) return;
    if (res != null && res['changed'] == true) {
      await _load();
    } else {
      setState(() {});
    }
  }

  Future<void> _deleteDeal() async {
    final rawStatus = (_deal?['status'] ?? '').toString();
    if (rawStatus == 'awarded') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vergebene Aufträge können nicht gelöscht werden.'),
        ),
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Auftrag löschen?'),
        content: const Text(
          'Dieser Vorgang kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      final svc = DealsService(Supabase.instance.client);
      if (rawStatus == 'live') {
        await svc.unpublishDeal(_dealId);
      }
      await svc.deleteDraft(_dealId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Auftrag gelöscht.')));
      Navigator.pop(context, {'deleted': true});
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.genericError)),
      );
    }
  }

  String _eurFromCents(dynamic c) {
    if (c == null) return '—';
    int cents;
    if (c is int)
      cents = c;
    else if (c is double)
      cents = c.round();
    else
      cents = int.tryParse(c.toString()) ?? 0;
    return '€ ${(cents / 100).toStringAsFixed(2)}';
  }

  (String label, Color bg) _statusL10n(String raw, AppLocalizations l10n) {
    switch (raw) {
      case 'draft':
        return (l10n.statusDraft, Colors.grey.shade200);
      case 'live':
        return (l10n.statusLive, Colors.green.shade100);
      case 'awarded':
        return (l10n.statusAwarded, Colors.orange.shade100);
      default:
        return (raw, Colors.blueGrey.shade100);
    }
  }

  Chip _coordChip(double? lat, double? lng, AppLocalizations l10n) {
    if (lat == null || lng == null) {
      return Chip(
        backgroundColor: Colors.red.shade100,
        label: Text(l10n.coordChipNoCoords),
      );
    }
    return Chip(
      label: Text('${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}'),
    );
  }

  String _targetPriceLabel() {
    if (_s0 != null) {
      return _eurFromCents(_s0!['target_price_cents']);
    }
    if (_s1 != null) {
      final mode = (_s1!['pricing_mode'] ?? 'fixed').toString();
      if (mode == 'fixed') {
        final base = (_s1!['base_price_cents'] ?? 0);
        final baseInt = (base is int) ? base : int.tryParse('$base') ?? 0;
        final vat = (_s1!['vat_rate'] ?? 0.0);
        final vatD = (vat is num) ? vat.toDouble() : 0.0;
        final total = (baseInt * (1 + vatD / 100)).round();
        return _eurFromCents(total);
      } else {
        final rate = _eurFromCents(_s1!['hourly_rate_cents']);
        final hRaw = _s1!['expected_hours'];
        final hours = (hRaw is num) ? hRaw.toDouble() : null;
        final hText = hours != null ? hours.toStringAsFixed(1) : '—';
        return '$rate × $hText h';
      }
    }
    return '—';
  }

  String _provisionLabel() {
    final src = _s0 ?? _s1;
    if (src == null) return '—';
    final t = (src['provision_type'] ?? '').toString();
    final v = src['provision_value'];
    if (t == 'percent') return '${(v ?? 0).toString()} %';
    final cents = (v is num) ? (v * 100).round() : null;
    return _eurFromCents(cents);
  }

  String _applicationDisplayName(Map<String, dynamic> a) {
    final value =
        (a['buyer_display'] ??
                a['buyer_name'] ??
                a['buyer_email'] ??
                a['buyer_id'] ??
                '—')
            .toString()
            .trim();
    return value.isEmpty ? '—' : value;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final d = _deal ?? widget.deal;

    final rawStatus = (d['status'] ?? '').toString();
    final (statusLabel, statusBg) = _statusL10n(rawStatus, l10n);

    final double? locLat = (d['location_lat'] as num?)?.toDouble();
    final double? locLng = (d['location_lng'] as num?)?.toDouble();
    final String locText = (d['location_text'] ?? '').toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manageTitle),
        actions: [
          IconButton(
            tooltip: 'Bearbeiten',
            onPressed: _editDeal,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            tooltip: 'Löschen',
            onPressed: _deleteDeal,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Deal-Karte
                  Material(
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.black12,
                    borderRadius: BorderRadius.circular(_cardRadius),
                    child: Padding(
                      padding: _cardPad,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['title'] ?? '—',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if ((d['description'] ?? '').toString().isNotEmpty)
                            Text(
                              d['description'],
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: _chipSpacing,
                            runSpacing: _chipSpacing,
                            children: [
                              Chip(
                                backgroundColor: statusBg,
                                label: Text(
                                  '${l10n.labelStatus}: $statusLabel',
                                ),
                              ),
                              Chip(
                                label: Text(
                                  l10n.marketplaceChipTargetPrice(
                                    _targetPriceLabel(),
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  l10n.marketplaceChipProvision(
                                    _provisionLabel(),
                                  ),
                                ),
                              ),
                              if (locText.isNotEmpty)
                                Chip(label: Text(locText)),
                              _coordChip(locLat, locLng, l10n),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (rawStatus == 'draft')
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton.icon(
                                onPressed: _publish,
                                icon: const Icon(Icons.public, size: 18),
                                label: Text(
                                  l10n.btnPublish,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _brandPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 1.5,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(0, 40),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Bewerbungen
                  Text(
                    l10n.applicationsTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (_apps.isEmpty)
                    Text(
                      l10n.applicationsEmpty,
                      style: TextStyle(color: Colors.grey[700]),
                    )
                  else
                    ..._apps.map((a) {
                      final isAwarded = (a['status'] ?? '') == 'awarded';
                      final appId = (a['id'] ?? '').toString();
                      return Material(
                        color: Colors.white,
                        elevation: 1,
                        shadowColor: Colors.black12,
                        borderRadius: BorderRadius.circular(_cardRadius),
                        child: Padding(
                          padding: _cardPad,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.person_outline),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _applicationDisplayName(a),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  isAwarded
                                      ? const Icon(
                                          Icons.verified,
                                          color: Colors.orange,
                                        )
                                      : ElevatedButton(
                                          onPressed: () => _award(appId),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _brandPrimary,
                                            foregroundColor: Colors.white,
                                            elevation: 1.2,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            minimumSize: const Size(0, 36),
                                          ),
                                          child: Text(
                                            l10n.btnAward,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if ((a['note'] ?? '').toString().isNotEmpty)
                                Text(
                                  '${l10n.applicationNote}: ${a['note']}',
                                  style: TextStyle(color: Colors.grey[800]),
                                ),
                              const SizedBox(height: 6),
                              Text(
                                isAwarded
                                    ? l10n.applicationStatusAwarded
                                    : l10n.applicationStatusPending,
                                style: TextStyle(
                                  color: isAwarded
                                      ? Colors.orange[700]
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
