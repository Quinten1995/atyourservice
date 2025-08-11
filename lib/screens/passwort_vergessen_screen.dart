import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/app_localizations.dart';

class PasswortVergessenScreen extends StatefulWidget {
  const PasswortVergessenScreen({Key? key}) : super(key: key);

  @override
  State<PasswortVergessenScreen> createState() => _PasswortVergessenScreenState();
}

class _PasswortVergessenScreenState extends State<PasswortVergessenScreen> {
  final _emailController = TextEditingController();
  bool _sending = false;
  String? _feedback;

  Future<void> _sendeResetLink() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _sending = true;
      _feedback = null;
    });
    try {
      final email = _emailController.text.trim();
      if (email.isEmpty) {
        setState(() => _feedback = l10n.emailValidatorEmpty);
        return;
      }

      // Wichtig: redirectTo zu deinem App-Deeplink setzen
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'atyourservice://login-callback',
      );

      setState(() => _feedback = l10n.resetMailSent);
    } catch (e) {
      setState(() => _feedback = "${l10n.errorPrefix(e.toString())}");
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotPasswordButton)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              l10n.forgotPasswordInfo,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l10n.emailLabel),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _sending ? null : _sendeResetLink,
              child: _sending
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(l10n.sendResetLinkButton),
            ),
            if (_feedback != null) ...[
              const SizedBox(height: 16),
              Text(
                _feedback!,
                style: const TextStyle(color: Colors.teal),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
