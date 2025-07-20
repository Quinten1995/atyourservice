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

  String? _userEmail;

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
          .select('adresse, email')
          .eq('id', user.id)
          .maybeSingle();
      _adresseController.text = res?['adresse'] ?? '';
      _userEmail = res?['email'] ?? '';
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
        SnackBar(content: Text(AppLocalizations.of(context)!.profileAddressSaved), backgroundColor: Colors.green[700]),
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
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[800]),
            const SizedBox(width: 8),
            Text(l10n.deleteAccountTitle),
          ],
        ),
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

      await supabase.from('bewertungen').delete()
        .or('kunde_id.eq.${user.id},dienstleister_id.eq.${user.id}');

      await supabase.from('auftraege').delete()
        .or('kunde_id.eq.${user.id},dienstleister_id.eq.${user.id}');

      await supabase.from('users').delete().eq('id', user.id);

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
        await supabase.auth.signOut();
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.accountDeleted), backgroundColor: Colors.green[700]),
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
        title: Text(l10n.profileAppBar, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profil-Card
                    Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: primaryColor.withOpacity(0.1),
                              child: const Icon(Icons.person, color: Colors.blue, size: 32),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.hello,
                                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    _userEmail ?? '-',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    // Adressformular
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _adresseController,
                        decoration: InputDecoration(
                          labelText: l10n.profileAddressLabel,
                          prefixIcon: const Icon(Icons.home_rounded),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? l10n.profileAddressEmpty
                            : null,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 20),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(_errorMessage!,
                                  style: const TextStyle(color: Colors.red, fontSize: 15)),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _speichereAdresse,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          l10n.profileSaveButton,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 38),
                    // Account löschen Bereich
                    Card(
                      color: Colors.red[50],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Colors.redAccent, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 28),
                                const SizedBox(width: 11),
                                Expanded(
                                  child: Text(
                                    l10n.deleteAccountWarning,
                                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: _deletingAccount
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Icon(Icons.delete_forever),
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
                  ],
                ),
        ),
      ),
    );
  }
}
