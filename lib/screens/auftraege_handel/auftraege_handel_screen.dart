// lib/screens/auftraege_handel/auftraege_handel_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart' show PostgresChangeEvent;

import '../../l10n/app_localizations.dart';
import 'deal_manage_screen.dart';
import 'handel_erstellen_choice_screen.dart';
import 'package:atyourservice/widgets/deal_preview_gallery.dart';
import 'package:atyourservice/services/deals_service.dart';

class AuftraegeHandelScreen extends StatefulWidget {
  const AuftraegeHandelScreen({super.key});

  @override
  State<AuftraegeHandelScreen> createState() => _AuftraegeHandelScreenState();
}

class _AuftraegeHandelScreenState extends State<AuftraegeHandelScreen>
    with SingleTickerProviderStateMixin {
  static const Color _brandPrimary = Color(0xFF3876BF);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _brandPrimary,
          foregroundColor: Colors.white,
          title: Text(l10n.marketplaceTitle),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: const Icon(Icons.sell_outlined, color: Colors.white),
                text: l10n.marketplaceTabSell,
              ),
              Tab(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                text: l10n.marketplaceTabBuy,
              ),
            ],
          ),
        ),
        body: const Column(
          children: [
            Divider(height: 0),
            Expanded(
              child: TabBarView(children: [_VerkaufenTab(), _KaufenTab()]),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== VERKAUFEN TAB =====================

class _VerkaufenTab extends StatefulWidget {
  const _VerkaufenTab();

  @override
  State<_VerkaufenTab> createState() => _VerkaufenTabState();
}

class _VerkaufenTabState extends State<_VerkaufenTab> {
  static const Color _brandPrimary = Color(0xFF3876BF);

  bool _loading = true;
  String _filter = 'all'; // all | draft | live | awarded
  List<Map<String, dynamic>> _deals = [];
  RealtimeChannel? _appsChannel;

  @override
  void initState() {
    super.initState();
    _load();
    _subscribeRealtime();
  }

  @override
  void dispose() {
    if (_appsChannel != null) {
      Supabase.instance.client.removeChannel(_appsChannel!);
      _appsChannel = null;
    }
    super.dispose();
  }

  void _subscribeRealtime() {
    _appsChannel = Supabase.instance.client
        .channel('public:applications_seller_alert')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'applications',
          callback: (_) async {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.snackNewApplication,
                ),
              ),
            );
            await _load();
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'deals',
          callback: (_) async {
            if (!mounted) return;
            await _load();
          },
        )
        .subscribe();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final supa = Supabase.instance.client;
      final uid = supa.auth.currentUser?.id;

      var q = supa.from('deals_with_counts').select('*');
      if (uid != null) q = q.eq('seller_id', uid);

      switch (_filter) {
        case 'draft':
          q = q.eq('status', 'draft');
          break;
        case 'live':
          q = q.eq('status', 'live');
          break;
        case 'awarded':
          q = q.eq('status', 'awarded');
          break;
        default:
          break;
      }

      final data = await q.order('created_at', ascending: false);

      final deals = (data as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      await _hydrateS1DetailsIfMissing(deals);

      if (!mounted) return;
      setState(() {
        _deals = deals;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.myDealsErrorLoading)));
    }
  }

  Map<String, dynamic>? _nested(dynamic v) {
    if (v == null) return null;
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return v.map((k, value) => MapEntry(k.toString(), value));
    if (v is List && v.isNotEmpty) {
      final first = v.first;
      if (first is Map) {
        return first.map((k, value) => MapEntry(k.toString(), value));
      }
    }
    return null;
  }

  Future<void> _hydrateS1DetailsIfMissing(
    List<Map<String, dynamic>> deals,
  ) async {
    final supa = Supabase.instance.client;

    final missingIds = deals
        .where((d) {
          final type = (d['type'] ?? '').toString();
          final s1 = d['deal_s1'];
          final hasS1 = s1 is Map && s1.isNotEmpty;
          return type == 's1' && !hasS1;
        })
        .map((d) => (d['id'] ?? '').toString())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    if (missingIds.isEmpty) return;

    final rows = await supa
        .from('deal_s1')
        .select(
          'deal_id, pricing_mode, base_price_cents, vat_rate, hourly_rate_cents, expected_hours, provision_type, provision_value, provision_due',
        )
        .inFilter('deal_id', missingIds);

    final byId = <String, Map<String, dynamic>>{};
    for (final r in (rows as List? ?? [])) {
      final m = Map<String, dynamic>.from(r as Map);
      final id = (m['deal_id'] ?? '').toString();
      if (id.isNotEmpty) byId[id] = m;
    }

    for (final d in deals) {
      if ((d['type'] ?? '').toString() == 's1') {
        final id = (d['id'] ?? '').toString();
        final s1 = d['deal_s1'];
        final hasS1 = s1 is Map && s1.isNotEmpty;
        if (!hasS1 && byId.containsKey(id)) {
          d['deal_s1'] = byId[id];
        }
      }
    }
  }

  String _eurFromCents(dynamic c) {
    if (c == null) return '—';
    final cents = (c is int)
        ? c
        : int.tryParse(c.toString().split('.').first) ?? 0;
    return '€ ${(cents / 100).toStringAsFixed(2)}';
  }

  double? _computeProvisionTotalCents({
    required int? baseCents,
    required String type,
    required num? value,
  }) {
    if (baseCents == null || value == null) return null;
    if (type == 'percent') return baseCents * (value / 100.0);
    if (type == 'fixed') return value * 100.0;
    return null;
  }

  int _unread(Map<String, dynamic> row) {
    final v = row['unread_apps_count'];
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  Future<void> _openDraftChecklist(Map<String, dynamic> d) async {
    final l10n = AppLocalizations.of(context)!;
    final supa = Supabase.instance.client;
    final id = (d['id'] ?? '').toString();

    Map<String, dynamic>? ver;
    try {
      final r = await supa
          .from('verifications')
          .select('has_customer_ok, evidence_urls')
          .eq('deal_id', id)
          .maybeSingle();
      if (r != null) ver = Map<String, dynamic>.from(r);
    } catch (_) {}

    final s0 = _nested(d['deal_s0']);
    final provDue = (s0?['provision_due'] ?? 'award').toString();

    final hasTitle = (d['title'] ?? '').toString().trim().isNotEmpty;
    final hasDesc = (d['description'] ?? '').toString().trim().isNotEmpty;
    final hasLocation = (d['location_text'] ?? '').toString().trim().isNotEmpty;
    final hasTargetPrice =
        (s0?['target_price_cents'] is int) && (s0?['target_price_cents'] > 0);

    final hasCustOk = (ver?['has_customer_ok'] == true);
    final evUrls =
        (ver?['evidence_urls'] as List?)?.cast<String>() ?? const <String>[];
    final needsDoc = provDue == 'award';
    final docOk = !needsDoc || evUrls.isNotEmpty;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        Widget item(bool ok, String text) => Row(
          children: [
            Icon(
              ok ? Icons.check_circle : Icons.error_outline,
              color: ok ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(text)),
          ],
        );
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.draftChecklistTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                item(hasTitle, l10n.chkTitle),
                const SizedBox(height: 6),
                item(hasDesc, l10n.chkDescription),
                const SizedBox(height: 6),
                item(hasLocation, l10n.chkLocation),
                const SizedBox(height: 6),
                item(hasTargetPrice, l10n.chkTargetPrice),
                const Divider(height: 24),
                item(hasCustOk, l10n.chkCustomerOk),
                const SizedBox(height: 6),
                item(docOk, l10n.chkDocIfAward),
                const SizedBox(height: 6),
                item(false, l10n.chkAttestAtPublish),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DealManageScreen(deal: d),
                            ),
                          ).then((_) => _load());
                        },
                        child: Text(l10n.draftChecklistCta),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusChip(
    String status,
    AppLocalizations l10n,
    Map<String, dynamic> d,
  ) {
    Color bg;
    String label;
    switch (status) {
      case 'draft':
        bg = Colors.grey.shade200;
        label = l10n.statusDraft;
        break;
      case 'live':
        bg = Colors.green.shade200;
        label = l10n.statusLive;
        break;
      case 'awarded':
        bg = Colors.orange.shade200;
        label = l10n.statusAwarded; // „Vergeben“
        break;
      default:
        bg = Colors.blueGrey.shade200;
        label = status;
    }

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );

    if (status == 'draft') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          chip,
          const SizedBox(width: 4),
          InkWell(
            onTap: () => _openDraftChecklist(d),
            borderRadius: BorderRadius.circular(10),
            child: const Icon(Icons.error_outline, color: Colors.red, size: 16),
          ),
        ],
      );
    }
    return chip;
  }

  _MetaPill _pill(String text, {IconData? icon}) =>
      _MetaPill(label: text, icon: icon);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _brandPrimary,
                    side: const BorderSide(color: _brandPrimary, width: 1.4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline),
                  label: Text(
                    l10n.marketplaceOfferCreateCta,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HandelErstellenChoiceScreen(),
                      ),
                    );
                    _load();
                  },
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                icon: Icon(Icons.filter_list, color: _brandPrimary),
                onSelected: (v) {
                  setState(() => _filter = v);
                  _load();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'all', child: Text(l10n.filterAll)),
                  PopupMenuItem(value: 'draft', child: Text(l10n.filterDraft)),
                  PopupMenuItem(value: 'live', child: Text(l10n.filterLive)),
                  PopupMenuItem(
                    value: 'awarded',
                    child: Text(l10n.filterAwarded),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 0),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _deals.isEmpty
              ? RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    children: [
                      const SizedBox(height: 140),
                      Center(child: Text(l10n.myDealsEmpty)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _deals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final d = _deals[i];

                      final type = (d['type'] ?? '').toString();
                      final s0 = type == 's0' ? _nested(d['deal_s0']) : null;
                      final s1 = type == 's1' ? _nested(d['deal_s1']) : null;

                      String priceText = '—';
                      String provPercentText = '—';
                      String? provTotalText;
                      int? baseCents;
                      String? provType;
                      num? provValue;

                      if (type == 's0' && s0 != null) {
                        final target = s0['target_price_cents'];
                        if (target is int && target > 0) {
                          baseCents = target;
                          priceText = _eurFromCents(target);
                        }

                        final t = (s0['provision_type'] ?? 'percent')
                            .toString();
                        final vRaw = s0['provision_value'];
                        final v = (vRaw is num)
                            ? vRaw
                            : num.tryParse(vRaw?.toString() ?? '');
                        provType = t;
                        provValue = v;

                        if (v != null) {
                          provPercentText = (t == 'percent')
                              ? l10n.marketplaceProvisionPercent(v.toString())
                              : _eurFromCents((v * 100).round());
                        }
                      } else if (type == 's1' && s1 != null) {
                        final mode = (s1['pricing_mode'] ?? 'fixed').toString();
                        final t = (s1['provision_type'] ?? 'percent')
                            .toString();
                        final vRaw = s1['provision_value'];
                        final v = (vRaw is num)
                            ? vRaw
                            : num.tryParse(vRaw?.toString() ?? '');
                        provType = t;
                        provValue = v;

                        if (mode == 'fixed') {
                          final base = s1['base_price_cents'];
                          if (base is int && base > 0) {
                            final vatRate =
                                (s1['vat_rate'] as num?)?.toDouble() ?? 0.0;
                            final total = (base * (1 + vatRate / 100)).round();
                            baseCents = total;
                            priceText = _eurFromCents(total);
                          }
                        } else {
                          final rateC = s1['hourly_rate_cents'];
                          final hours = s1['expected_hours'];
                          if (rateC is int && hours is num && hours > 0) {
                            baseCents = (rateC * hours).round();
                            priceText =
                                '${_eurFromCents(rateC)} × ${hours.toStringAsFixed(1)} h';
                          }
                        }

                        if (v != null) {
                          provPercentText = (t == 'percent')
                              ? l10n.marketplaceProvisionPercent(v.toString())
                              : _eurFromCents((v * 100).round());
                        }
                      }

                      if (baseCents != null &&
                          provType != null &&
                          provValue != null) {
                        final total = _computeProvisionTotalCents(
                          baseCents: baseCents,
                          type: provType!,
                          value: provValue,
                        );
                        if (total != null) {
                          provTotalText = _eurFromCents(total.round());
                        }
                      }

                      final unread = _unread(d);
                      final typeLabel = type == 's1'
                          ? l10n.marketplaceTypeS1
                          : l10n.marketplaceTypeS0;

                      final meta = <Widget>[
                        _pill(typeLabel, icon: Icons.label_important_outline),
                        _statusChip((d['status'] ?? '').toString(), l10n, d),
                        if ((d['category'] ?? '').toString().trim().isNotEmpty)
                          _pill(d['category'], icon: Icons.category_outlined),
                        _pill(
                          'Zielpreis: $priceText',
                          icon: Icons.price_check_outlined,
                        ),
                        _pill(
                          'Provision: $provPercentText',
                          icon: Icons.percent,
                        ),
                        if ((d['location_text'] ?? '').toString().isNotEmpty)
                          _pill(d['location_text'], icon: Icons.place_outlined),
                      ];

                      return _DealCard(
                        title: (d['title'] ?? '—').toString(),
                        subtitle: (d['description'] ?? '').toString(),
                        meta: meta,
                        rightTop: provTotalText == null
                            ? null
                            : _PriceSummaryBox(
                                priceText: priceText,
                                provTotalText: provTotalText!,
                              ),
                        trailingButton: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: _brandPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.edit, size: 18),
                              label: Text(l10n.btnManage),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DealManageScreen(deal: d),
                                  ),
                                ).then((_) => _load());
                              },
                            ),
                            if (unread > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    unread > 9 ? '9+' : '$unread',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        footer: DealPreviewGallery(
                          dealId: (d['id'] ?? '').toString(),
                          padding: const EdgeInsets.only(top: 10),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

// ===================== KAUFEN TAB =====================

class _KaufenTab extends StatefulWidget {
  const _KaufenTab();

  @override
  State<_KaufenTab> createState() => _KaufenTabState();
}

class _KaufenTabState extends State<_KaufenTab> {
  static const Color _brandPrimary = Color(0xFF3876BF);

  static const String kDlTable = 'dienstleister_details';
  static const String kDlLatCol = 'latitude';
  static const String kDlLngCol = 'longitude';
  static const String kHomeLatCol = 'home_lat';
  static const String kHomeLngCol = 'home_lng';
  static const String kRadiusCol = 'search_radius_km';

  bool _loading = true;

  List<Map<String, dynamic>> _allDeals = [];
  List<Map<String, dynamic>> _visibleDeals = [];
  Set<String> _applied = {};
  Map<String, String> _myAppIdByDeal = {};
  Set<String> _awardedDealsToMe = {};

  double? _buyerLat;
  double? _buyerLng;
  double _radiusKm = 20;

  String? _categoryFilter; // null = alle
  String? _typeFilter; // null | 's0' | 's1'

  RealtimeChannel? _dealsChannel;

  @override
  void initState() {
    super.initState();
    _bootstrap();
    _subscribeRealtime();
  }

  @override
  void dispose() {
    if (_dealsChannel != null) {
      Supabase.instance.client.removeChannel(_dealsChannel!);
      _dealsChannel = null;
    }
    super.dispose();
  }

  void _subscribeRealtime() {
    _dealsChannel = Supabase.instance.client
        .channel('public:deals_buy_updates')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'deals',
          callback: (_) async {
            if (!mounted) return;
            await _bootstrap();
          },
        )
        .subscribe();
  }

  Map<String, dynamic>? _nested(Map<String, dynamic> d, String key) {
    final v = d[key];
    if (v == null) return null;
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return v.map((k, value) => MapEntry(k.toString(), value));
    if (v is List && v.isNotEmpty) {
      final first = v.first;
      if (first is Map) {
        return first.map((k, value) => MapEntry(k.toString(), value));
      }
    }
    return null;
  }

  Future<void> _bootstrap() async {
    setState(() => _loading = true);
    try {
      final supa = Supabase.instance.client;
      final uid = supa.auth.currentUser?.id;

      if (uid != null) {
        List<dynamic> rows = await supa
            .from(kDlTable)
            .select()
            .eq('user_id', uid);
        if (rows.isEmpty) {
          rows = await supa.from(kDlTable).select().eq('id', uid);
        }

        Map<String, dynamic>? chosen;
        Map<String, dynamic>? firstWithAny;
        for (final r0 in rows) {
          final r = Map<String, dynamic>.from(r0 as Map);
          final hasHome = (r[kHomeLatCol] != null && r[kHomeLngCol] != null);
          final hasLatLng = (r[kDlLatCol] != null && r[kDlLngCol] != null);
          firstWithAny ??= (hasHome || hasLatLng) ? r : firstWithAny;
          if (hasHome) {
            chosen = r;
            break;
          }
        }
        chosen ??= firstWithAny;

        double? asDouble(dynamic v) {
          if (v == null) return null;
          if (v is num) return v.toDouble();
          return double.tryParse(v.toString());
        }

        if (chosen != null) {
          final hLat = asDouble(chosen[kHomeLatCol]);
          final hLng = asDouble(chosen[kHomeLngCol]);
          final bLat = asDouble(chosen[kDlLatCol]);
          final bLng = asDouble(chosen[kDlLngCol]);

          _buyerLat = hLat ?? bLat;
          _buyerLng = hLng ?? bLng;

          final r = asDouble(chosen[kRadiusCol]);
          if (r != null && r > 0) {
            _radiusKm = r.clamp(1, 50);
          }
        } else {
          _buyerLat = null;
          _buyerLng = null;
        }
      }

      // Deals laden (live + awarded)
      final raw = await supa
          .from('deals')
          .select('''
            id, type, title, description, location_text, location_lat, location_lng,
            status, created_at, start_after, deadline, category,
            deal_s0(target_price_cents, provision_type, provision_value, provision_due),
            deal_s1(pricing_mode, base_price_cents, vat_rate, hourly_rate_cents, expected_hours,
                    provision_type, provision_value, provision_due)
          ''')
          .or('status.eq.live,status.eq.awarded')
          .order('created_at', ascending: false);

      final all = (raw as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      // Meine Bewerbungen (inkl. awarded)
      final Set<String> applied = {};
      final Map<String, String> myAppIdByDeal = {};
      final Set<String> awardedToMe = {};
      final uid2 = supa.auth.currentUser?.id;
      if (uid2 != null && all.isNotEmpty) {
        final ids = all
            .map((d) => (d['id'] ?? '').toString())
            .where((s) => s.isNotEmpty)
            .toList();
        if (ids.isNotEmpty) {
          final orExpr = ids.map((id) => 'deal_id.eq.$id').join(',');
          final apps = await supa
              .from('applications')
              .select('id, deal_id, status')
              .eq('buyer_id', uid2)
              .or(orExpr);

          for (final a in apps) {
            final m = Map<String, dynamic>.from(a as Map);
            final dealId = (m['deal_id'] ?? '').toString();
            final appId = (m['id'] ?? '').toString();
            final st = (m['status'] ?? '').toString();
            if (dealId.isEmpty || appId.isEmpty) continue;

            if (st != 'withdrawn') {
              applied.add(dealId);
              myAppIdByDeal[dealId] = appId;
            }
            if (st == 'awarded') {
              awardedToMe.add(dealId);
            }
          }
        }
      }

      final afterClient = _applyClientFilters(all);
      final filtered = _applyRadiusFilter(afterClient);

      if (!mounted) return;
      setState(() {
        _allDeals = all;
        _visibleDeals = filtered;
        _applied = applied;
        _myAppIdByDeal = myAppIdByDeal;
        _awardedDealsToMe = awardedToMe;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.marketplaceErrorLoading}\n$e',
          ),
        ),
      );
    }
  }

  List<Map<String, dynamic>> _applyClientFilters(
    List<Map<String, dynamic>> src,
  ) {
    Iterable<Map<String, dynamic>> it = src;

    if (_categoryFilter != null && _categoryFilter!.isNotEmpty) {
      it = it.where((d) => (d['category'] ?? '').toString() == _categoryFilter);
    }
    if (_typeFilter != null) {
      it = it.where((d) => (d['type'] ?? '').toString() == _typeFilter);
    }

    return it.toList();
  }

  List<Map<String, dynamic>> _applyRadiusFilter(
    List<Map<String, dynamic>> src,
  ) {
    if (_buyerLat == null || _buyerLng == null) {
      return List.of(src);
    }

    final List<(Map<String, dynamic> deal, double dist)> withDistance = [];
    for (final d in src) {
      final lat = (d['location_lat'] as num?)?.toDouble();
      final lng = (d['location_lng'] as num?)?.toDouble();
      if (lat == null || lng == null) continue;

      final km = haversineKm(_buyerLat!, _buyerLng!, lat, lng);
      if (km <= _radiusKm) {
        withDistance.add((d, km));
      }
    }

    withDistance.sort((a, b) => a.$2.compareTo(b.$2));
    return withDistance.map((e) {
      final m = Map<String, dynamic>.from(e.$1);
      m['__distance_km'] = e.$2;
      return m;
    }).toList();
  }

  void _onRadiusChanged(double v) {
    setState(() {
      _radiusKm = v;
      _visibleDeals = _applyRadiusFilter(_applyClientFilters(_allDeals));
    });
  }

  String _eurFromCents(dynamic c) {
    if (c == null) return '—';
    final cents = (c is int)
        ? c
        : int.tryParse(c.toString().split('.').first) ?? 0;
    return '€ ${(cents / 100).toStringAsFixed(2)}';
  }

  double? _computeProvisionTotalCents({
    required int? baseCents,
    required String type,
    required num? value,
  }) {
    if (baseCents == null || value == null) return null;
    if (type == 'percent') return baseCents * (value / 100.0);
    if (type == 'fixed') return value * 100.0;
    return null;
  }

  Future<void> _apply(String dealId) async {
    final supa = Supabase.instance.client;
    final myId = supa.auth.currentUser?.id;
    if (myId == null) return;

    final svc = DealsService(supa);

    try {
      await svc.applyForDeal(dealId: dealId);

      if (!mounted) return;
      setState(() => _applied = {..._applied, dealId});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.marketplaceAppliedSuccess,
          ),
        ),
      );
    } on PostgrestException catch (e) {
      final already = e.code == '23505';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            already
                ? AppLocalizations.of(context)!.marketplaceAlreadyApplied
                : AppLocalizations.of(context)!.genericError,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.genericError)),
      );
    }
  }

  Future<void> _openUnifiedFilter(AppLocalizations l10n) async {
    final result = await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        String? selType = _typeFilter;
        String? selCategory = _categoryFilter;

        final cats = [
          l10n.categoryAll,
          l10n.categoryRoofer,
          l10n.categorySolar,
          l10n.categoryHVAC,
          l10n.categoryElectrical,
          l10n.categoryDrywall,
          l10n.categoryPainter,
          l10n.categoryTiling,
          l10n.categoryFlooring,
          l10n.categoryWindowsDoors,
          l10n.categoryInsulationFacade,
          l10n.categoryMasonryConcrete,
          l10n.categoryCarpentryJoinery,
          l10n.categoryLandscaping,
          l10n.categoryScaffolding,
          l10n.categoryCleaningRestoration,
          l10n.categoryMovingTransport,
        ];

        void popNow() {
          Navigator.pop<Map<String, String?>>(context, {
            'type': selType,
            'category': selCategory,
          });
        }

        return DraggableScrollableSheet(
          initialChildSize: 0.68,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: StatefulBuilder(
                builder: (ctx, setSheetState) {
                  Widget typePill(String label, String? value) {
                    final selected = selType == value;
                    return ChoiceChip(
                      label: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      selected: selected,
                      onSelected: (_) {
                        selType = value;
                        popNow();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.marketplaceFilter,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              typePill(l10n.filterTypeAll, null),
                              typePill(l10n.marketplaceTypeS0, 's0'),
                              typePill(l10n.marketplaceTypeS1, 's1'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.categoryAll,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          controller: controller,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 3.2,
                              ),
                          itemCount: cats.length,
                          itemBuilder: (_, i) {
                            final c = cats[i];
                            final isAll = c == l10n.categoryAll;
                            final selected =
                                (selCategory == null && isAll) ||
                                (selCategory == c);
                            return InkWell(
                              onTap: () {
                                selCategory = isAll ? null : c;
                                popNow();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? _brandPrimary
                                        : Colors.grey.shade300,
                                    width: selected ? 1.6 : 1,
                                  ),
                                  color: selected
                                      ? _brandPrimary.withOpacity(0.06)
                                      : Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      selected
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      size: 18,
                                      color: selected
                                          ? _brandPrimary
                                          : Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        c,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        _typeFilter = result['type'];
        _categoryFilter = result['category'];
        _visibleDeals = _applyRadiusFilter(_applyClientFilters(_allDeals));
      });
    }
  }

  _MetaPill _pill(String text, {IconData? icon}) =>
      _MetaPill(label: text, icon: icon);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasBuyerPos = _buyerLat != null && _buyerLng != null;
    final bool hasActiveFilter =
        (_typeFilter != null) || (_categoryFilter != null);

    final double headerHeight = hasBuyerPos ? 260 : 170;

    return _loading
        ? const Center(child: CircularProgressIndicator())
        : CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: false,
                floating: false,
                snap: false,
                toolbarHeight: 0,
                collapsedHeight: 0,
                expandedHeight: headerHeight,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: _FilterHeader(
                    brand: _brandPrimary,
                    hasBuyerPos: hasBuyerPos,
                    hasActiveFilter: hasActiveFilter,
                    radiusKm: _radiusKm,
                    onRadius: _onRadiusChanged,
                    onOpenFilter: () => _openUnifiedFilter(l10n),
                    l10n: l10n,
                  ),
                ),
              ),
              if (_visibleDeals.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text(l10n.marketplaceEmptyList)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index.isOdd) return const SizedBox(height: 12);
                        final itemIndex = index ~/ 2;
                        final d = _visibleDeals[itemIndex];
                        final s0 = _nested(d, 'deal_s0');
                        final s1 = _nested(d, 'deal_s1');

                        String zielpreis = '—';
                        String provPercentText = '—';
                        String? provTotalText;
                        int? baseCents;
                        String? provType;
                        num? provValue;

                        if (s0 != null) {
                          final target = s0['target_price_cents'] as int?;
                          baseCents = target;
                          zielpreis = _eurFromCents(target);
                          final t = (s0['provision_type'] ?? 'percent')
                              .toString();
                          final v = s0['provision_value'];
                          provType = t;
                          provValue = (v is num) ? v : num.tryParse('$v');
                          provPercentText = t == 'percent' && v != null
                              ? l10n.marketplaceProvisionPercent('$v')
                              : _eurFromCents(
                                  (v is num) ? (v * 100).round() : null,
                                );
                        } else if (s1 != null) {
                          final mode = (s1['pricing_mode'] ?? 'fixed')
                              .toString();
                          final t = (s1['provision_type'] ?? 'percent')
                              .toString();
                          final v = s1['provision_value'];
                          provType = t;
                          provValue = (v is num) ? v : num.tryParse('$v');

                          if (mode == 'fixed') {
                            final base = s1['base_price_cents'] as int?;
                            if (base != null) {
                              final vatRate =
                                  (s1['vat_rate'] as num?)?.toDouble() ?? 0.0;
                              final total = (base * (1 + vatRate / 100))
                                  .round();
                              baseCents = total;
                              zielpreis = _eurFromCents(total);
                            }
                          } else {
                            final rateC = s1['hourly_rate_cents'] as int?;
                            final hours = (s1['expected_hours'] as num?)
                                ?.toDouble();
                            if (rateC != null && hours != null) {
                              baseCents = (rateC * hours).round();
                              zielpreis =
                                  '${_eurFromCents(rateC)} × ${hours.toStringAsFixed(1)} h';
                            }
                          }

                          provPercentText = t == 'percent' && v != null
                              ? l10n.marketplaceProvisionPercent('$v')
                              : _eurFromCents(
                                  (v is num) ? (v * 100).round() : null,
                                );
                        }

                        if (baseCents != null &&
                            provType != null &&
                            provValue != null) {
                          final total = _computeProvisionTotalCents(
                            baseCents: baseCents,
                            type: provType!,
                            value: provValue,
                          );
                          if (total != null) {
                            provTotalText = _eurFromCents(total.round());
                          }
                        }

                        final id = (d['id'] ?? '').toString();
                        final alreadyApplied = _applied.contains(id);

                        final distKm = (d['__distance_km'] as double?);
                        final type = (d['type'] ?? '').toString();
                        final typeLabel = type == 's1'
                            ? l10n.marketplaceTypeS1
                            : l10n.marketplaceTypeS0;

                        // Gewinner/Verlierer anhand meiner Applications
                        final isAwarded = (d['status'] == 'awarded');
                        final awardedToMe = _awardedDealsToMe.contains(id);

                        final String ctaText = awardedToMe
                            ? l10n.badgeAwardedToYou
                            : (isAwarded && alreadyApplied)
                            ? l10n.badgeAwardedGiven
                            : alreadyApplied
                            ? l10n.btnApplied
                            : l10n.marketplaceBuyNow;

                        final bool ctaEnabled =
                            !(awardedToMe ||
                                (isAwarded && alreadyApplied) ||
                                alreadyApplied);

                        final meta = <Widget>[
                          _pill(typeLabel, icon: Icons.label_important_outline),
                          if ((d['category'] ?? '')
                              .toString()
                              .trim()
                              .isNotEmpty)
                            _pill(d['category'], icon: Icons.category_outlined),
                          _pill(
                            'Zielpreis: $zielpreis',
                            icon: Icons.price_check_outlined,
                          ),
                          _pill(
                            'Provision: $provPercentText',
                            icon: Icons.percent,
                          ),
                          if ((d['location_text'] ?? '').toString().isNotEmpty)
                            _pill(
                              d['location_text'],
                              icon: Icons.place_outlined,
                            ),
                          if (distKm != null)
                            _pill(
                              '${distKm.toStringAsFixed(1)} km',
                              icon: Icons.directions_walk_outlined,
                            ),
                        ];

                        return _DealCard(
                          title: (d['title'] ?? '—').toString(),
                          subtitle: (d['description'] ?? '').toString(),
                          meta: meta,
                          rightTop: provTotalText == null
                              ? null
                              : _PriceSummaryBox(
                                  priceText: zielpreis,
                                  provTotalText: provTotalText!,
                                ),
                          trailingButton: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: ctaEnabled
                                  ? _brandPrimary
                                  : Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: ctaEnabled ? () => _apply(id) : null,
                            child: Text(
                              ctaText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          footer: DealPreviewGallery(
                            dealId: id,
                            padding: const EdgeInsets.only(top: 10),
                          ),
                        );
                      },
                      childCount: _visibleDeals.isEmpty
                          ? 0
                          : (_visibleDeals.length * 2 - 1),
                    ),
                  ),
                ),
            ],
          );
  }
}

