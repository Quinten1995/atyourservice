import 'package:flutter/material.dart';
import '../../models/auftrag_form_data.dart';
import '../../data/kategorien.dart';
import '../../utils/category_utils.dart';
import '../../l10n/app_localizations.dart';
import 'auftrag_details_screen.dart';

class AuftragKategorieScreen extends StatelessWidget {
  final AuftragFormData formData;
  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  const AuftragKategorieScreen({Key? key, required this.formData})
    : super(key: key);

  /// ACTIVE zuerst (alphabetisch nach Label), dann BETA (alphabetisch)
  List<String> _sortedSelectableKeys(AppLocalizations l10n) {
    final all = selectableCategoryKeys(); // ACTIVE + BETA aus kategorien.dart
    final active = <String>[];
    final beta = <String>[];

    for (final k in all) {
      (categoryStatus[k] == CategoryStatus.beta ? beta : active).add(k);
    }

    int byLabel(String a, String b) =>
        getKategorieLabel(a, l10n).compareTo(getKategorieLabel(b, l10n));

    active.sort(byLabel);
    beta.sort(byLabel);
    return [...active, ...beta];
  }

  /// Dropdown-Item mit optionalem „Beta“-Chip (gleicher Stil wie Registrierung)
  Widget _categoryDropdownItem(String key, AppLocalizations l10n) {
    final baseLabel = getKategorieLabel(key, l10n);
    final isBeta = categoryStatus[key] == CategoryStatus.beta;

    const betaText = 'Beta'; // Optional: via l10n.badgeBeta

    final betaChip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Text(
        betaText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.amber.shade800,
          height: 1.0,
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(baseLabel, overflow: TextOverflow.ellipsis)),
        if (isBeta) ...[const SizedBox(width: 8), betaChip],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // 🔹 Nur ACTIVE + BETA – erst ACTIVE (A–Z), dann BETA (A–Z)
    final keys = _sortedSelectableKeys(l10n);

    // Fallback: falls (theoretisch) keine Keys vorhanden
    String? selectedKategorie =
        formData.kategorie ?? (keys.isNotEmpty ? keys.first : null);
    formData.kategorie ??= selectedKategorie;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.auftragKategorieAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, accentColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Card(
                color: Colors.white.withOpacity(0.96),
                elevation: 8,
                shadowColor: primaryColor.withOpacity(0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 48,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.auftragKategorieHeadline,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.auftragKategorieInfo,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // ✅ Dropdown: ACTIVE zuerst, dann BETA (beide A–Z), mit Beta-Chip
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedKategorie,
                          decoration: InputDecoration(
                            labelText: l10n.kategorieLabel,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                          items: keys.map((key) {
                            return DropdownMenuItem(
                              value: key,
                              child: _categoryDropdownItem(key, l10n),
                            );
                          }).toList(),
                          onChanged: (val) {
                            formData.kategorie = val;
                            selectedKategorie = val;
                          },
                          validator: (_) {
                            if (formData.kategorie == null) {
                              return l10n.kategorieValidator;
                            }
                            // Sicherheit: nur ACTIVE/BETA erlaubt
                            if (formData.kategorie != null &&
                                !keys.contains(formData.kategorie)) {
                              return l10n.kategorieValidator;
                            }
                            return null;
                          },
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.navigate_next_rounded),
                          label: Text(l10n.weiterButton),
                          onPressed: () {
                            if (formData.kategorie == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.kategorieValidator),
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AuftragDetailsScreen(formData: formData),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                            shadowColor: primaryColor.withOpacity(0.20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
