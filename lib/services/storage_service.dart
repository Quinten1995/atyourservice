import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageEntry {
  final String path; // <uid>/<dealId>/<type>/<file>
  final String name;
  final Map<String, dynamic>? metadata;
  final String? updatedAt;
  final String? createdAt;
  final String? lastAccessedAt;

  const StorageEntry({
    required this.path,
    required this.name,
    this.metadata,
    this.updatedAt,
    this.createdAt,
    this.lastAccessedAt,
  });
}

class StorageService {
  static const bucket = 'deal-evidence';
  final SupabaseClient sb;
  StorageService(this.sb);

  Future<String> uploadEvidenceBytes({
    required Uint8List bytes,
    required String originalName,
    required String dealId,
    required String type, // "ok" | "offer" | "preview"
  }) async {
    final uid = sb.auth.currentUser?.id;
    if (uid == null) {
      throw Exception('Not authenticated');
    }

    final ext = _safeExt(originalName);
    final safeBase = _safeBase(originalName);
    final ts = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${ts}_$safeBase$ext';
    final path = '$uid/$dealId/$type/$fileName';

    final contentType =
        lookupMimeType(originalName, headerBytes: bytes.take(16).toList()) ??
        'application/octet-stream';

    await sb.storage
        .from(bucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(upsert: false, contentType: contentType),
        );

    return path;
  }

  Future<void> deleteEvidencePath(String path) async {
    await sb.storage.from(bucket).remove([path]);
  }

  Future<String> createSignedUrl(String path, {Duration? ttl}) async {
    final seconds = (ttl ?? const Duration(minutes: 30)).inSeconds;
    return await sb.storage.from(bucket).createSignedUrl(path, seconds);
  }

  Future<List<StorageEntry>> listPreviewObjects({
    required String dealId,
    int limit = 100,
  }) async {
    final uid = sb.auth.currentUser?.id;
    if (uid == null) return const [];
    final s = sb.storage.from(bucket);
    final prefix = '$uid/$dealId/preview';
    final list = await s.list(path: prefix);
    if (list.isEmpty) return const [];
    return list.take(limit).map((fo) {
      final full = '$prefix/${fo.name}';
      return StorageEntry(
        path: full,
        name: fo.name,
        metadata: fo.metadata,
        updatedAt: fo.updatedAt,
        createdAt: fo.createdAt,
        lastAccessedAt: fo.lastAccessedAt,
      );
    }).toList();
  }

  Future<List<String>> listPreviewSignedUrls({
    required String dealId,
    int limit = 100,
    Duration ttl = const Duration(minutes: 30),
  }) async {
    final objs = await listPreviewObjects(dealId: dealId, limit: limit);
    final urls = <String>[];
    for (final o in objs) {
      urls.add(await createSignedUrl(o.path, ttl: ttl));
    }
    return urls;
  }

  String _safeExt(String name) {
    final dot = name.lastIndexOf('.');
    if (dot <= 0 || dot == name.length - 1) return '';
    final raw = name.substring(dot).toLowerCase();
    const ok = ['.pdf', '.png', '.jpg', '.jpeg', '.heic', '.webp'];
    return ok.contains(raw) ? raw : '';
  }

  String _safeBase(String name) {
    final base = name.contains('.')
        ? name.substring(0, name.lastIndexOf('.'))
        : name;
    return base.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  }
}
