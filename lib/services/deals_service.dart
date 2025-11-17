// lib/services/deals_service.dart
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:atyourservice/utils/notification_service.dart';

class DealsService {
  final SupabaseClient supa;
  DealsService(this.supa);

  // ============== Common ==============

  Future<void> publishDeal(String dealId, {bool attested = true}) async {
    await supa
        .from('deals')
        .update({
          'status': 'live',
          'attested': attested,
          'published_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', dealId);
  }

  Future<void> unpublishDeal(String dealId) async {
    await supa.from('deals').update({'status': 'draft'}).eq('id', dealId);
  }

  Future<void> deleteDraft(String dealId) async {
    await supa.from('deals').delete().eq('id', dealId);
  }

  Future<List<Map<String, dynamic>>> fetchApplicationsForDeal(
    String dealId,
  ) async {
    final rows = await supa
        .from('applications')
        .select('id, deal_id, buyer_id, note, status, created_at')
        .eq('deal_id', dealId)
        .order('created_at', ascending: false);

    return (rows as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// Bewerbung erstellen und (falls nicht Eigenbewerbung) Push an Verkäufer schicken.
  Future<Map<String, dynamic>> applyForDeal({
    required String dealId,
    String? note,
  }) async {
    final user = supa.auth.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }

    // 1) Bewerbung anlegen
    final inserted = await supa
        .from('applications')
        .insert({
          'deal_id': dealId,
          'buyer_id': user.id,
          if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
        })
        .select('id, deal_id, buyer_id, note, status, created_at')
        .single();

    final app = Map<String, dynamic>.from(inserted as Map);

    // 2) Deal laden (für Push)
    final dealRow = await supa
        .from('deals')
        .select('id, seller_id, title, type')
        .eq('id', dealId)
        .maybeSingle();

    if (dealRow == null) {
      if (kDebugMode) {
        print('⚠️ applyForDeal: Deal $dealId nicht gefunden, kein Push.');
      }
      return app;
    }

    final deal = Map<String, dynamic>.from(dealRow as Map);
    final sellerUserId = deal['seller_id'] as String?;
    final dealTitle = (deal['title'] as String?) ?? 'Dein Auftrag';
    final type = (deal['type'] as String?) ?? '';
    final isS1 = type.toLowerCase() == 's1';

    // 3) Bewerbername bestimmen
    final applicantName =
        (user.userMetadata?['display_name'] as String?) ??
        (user.userMetadata?['full_name'] as String?) ??
        (user.userMetadata?['name'] as String?) ??
        (user.email ?? 'Ein Dienstleister');

    // 4) Push an Verkäufer – außer bei Eigenbewerbung
    if (sellerUserId != null && sellerUserId != user.id) {
      try {
        await NotificationService.sendNewApplicationForDeal(
          sellerUserId: sellerUserId,
          dealId: dealId,
          dealTitle: dealTitle,
          applicantName: applicantName,
          isS1: isS1,
        );
      } catch (e, st) {
        if (kDebugMode) {
          print('❌ Fehler Bewerbungs-Push: $e');
          print(st);
        }
      }
    }

    return app;
  }

  /// Markiert eine Bewerbung als 'awarded', setzt den Deal auf 'awarded'
  /// und schickt Push an den Gewinner.
  /// Robust gegen fehlende DB-Spalten (z.B. awarded_at / awarded_application_id).
  Future<void> awardApplication(String applicationId) async {
    // 1) Application -> awarded
    final updated = await supa
        .from('applications')
        .update({'status': 'awarded'})
        .eq('id', applicationId)
        .select('id, deal_id, buyer_id')
        .single();

    final app = Map<String, dynamic>.from(updated as Map);
    final dealId = app['deal_id'] as String?;
    final awardedUserId = app['buyer_id'] as String?;
    if (dealId == null || awardedUserId == null) return;

    // 2) Deal-Daten (für Push + isS1)
    final dealRow = await supa
        .from('deals')
        .select('id, title, type')
        .eq('id', dealId)
        .single();

    final deal = Map<String, dynamic>.from(dealRow as Map);
    final dealTitle = (deal['title'] as String?) ?? 'Dein Auftrag';
    final type = (deal['type'] as String?) ?? '';
    final isS1 = type.toLowerCase() == 's1';

    // 3) Deal auf 'awarded' setzen (mit Fallback, falls Spalten fehlen)
    try {
      await supa
          .from('deals')
          .update({
            'status': 'awarded',
            // Falls vorhanden – auskommentiert, um 42703 zu vermeiden:
            // 'awarded_application_id': applicationId,
            'awarded_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', dealId);
    } catch (_) {
      // Fallback: nur den Status aktualisieren
      await supa.from('deals').update({'status': 'awarded'}).eq('id', dealId);
    }

    // 4) Push an den beauftragten Dienstleister
    try {
      await NotificationService.sendDealAwardedPush(
        receiverUserId: awardedUserId,
        dealId: dealId,
        dealTitle: dealTitle,
        isS1: isS1,
      );
    } catch (e, st) {
      if (kDebugMode) {
        print('❌ Fehler Beauftragungs-Push: $e');
        print(st);
      }
    }
  }

  // Hilfsfunktion: Default-Start/Deadline
  Map<String, String> _defaultDatesUtc() {
    final now = DateTime.now().toUtc();
    final start = DateTime.utc(now.year, now.month, now.day);
    final deadline = start.add(const Duration(days: 30));
    return {
      'start_after': start.toIso8601String(),
      'deadline': deadline.toIso8601String(),
    };
  }

  // ============== S0 ==============

  Future<String> createDraftShellS0({required String title}) async {
    final uid = supa.auth.currentUser?.id;
    if (uid == null) throw Exception('Not authenticated');

    final dates = _defaultDatesUtc();

    final inserted = await supa
        .from('deals')
        .insert({
          'seller_id': uid,
          'title': title.trim().isEmpty ? 'Entwurf' : title.trim(),
          'description': '',
          'location_text': '',
          'category': '',
          'status': 'draft',
          'type': 's0',
          'start_after': dates['start_after'],
          'deadline': dates['deadline'],
        })
        .select('id')
        .single();

    return inserted['id'] as String;
  }

  Future<void> updateDraftS0({
    required String dealId,
    required String title,
    required String description,
    required String locationText,
    required DateTime startAfter,
    required DateTime deadline,
    required int targetPriceCents,
    required String provisionType, // 'percent' | 'fixed'
    required double provisionValue,
    required String provisionDue, // 'award' | 'handover' | 'finalInvoice'
    required double locationLat,
    required double locationLng,
    required String category,
  }) async {
    await supa
        .from('deals')
        .update({
          'title': title,
          'description': description,
          'location_text': locationText,
          'location_lat': locationLat,
          'location_lng': locationLng,
          'start_after': startAfter.toUtc().toIso8601String(),
          'deadline': deadline.toUtc().toIso8601String(),
          'category': category,
          'type': 's0',
        })
        .eq('id', dealId);

    await supa.from('deal_s0').upsert({
      'deal_id': dealId,
      'target_price_cents': targetPriceCents,
      'provision_type': provisionType,
      'provision_value': provisionValue,
      'provision_due': provisionDue,
    });
  }

  Future<String> createDealS0({
    required String title,
    required String description,
    required String locationText,
    required DateTime startAfter,
    required DateTime deadline,
    required int targetPriceCents,
    required String provisionType,
    required double provisionValue,
    required String provisionDue,
    required double locationLat,
    required double locationLng,
    required String category,
  }) async {
    final id = await createDraftShellS0(title: title);
    await updateDraftS0(
      dealId: id,
      title: title,
      description: description,
      locationText: locationText,
      startAfter: startAfter,
      deadline: deadline,
      targetPriceCents: targetPriceCents,
      provisionType: provisionType,
      provisionValue: provisionValue,
      provisionDue: provisionDue,
      locationLat: locationLat,
      locationLng: locationLng,
      category: category,
    );
    return id;
  }

  Future<void> upsertVerification({
    required String dealId,
    required bool hasCustomerOk,
    List<String>? customerOkUrls,
    List<String>? offerUrls,
    String? customerName,
    String? customerPhoneE164,
    String? customerPhoneLast4,
  }) async {
    final payload = <String, dynamic>{
      'deal_id': dealId,
      'has_customer_ok': hasCustomerOk,
    };
    if (customerOkUrls != null) payload['customer_ok_urls'] = customerOkUrls;
    if (offerUrls != null) payload['offer_urls'] = offerUrls;
    if (customerName != null) payload['customer_name'] = customerName;
    if (customerPhoneE164 != null) {
      payload['customer_phone_e164'] = customerPhoneE164;
    }
    if (customerPhoneLast4 != null) {
      payload['customer_phone_last4'] = customerPhoneLast4;
    }

    await supa.from('verifications').upsert(payload);
  }

  // ============== S1 ==============

  Future<String> createDraftShellS1({
    required String title,
    String description = '',
    String locationText = '',
    String category = '',
    DateTime? startAfter,
    DateTime? deadline,
    double? locationLat,
    double? locationLng,
  }) async {
    final uid = supa.auth.currentUser?.id;
    if (uid == null) throw Exception('Not authenticated');

    final defaults = _defaultDatesUtc();

    final insertMap = <String, dynamic>{
      'seller_id': uid,
      'title': title.trim().isEmpty ? 'Entwurf' : title.trim(),
      'description': description,
      'location_text': locationText,
      'category': category,
      'start_after': (startAfter ?? DateTime.parse(defaults['start_after']!))
          .toUtc()
          .toIso8601String(),
      'deadline': (deadline ?? DateTime.parse(defaults['deadline']!))
          .toUtc()
          .toIso8601String(),
      'status': 'draft',
      'type': 's1',
    };
    if (locationLat != null) insertMap['location_lat'] = locationLat;
    if (locationLng != null) insertMap['location_lng'] = locationLng;

    final inserted = await supa
        .from('deals')
        .insert(insertMap)
        .select('id')
        .single();

    await supa.from('deal_s1').upsert({
      'deal_id': inserted['id'],
      'pricing_mode': 'fixed',
      'provision_type': 'percent',
      'provision_value': 0.0,
      'provision_due': 'award',
    });

    return inserted['id'] as String;
  }

  Future<void> updateS1Basics({
    required String dealId,
    required String title,
    required String description,
    required String locationText,
    required String category,
    DateTime? startAfter,
    DateTime? deadline,
    double? locationLat,
    double? locationLng,
  }) async {
    final updateMap = <String, dynamic>{
      'title': title,
      'description': description,
      'location_text': locationText,
      'category': category,
      'type': 's1',
    };
    if (startAfter != null) {
      updateMap['start_after'] = startAfter.toUtc().toIso8601String();
    }
    if (deadline != null) {
      updateMap['deadline'] = deadline.toUtc().toIso8601String();
    }
    if (locationLat != null) {
      updateMap['location_lat'] = locationLat;
    }
    if (locationLng != null) {
      updateMap['location_lng'] = locationLng;
    }

    await supa.from('deals').update(updateMap).eq('id', dealId);
  }

  Future<void> updateS1Pricing({
    required String dealId,
    required String pricingMode, // 'fixed' | 'tm'
    int? basePriceCents,
    double? vatRate,
    int? hourlyRateCents,
    double? expectedHours,
    required String provisionType, // 'percent' | 'fixed'
    required double provisionValue,
    required String provisionDue, // 'award' | 'date' | 'handover' | 'custom'
  }) async {
    await supa.from('deal_s1').upsert({
      'deal_id': dealId,
      'pricing_mode': pricingMode,
      'base_price_cents': basePriceCents,
      'vat_rate': vatRate,
      'hourly_rate_cents': hourlyRateCents,
      'expected_hours': expectedHours,
      'provision_type': provisionType,
      'provision_value': provisionValue,
      'provision_due': provisionDue,
    });
  }

  // ============== Uploads / Verifications ==============

  static const _bucket = 'deal-evidence';

  Future<String> uploadEvidence({
    required String dealId,
    required String kind, // 'preview' | 'offer' | 'ok'
    required String fileName,
    required Uint8List bytes,
  }) async {
    final uid = supa.auth.currentUser?.id;
    if (uid == null) throw Exception('Not authenticated');

    final ts = DateTime.now().millisecondsSinceEpoch;
    final safeName = _sanitizeFileName(fileName);
    final path = '$uid/$dealId/$kind/${ts}_$safeName';

    final contentType =
        lookupMimeType(fileName, headerBytes: bytes.take(16).toList()) ??
        'application/octet-stream';

    await supa.storage
        .from(_bucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: false,
            contentType: contentType,
          ),
        );

    return path;
  }

  Future<String> signedUrlFor(
    String path, {
    Duration ttl = const Duration(minutes: 30),
  }) async {
    return await supa.storage
        .from(_bucket)
        .createSignedUrl(path, ttl.inSeconds);
  }

  Future<void> upsertVerificationS1({
    required String dealId,
    List<String>? offerUrls,
    bool? hasCustomerOk,
  }) async {
    final payload = <String, dynamic>{'deal_id': dealId};
    if (offerUrls != null) payload['offer_urls'] = offerUrls;
    if (hasCustomerOk != null) payload['has_customer_ok'] = hasCustomerOk;
    await supa.from('verifications').upsert(payload);
  }

  // ============== OTP (Edge Functions) ==============

  Future<void> sendCustomerOkOtp({
    required String dealId,
    required String phoneE164,
  }) async {
    await supa.functions.invoke(
      'otp-send',
      body: {'deal_id': dealId, 'phone_e164': phoneE164},
    );
  }

  Future<bool> verifyCustomerOkOtp({
    required String dealId,
    required String code,
  }) async {
    final res = await supa.functions.invoke(
      'otp-verify',
      body: {'deal_id': dealId, 'code': code},
    );
    final data = res.data;
    return (data is Map && data['verified'] == true);
  }

  // ---- Helpers ----

  String _sanitizeFileName(String name) {
    final cleaned = name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return cleaned.isEmpty ? 'file' : cleaned;
  }
}
