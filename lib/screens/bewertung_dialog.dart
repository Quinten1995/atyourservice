import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BewertungDialog extends StatefulWidget {
  final String auftragId;
  final String dienstleisterId;

  const BewertungDialog({
    Key? key,
    required this.auftragId,
    required this.dienstleisterId,
  }) : super(key: key);

  @override
  State<BewertungDialog> createState() => _BewertungDialogState();
}

class _BewertungDialogState extends State<BewertungDialog> {
  int _bewertung = 5;
  String? _kommentar;
  bool _isLoading = false;
  String? _error;

  final supabase = Supabase.instance.client;

  Future<void> _absenden() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('Nicht eingeloggt.');

      // Prüfen, ob schon eine Bewertung existiert
      final exist = await supabase
          .from('bewertungen')
          .select('id')
          .eq('auftrag_id', widget.auftragId)
          .eq('kunde_id', userId)
          .maybeSingle();

      if (exist != null) {
        setState(() {
          _error = "Du hast diesen Auftrag bereits bewertet.";
          _isLoading = false;
        });
        return;
      }

      await supabase.from('bewertungen').insert({
        'auftrag_id': widget.auftragId,
        'kunde_id': userId,
        'dienstleister_id': widget.dienstleisterId,
        'bewertung': _bewertung,
        'kommentar': _kommentar,
      });

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dienstleister bewerten'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: _bewertung.toDouble(),
            minRating: 1,
            maxRating: 5,
            allowHalfRating: false,
            itemCount: 5,
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) => _bewertung = rating.round(),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Kommentar (optional)',
            ),
            minLines: 2,
            maxLines: 4,
            onChanged: (v) => _kommentar = v,
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ]
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _absenden,
          child: _isLoading ? const CircularProgressIndicator() : const Text('Abschicken'),
        ),
      ],
    );
  }
}
