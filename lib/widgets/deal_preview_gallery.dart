// lib/widgets/deal_preview_gallery.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Zeigt öffentliche Previews aus `deal-evidence/<dealId>/preview`
/// ODER aus `deal-evidence/<sellerId>/<dealId>/preview` (aktuelles Schema).
class DealPreviewGallery extends StatefulWidget {
  final String dealId;
  final String? sellerId; // optional (beschleunigt Listing)
  final int maxItems;
  final EdgeInsetsGeometry padding;
  final String? title;

  const DealPreviewGallery({
    super.key,
    required this.dealId,
    this.sellerId,
    this.maxItems = 12,
    this.padding = const EdgeInsets.all(0),
    this.title,
  });

  @override
  State<DealPreviewGallery> createState() => _DealPreviewGalleryState();
}

class _DealPreviewGalleryState extends State<DealPreviewGallery> {
  static const _bucket = 'deal-evidence';
  bool _loading = true;
  String? _error;
  List<_PreviewItem> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _items = const [];
    });

    try {
      final items = await _resolvePreviewItems(
        dealId: widget.dealId,
        sellerId: widget.sellerId,
        limit: widget.maxItems,
      );
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  /// 1) <dealId>/preview
  /// 2) <sellerId>/<dealId>/preview
  /// 3) Fallback: alle Top-Level-Ordner (UIDs) durchsuchen
  Future<List<_PreviewItem>> _resolvePreviewItems({
    required String dealId,
    String? sellerId,
    required int limit,
  }) async {
    final storage = Supabase.instance.client.storage.from(_bucket);

    Future<List<_PreviewItem>> _listAndSignAtPrefix(String prefix) async {
      final list = await storage.list(path: prefix);
      if (list.isEmpty) return const [];
      final files = list.take(limit).toList();

      final futures = files.map((f) async {
        final path = '$prefix/${f.name}';
        final signed = await storage.createSignedUrl(path, 60 * 10); // 10 Min
        return _PreviewItem(
          name: f.name,
          path: path,
          signedUrl: signed,
          mimeType: f.metadata?['mimetype']?.toString(),
          size: (f.metadata?['size'] as num?)?.toInt(),
        );
      });
      return Future.wait(futures);
    }

    final p1 = '$dealId/preview';
    final tryP1 = await _listAndSignAtPrefix(p1);
    if (tryP1.isNotEmpty) return tryP1;

    if (sellerId != null && sellerId.isNotEmpty) {
      final p2 = '$sellerId/$dealId/preview';
      final tryP2 = await _listAndSignAtPrefix(p2);
      if (tryP2.isNotEmpty) return tryP2;
    }

    // Fallback: Top-Level
    final roots = await storage.list();
    for (final root in roots) {
      final uidFolder = root.name;
      if (uidFolder.isEmpty) continue;
      final p3 = '$uidFolder/$dealId/preview';
      final tryP3 = await _listAndSignAtPrefix(p3);
      if (tryP3.isNotEmpty) return tryP3;
    }

    return const [];
  }

  bool _isImage(_PreviewItem it) {
    final m = (it.mimeType ?? '').toLowerCase();
    return m.startsWith('image/') ||
        it.name.toLowerCase().endsWith('.png') ||
        it.name.toLowerCase().endsWith('.jpg') ||
        it.name.toLowerCase().endsWith('.jpeg') ||
        it.name.toLowerCase().endsWith('.webp') ||
        it.name.toLowerCase().endsWith('.heic');
  }

  bool _isPdf(_PreviewItem it) {
    final m = (it.mimeType ?? '').toLowerCase();
    return m == 'application/pdf' || it.name.toLowerCase().endsWith('.pdf');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Padding(
        padding: widget.padding,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Padding(
        padding: widget.padding,
        child: _ErrorBox(
          text: 'Preview konnte nicht geladen werden:\n$_error',
          onRetry: _load,
        ),
      );
    }

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
          ],
          if (_items.isEmpty)
            _EmptyBox(onRetry: _load)
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (_, i) {
                final it = _items[i];
                final isImage = _isImage(it);
                final isPdf = _isPdf(it);

                return InkWell(
                  onTap: () {
                    // Bilder im In-App Viewer, PDFs/sonstige extern öffnen
                    if (isImage) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PreviewViewerScreen(item: it),
                        ),
                      );
                    } else {
                      _openExternal(context, it.signedUrl);
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: isImage
                              ? Image.network(
                                  it.signedUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _ThumbFallback(name: it.name),
                                )
                              : Container(
                                  color: Colors.grey.shade200,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    isPdf
                                        ? Icons.picture_as_pdf
                                        : Icons.insert_drive_file,
                                    size: 32,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        left: 6,
                        bottom: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isPdf ? 'PDF' : (isImage ? 'IMG' : 'FILE'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Future<void> _openExternal(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await canLaunchUrl(uri);
    if (!ok) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konnte URL nicht öffnen')),
        );
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _PreviewItem {
  final String name;
  final String path;
  final String signedUrl;
  final String? mimeType;
  final int? size;

  _PreviewItem({
    required this.name,
    required this.path,
    required this.signedUrl,
    this.mimeType,
    this.size,
  });
}

class _ThumbFallback extends StatelessWidget {
  final String name;
  const _ThumbFallback({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Text(
        name,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String text;
  final VoidCallback onRetry;
  const _ErrorBox({required this.text, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.red.shade800, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(onPressed: onRetry, child: const Text('Neu laden')),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyBox({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.visibility_off, color: Colors.grey.shade700, size: 18),
          const SizedBox(width: 8),
          const Expanded(child: Text('Aktuell keine Previews vorhanden.')),
          TextButton(onPressed: onRetry, child: const Text('Neu laden')),
        ],
      ),
    );
  }
}

/// Einfacher Bild-Viewer (für Images).
class PreviewViewerScreen extends StatelessWidget {
  final _PreviewItem item;
  const PreviewViewerScreen({super.key, required this.item});

  bool get _isImage {
    final m = (item.mimeType ?? '').toLowerCase();
    return m.startsWith('image/') ||
        item.name.toLowerCase().endsWith('.png') ||
        item.name.toLowerCase().endsWith('.jpg') ||
        item.name.toLowerCase().endsWith('.jpeg') ||
        item.name.toLowerCase().endsWith('.webp') ||
        item.name.toLowerCase().endsWith('.heic');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: InteractiveViewer(
        child: Center(
          child: Image.network(item.signedUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
