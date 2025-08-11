import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/app_localizations.dart';
import 'start_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _pwd = TextEditingController();
  final _pwd2 = TextEditingController();
  bool _saving = false;
  String? _msg;

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final p1 = _pwd.text.trim();
    final p2 = _pwd2.text.trim();

    if (p1.isEmpty || p2.isEmpty) {
      setState(() => _msg = l10n.passwordEmptyError);
      return;
    }
    if (p1 != p2) {
      setState(() => _msg = l10n.passwordsDontMatch);
      return;
    }
    if (p1.length < 8) {
      setState(() => _msg = l10n.passwordTooShort);
      return;
    }

    setState(() {
      _saving = true;
      _msg = null;
    });

    try {
      // Passwort aktualisieren (Supabase hat temporäre Session bei Recovery)
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: p1),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.passwordResetSuccess)),
      );

      // Optional: direkt ausloggen
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const StartScreen()),
        (_) => false,
      );
    } catch (e) {
      setState(() => _msg = e.toString());
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _pwd.dispose();
    _pwd2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.setNewPasswordTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.setNewPasswordInfo),
            const SizedBox(height: 20),
            TextField(
              controller: _pwd,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.newPasswordLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pwd2,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.confirmNewPasswordLabel),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(l10n.saveNewPasswordButton),
            ),
            if (_msg != null) ...[
              const SizedBox(height: 16),
              Text(_msg!, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}
