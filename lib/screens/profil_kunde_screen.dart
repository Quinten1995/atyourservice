import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
              : Form(
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
        ),
      ),
    );
  }
}
