import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/kategorien.dart';
import '../l10n/app_localizations.dart'; // NEU: Lokalisation importieren

class RegistrierungScreen extends StatefulWidget {
  const RegistrierungScreen({Key? key}) : super(key: key);

  @override
  State<RegistrierungScreen> createState() => _RegistrierungScreenState();
}

class _RegistrierungScreenState extends State<RegistrierungScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'quintenhessmann1995@yahoo.com');
  final _passwordController = TextEditingController(text: 'password123');
  String _rolle = 'kunde';
  String? _selectedKategorie;
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  Future<void> _registrieren() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final response = await supabase.auth.signUp(email: email, password: password);

      final identities = response.user?.identities;
      if (identities != null && identities.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.registerSuccess),
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.registerExists),
          ),
        );
        // KEIN pop im Fehlerfall!
      }
    } on AuthException catch (authError) {
      final err = authError.message.toLowerCase();
      String userMessage;
      if (err.contains('already registered') ||
          err.contains('duplicate') ||
          err.contains('user exists')) {
        userMessage = AppLocalizations.of(context)!.registerExists;
      } else if (err.contains('invalid email')) {
        userMessage = AppLocalizations.of(context)!.registerInvalidEmail;
      } else if (err.contains('password')) {
        userMessage = AppLocalizations.of(context)!.registerPasswordShort;
      } else {
        userMessage = AppLocalizations.of(context)!.registerFailed(authError.message);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userMessage)),
      );
      // KEIN pop im Fehlerfall!
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.registerUnknownError(e.toString()))),
      );
      // KEIN pop im Fehlerfall!
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.registerAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.registerTitle,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Rollenwahl (Kunde / Dienstleister)
                  DropdownButtonFormField<String>(
                    value: _rolle,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.roleLabel,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'kunde',
                        child: Text(AppLocalizations.of(context)!.roleKunde),
                      ),
                      DropdownMenuItem(
                        value: 'dienstleister',
                        child: Text(AppLocalizations.of(context)!.roleDienstleister),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _rolle = value;
                          if (_rolle != 'dienstleister') _selectedKategorie = null;
                        });
                      }
                    },
                  ),

                  // Kategorie-Auswahl nur bei Dienstleister!
                  if (_rolle == 'dienstleister') ...[
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedKategorie ?? kategorieListe.first,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.categoryLabel,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                      items: kategorieListe.map((kategorie) {
                        return DropdownMenuItem(
                          value: kategorie,
                          child: Text(kategorie),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedKategorie = value);
                      },
                      validator: (value) => (_rolle == 'dienstleister' && (value == null || value.isEmpty))
                          ? AppLocalizations.of(context)!.categoryValidator
                          : null,
                    ),
                  ],

                  const SizedBox(height: 20),

                  // E-Mail-Feld
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.emailLabel,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppLocalizations.of(context)!.emailEmpty;
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return AppLocalizations.of(context)!.emailInvalid;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Passwort-Feld
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.passwordLabel,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppLocalizations.of(context)!.passwordEmpty;
                      if (value.length < 6) return AppLocalizations.of(context)!.passwordTooShort;
                      return null;
                    },
                  ),

                  const SizedBox(height: 34),

                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _registrieren,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              shadowColor: primaryColor.withOpacity(0.20),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.registerButton,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