// --- Header-Widget ---

class _FilterHeader extends StatelessWidget {
  final Color brand;
  final bool hasBuyerPos;
  final bool hasActiveFilter;
  final double radiusKm;
  final ValueChanged<double> onRadius;
  final Future<void> Function() onOpenFilter;
  final AppLocalizations l10n;

  const _FilterHeader({
    required this.brand,
    required this.hasBuyerPos,
    required this.hasActiveFilter,
    required this.radiusKm,
    required this.onRadius,
    required this.onOpenFilter,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    const bottomPad = 8.0;

    return Material(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, bottomPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hinweisbox
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: hasBuyerPos
                      ? Colors.green.shade50
                      : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: hasBuyerPos
                        ? Colors.green.shade200
                        : Colors.amber.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      hasBuyerPos
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      size: 18,
                      color: hasBuyerPos
                          ? Colors.green.shade800
                          : Colors.amber.shade900,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hasBuyerPos
                            ? l10n.marketplaceLocationLoadedFromProfile
                            : l10n.marketplaceNoHomeAddressHint,
                        style: TextStyle(
                          color: hasBuyerPos
                              ? Colors.green.shade800
                              : Colors.amber.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Filterbutton mit Badge
              Stack(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: brand,
                      side: BorderSide(color: brand, width: 1.4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.filter_list),
                    label: Text(
                      l10n.marketplaceFilter,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onPressed: onOpenFilter,
                  ),
                  if (hasActiveFilter)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C4CCF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                ],
              ),
              // Radius
              if (hasBuyerPos) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.radar, size: 18),
                    const SizedBox(width: 8),
                    Text('Radius: ${radiusKm.toStringAsFixed(0)} km'),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => onRadius(20),
                      icon: const Icon(Icons.restart_alt, size: 18),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Slider(
                    value: radiusKm,
                    min: 5,
                    max: 50,
                    divisions: 9,
                    label: '${radiusKm.toStringAsFixed(0)} km',
                    onChanged: onRadius,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// --- DealCard, MetaPill, PriceSummary, Haversine ---

class _DealCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> meta;
  final Widget trailingButton;
  final Widget? rightTop;
  final Widget? footer;

  const _DealCard({
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.trailingButton,
    this.rightTop,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (subtitle.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    trailingButton,
                    if (rightTop != null) ...[
                      const SizedBox(height: 6),
                      rightTop!,
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: meta),
            if (footer != null) ...[const SizedBox(height: 8), footer!],
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _MetaPill({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.grey.shade700),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.5, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceSummaryBox extends StatelessWidget {
  final String priceText;
  final String provTotalText;

  const _PriceSummaryBox({
    required this.priceText,
    required this.provTotalText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Zielpreis',
            style: TextStyle(fontSize: 9.5, color: Colors.grey.shade700),
          ),
          Text(
            priceText,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            'Provision gesamt',
            style: TextStyle(fontSize: 9.5, color: Colors.grey.shade700),
          ),
          Text(
            provTotalText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3876BF),
            ),
          ),
        ],
      ),
    );
  }
}

double haversineKm(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371.0;
  final dLat = (lat2 - lat1) * (pi / 180.0);
  final dLon = (lon2 - lon1) * (pi / 180.0);
  final a =
      (sin(dLat / 2) * sin(dLat / 2)) +
      cos(lat1 * (pi / 180.0)) *
          cos(lat2 * (pi / 180.0)) *
          (sin(dLon / 2) * sin(dLon / 2));
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return r * c;
}
