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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final sortedKategorieEntries =
        (kategorieKeys
            .map((key) => MapEntry(key, getKategorieLabel(key, l10n)))
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value)));

    String? selectedKategorie = formData.kategorie ?? kategorieKeys.first;
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

                      // ✅ Kein Expanded in ScrollView! Breite via SizedBox + isExpanded
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
                          items: sortedKategorieEntries.map((entry) {
                            return DropdownMenuItem(
                              value: entry.key,
                              child: Text(
                                entry.value,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            formData.kategorie = val;
                            selectedKategorie = val;
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
