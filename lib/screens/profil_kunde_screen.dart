import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../l10n/app_localizations.dart';

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
  bool _deletingAccount = false;
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
      if (user == null) throw Exception(AppLocalizations.of(context)!.notLoggedIn);
      final res = await supabase
          .from('users')
          .select('adresse')
          .eq('id', user.id)
          .maybeSingle();
      _adresseController.text = res?['adresse'] ?? '';
    } catch (e) {
      setState(() => _errorMessage = AppLocalizations.of(context)!.profileLoadError(e.toString()));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _speichereAdresse() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception(AppLocalizations.of(context)!.notLoggedIn);
      await supabase
          .from('users')
          .update({'adresse': _adresseController.text.trim()})
          .eq('id', user.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileAddressSaved)),
      );
    } catch (e) {
      setState(() => _errorMessage = AppLocalizations.of(context)!.profileSaveError(e.toString()));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _kontoLoeschenDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.deleteAccountButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _kontoLoeschen();
    }
  }

  Future<void> _kontoLoeschen() async {
    setState(() {
      _deletingAccount = true;
      _errorMessage = null;
    });

    final l10n = AppLocalizations.of(context)!;

    try {
      final user = supabase.auth.currentUser;
      final session = supabase.auth.currentSession;
      if (user == null || session == null) throw Exception(l10n.notLoggedIn);

      // 1. Bewertungen löschen (als Kunde oder Dienstleister)
      await supabase.from('bewertungen').delete()
        .or('kunde_id.eq.${user.id},dienstleister_id.eq.${user.id}');

      // 2. Aufträge löschen (als Kunde oder Dienstleister)
      await supabase.from('auftraege').delete()
        .or('kunde_id.eq.${user.id},dienstleister_id.eq.${user.id}');

      // 3. User löschen (DB)
      await supabase.from('users').delete().eq('id', user.id);

      // 4. Supabase Edge Function aufrufen, um Auth-Account zu löschen!
      final supabaseFunctionUrl = 'https://npqanssmfxdvwauuaemd.supabase.co/functions/v1/delete_user';
      final response = await http.post(
        Uri.parse(supabaseFunctionUrl),
        headers: {
          'Authorization': 'Bearer ${session.accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user': {'id': user.id}}),
      );

      if (response.statusCode == 200) {
        // 5. Ausloggen
        await supabase.auth.signOut();

        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.accountDeleted)),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Account konnte nicht endgültig gelöscht werden: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _deletingAccount = false;
      });
    }
  }

  @override
  void dispose() {
    _adresseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(l10n.profileAppBar),
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
                          labelText: l10n.profileAddressLabel,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? l10n.profileAddressEmpty
                                : null,
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
                          child: Text(
                            l10n.profileSaveButton,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      _deletingAccount
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.delete_forever),
                                label: Text(
                                  l10n.deleteAccountButton,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[600],
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _deletingAccount ? null : _kontoLoeschenDialog,
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
