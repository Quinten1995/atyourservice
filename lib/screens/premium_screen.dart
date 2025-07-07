import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../l10n/app_localizations.dart';
import '../utils/in_app_purchase_service.dart';

// IDs wie im Play Store/App Store angelegt!
const Set<String> _kProductIds = {
  'atyourservice_silver',
  'atyourservice_gold',
};

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  String? _aboTyp;
  bool _isLoading = true;
  bool _storeAvailable = false;
  List<ProductDetails> _products = [];
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  @override
  void initState() {
    super.initState();
    _ladeAboTyp();
    _ladeStoreProdukte();
    _purchaseSubscription = InAppPurchaseService()
        .listenToPurchases()
        .listen(_handlePurchases);
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }

  // Holt aktuellen Abo-Typ aus Supabase
  Future<void> _ladeAboTyp() async {
    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final res = await Supabase.instance.client
            .from('users')
            .select('abo_typ')
            .eq('id', user.id)
            .maybeSingle();
        setState(() {
          _aboTyp = res?['abo_typ'] ?? 'free';
        });
      }
    } catch (_) {
      // Fehler ignorieren
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Lädt Store-Produkte (Abos)
  Future<void> _ladeStoreProdukte() async {
    print('IAP DEBUG: Starte _ladeStoreProdukte()');
    final available = await InAppPurchaseService().isAvailable();
    print('IAP DEBUG: isAvailable() -> $available');
    if (!available) {
      setState(() {
        _storeAvailable = false;
      });
      print('IAP DEBUG: Store nicht verfügbar');
      return;
    }
    print('IAP DEBUG: Store verfügbar, hole Produkte...');
    final resp = await InAppPurchaseService().getProducts();

    print('IAP DEBUG: getProducts() abgeschlossen');
    print('======== IAP DEBUG ========');
    print('Gefundene Produkte: ${resp.productDetails.map((e) => e.id).toList()}');
    print('Nicht gefundene IDs: ${resp.notFoundIDs}');
    print('===========================');

    setState(() {
      _storeAvailable = true;
      _products = resp.productDetails.toList();
    });
  }

  // Helper, um Produkt anhand der ID zu finden
  ProductDetails? _getProduct(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // Stream-Callback für Käufe
  void _handlePurchases(List<PurchaseDetails> purchases) async {
    final l10n = AppLocalizations.of(context)!;
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Abo-Typ anhand der Produkt-ID bestimmen
        final typ = _aboTypFromProductId(purchase.productID);
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null && typ != null) {
          // In Supabase Abo-Typ speichern
          await Supabase.instance.client
              .from('users')
              .update({'abo_typ': typ})
              .eq('id', user.id);

          setState(() {
            _aboTyp = typ;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.premiumActivated)),
          );
        }
      } else if (purchase.status == PurchaseStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.premiumPurchaseFailed(purchase.error?.message ?? ''))),
        );
      }
    }
  }

  // Produkt-ID → Abo-Typ
  String? _aboTypFromProductId(String productId) {
    if (productId.contains('gold')) return 'gold';
    if (productId.contains('silver')) return 'silver';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.premiumAppBar),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        elevation: 0.7,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.premiumChoosePlan,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (_aboTyp != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Icon(Icons.verified_user, color: Colors.blueAccent, size: 23),
                          const SizedBox(width: 8),
                          Text(
                            l10n.premiumCurrentPlan,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _aboTyp!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              color: _aboTyp == 'gold'
                                  ? Colors.amber[900]
                                  : _aboTyp == 'silver'
                                      ? Colors.blueGrey[700]
                                      : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // === FREE PLAN CARD ===
                  _planCard(
                    context,
                    title: 'FREE',
                    color: Colors.grey[50]!,
                    badge: Icons.lock_open_rounded,
                    priceText: l10n.premiumFreePrice,
                    features: [
                      l10n.premiumFreeFeature1,
                      l10n.premiumFreeFeature2,
                      l10n.premiumFreeFeature3,
                      l10n.premiumFreeFeature4,
                    ],
                    highlighted: _aboTyp == 'free',
                    showButton: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),
                  // === SILVER PLAN CARD ===
                  _planCard(
                    context,
                    title: 'SILVER',
                    color: Colors.blue[50]!,
                    badge: Icons.verified,
                    priceText: _storeAvailable
                        ? (_getProduct('atyourservice_silver')?.price ?? '...')
                        : '...',
                    features: [
                      l10n.premiumSilverFeature1,
                      l10n.premiumSilverFeature2,
                      l10n.premiumSilverFeature3,
                    ],
                    highlighted: _aboTyp == 'silver',
                    showButton: true,
                    onTap: () async {
                      final product = _getProduct('atyourservice_silver');
                      if (product != null) {
                        await InAppPurchaseService().buyProduct(product);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.premiumProductNotFound)),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  // === GOLD PLAN CARD ===
                  _planCard(
                    context,
                    title: 'GOLD',
                    color: Colors.amber[100]!,
                    badge: Icons.workspace_premium,
                    priceText: _storeAvailable
                        ? (_getProduct('atyourservice_gold')?.price ?? '...')
                        : '...',
                    features: [
                      l10n.premiumGoldFeature1,
                      l10n.premiumGoldFeature2,
                      l10n.premiumGoldFeature3,
                      l10n.premiumGoldFeature4,
                      l10n.premiumGoldInvoiceFeature,
                    ],
                    highlighted: _aboTyp == 'gold',
                    showButton: true,
                    onTap: () async {
                      final product = _getProduct('atyourservice_gold');
                      if (product != null) {
                        await InAppPurchaseService().buyProduct(product);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.premiumProductNotFound)),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 34),
                  Text(
                    l10n.premiumPaymentNote,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (!_storeAvailable)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        l10n.premiumStoreNotLoaded,
                        style: TextStyle(color: Colors.red[700], fontSize: 13),
                      ),
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
    List<String>? features,
    required VoidCallback onTap,
    bool highlighted = false,
    bool showButton = true,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: highlighted
            ? Border.all(color: Colors.blueAccent, width: 2)
            : null,
        boxShadow: highlighted
            ? [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.11),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      margin: const EdgeInsets.symmetric(vertical: 1),
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
            const SizedBox(height: 10),
            ...?features?.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 17),
                      const SizedBox(width: 7),
                      Text(f, style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                )),
            if (showButton) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  child: Text(l10n.premiumChooseButton(title)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
