import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/app_localizations.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  String? _aboTyp;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _ladeAboTyp();
  }

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
    } catch (e) {
      // Ignore, bleibt auf null
    } finally {
      setState(() => _isLoading = false);
    }
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
                    ],
                    highlighted: _aboTyp == 'free',
                    showButton: false, // Kein Button!
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),
                  _planCard(
                    context,
                    title: 'SILVER',
                    color: Colors.blue[50]!,
                    badge: Icons.verified,
                    priceText: l10n.premiumSilverPrice,
                    features: [
                      l10n.premiumSilverFeature1,
                      l10n.premiumSilverFeature2,
                      l10n.premiumSilverFeature3,
                      l10n.premiumSilverFeature4,
                    ],
                    highlighted: _aboTyp == 'silver',
                    showButton: true,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.premiumSilverComingSoon)),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _planCard(
                    context,
                    title: 'GOLD',
                    color: Colors.amber[100]!,
                    badge: Icons.workspace_premium,
                    priceText: l10n.premiumGoldPrice,
                    features: [
                      l10n.premiumGoldFeature1,
                      l10n.premiumGoldFeature2,
                      l10n.premiumGoldFeature3,
                      l10n.premiumGoldFeature4,
                      l10n.premiumGoldFeature5,
                    ],
                    highlighted: _aboTyp == 'gold',
                    showButton: true,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.premiumGoldComingSoon)),
                      );
                    },
                  ),
                  const SizedBox(height: 34),
                  Text(
                    l10n.premiumPaymentNote,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
            ...features.map((f) => Padding(
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
