import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Optional für E-Mail-App: import 'package:url_launcher/url_launcher.dart';

class ProfilKundeScreen extends StatefulWidget {
  const ProfilKundeScreen({Key? key}) : super(key: key);

  @override
  State<ProfilKundeScreen> createState() => _ProfilKundeScreenState();
}

class _ProfilKundeScreenState extends State<ProfilKundeScreen> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _adresseController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  @override
  void initState() {
    super.initState();
    _ladeAdresse();
  }

  Future<void> _ladeAdresse() async {
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('Nicht eingeloggt');
      final res = await supabase
          .from('users')
          .select('adresse')
          .eq('id', user.id)
          .maybeSingle();
      _adresseController.text = res?['adresse'] ?? '';
    } catch (e) {
      setState(() => _errorMessage = 'Fehler beim Laden: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _speichereAdresse() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('Nicht eingeloggt');
      await supabase
          .from('users')
          .update({'adresse': _adresseController.text.trim()})
          .eq('id', user.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adresse gespeichert!')),
      );
    } catch (e) {
      setState(() => _errorMessage = 'Fehler beim Speichern: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Profil löschen Dialog (Mail-Variante)
  void _showDeleteProfileDialog() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Profil löschen'),
        content: const Text(
          'Möchtest du dein Profil wirklich löschen?\n\n'
          'Sende uns dazu bitte eine E-Mail an:\n'
          'quintenhessmann1995@yahoo.com\n\n'
          'Wir löschen dein Konto und alle personenbezogenen Daten umgehend gemäß DSGVO.',
        ),
        actions: [
          TextButton(
            child: const Text('Abbrechen'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('E-Mail senden'),
            onPressed: () async {
              Navigator.pop(context);
              // E-Mail-App öffnen (optional, url_launcher in pubspec.yaml hinzufügen)
              // final uri = Uri(
              //   scheme: 'mailto',
              //   path: 'quintenhessmann1995@yahoo.com',
              //   query: 'subject=Account Löschung&body=Bitte lösche meinen Account und alle personenbezogenen Daten.',
              // );
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _adresseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text('Profil – Heimatadresse'),
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _adresseController,
                            decoration: InputDecoration(
                              labelText: 'Heimatadresse (z. B. Musterstraße 12, 12345 Musterstadt)',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) =>
                                (value == null || value.isEmpty) ? 'Adresse angeben' : null,
                          ),
                          const SizedBox(height: 24),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(_errorMessage!,
                                  style: const TextStyle(color: Colors.red)),
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _speichereAdresse,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Speichern',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 12),

                    // Profil löschen Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('Profil löschen'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 1,
                        ),
                        onPressed: _showDeleteProfileDialog,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
