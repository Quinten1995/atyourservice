import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show Supabase, PostgrestException;
import 'package:file_picker/file_picker.dart';

import '../../l10n/app_localizations.dart';
import 'package:atyourservice/services/deals_service.dart';
import 'package:atyourservice/models/handel_enums.dart';
import 'package:atyourservice/utils/geocoding_service.dart';

class HandelErstellenScreen extends StatefulWidget {
  final Map<String, dynamic>? existingDeal;
  const HandelErstellenScreen({super.key, this.existingDeal});

  @override
  State<HandelErstellenScreen> createState() => _HandelErstellenScreenState();
}

class _HandelErstellenScreenState extends State<HandelErstellenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollCtrl = ScrollController();

  String? _draftDealId;

  // Basisfelder
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  DateTime? _startAfter;
  DateTime? _deadline;

  // Kategorie
  String? _category;

  // S0
  final _targetPriceCtrl = TextEditingController();

  // Provision nur noch als Prozent
  ProvisionType _provisionType = ProvisionType.percent;
  final _provisionValueCtrl = TextEditingController();
  ProvisionDue _provisionDue = ProvisionDue.award;

  // Nachweise – echte Storage-Pfade
  final List<String> _okFiles = [];
  final List<String> _offerFiles = [];
  final List<String> _previewFiles = [];

  // optionale Kundenmetadaten
  final _customerNameCtrl = TextEditingController();
  final _customerPhoneCtrl = TextEditingController();

  bool _attested = false;

  bool _submitting = false;
  bool _uploadingOk = false;
  bool _uploadingOffer = false;
  bool _uploadingPreview = false;

  bool _publishNow = false;

  late final OutlineInputBorder _rounded;
  final EdgeInsets _inputPadding = const EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 12,
  );
  final double _fieldHeight = 60;

  bool get _hasExisting => widget.existingDeal != null;
  String? get _existingDealId => widget.existingDeal?['id'] as String?;
  String? get _effectiveDealId => _existingDealId ?? _draftDealId;

  List<String> _categoriesL10n(BuildContext ctx) => [
    AppLocalizations.of(ctx)!.categoryRoofer,
    AppLocalizations.of(ctx)!.categorySolar,
    AppLocalizations.of(ctx)!.categoryHVAC,
    AppLocalizations.of(ctx)!.categoryElectrical,
    AppLocalizations.of(ctx)!.categoryDrywall,
    AppLocalizations.of(ctx)!.categoryPainter,
    AppLocalizations.of(ctx)!.categoryTiling,
    AppLocalizations.of(ctx)!.categoryFlooring,
    AppLocalizations.of(ctx)!.categoryWindowsDoors,
    AppLocalizations.of(ctx)!.categoryInsulationFacade,
    AppLocalizations.of(ctx)!.categoryMasonryConcrete,
    AppLocalizations.of(ctx)!.categoryCarpentryJoinery,
    AppLocalizations.of(ctx)!.categoryLandscaping,
    AppLocalizations.of(ctx)!.categoryScaffolding,
    AppLocalizations.of(ctx)!.categoryCleaningRestoration,
    AppLocalizations.of(ctx)!.categoryMovingTransport,
  ];

  // ==== Telefonnummer ====
  final _e164 = RegExp(r'^\+[1-9]\d{6,14}$');
  String? _normalizeE164(String raw) {
    if (raw.trim().isEmpty) return null;
    final s = raw.replaceAll(RegExp(r'\s|-|\(|\)'), '');
    return _e164.hasMatch(s) ? s : null;
  }

  String _last4(String e164) =>
      e164.length >= 4 ? e164.substring(e164.length - 4) : e164;

  @override
  void initState() {
    super.initState();
    _rounded = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1),
    );

    final d = widget.existingDeal;
    if (d != null) {
      _draftDealId = d['id'] as String?;
      _titleCtrl.text = (d['title'] ?? '').toString();
      _descCtrl.text = (d['description'] ?? '').toString();
      _locationCtrl.text = (d['location_text'] ?? '').toString();
      final c = (d['category'] ?? '').toString();
      _category = c.isEmpty ? null : c;

      final startIso = (d['start_after'] ?? '').toString();
      final deadlineIso = (d['deadline'] ?? '').toString();
      if (startIso.isNotEmpty) {
        _startAfter = DateTime.tryParse(startIso)?.toLocal();
      }
      if (deadlineIso.isNotEmpty) {
        _deadline = DateTime.tryParse(deadlineIso)?.toLocal();
      }

      final s0 = d['deal_s0'] as Map<String, dynamic>?;
      if (s0 != null) {
        final cents = s0['target_price_cents'];
        if (cents is int) {
          _targetPriceCtrl.text = (cents / 100).toStringAsFixed(2);
        }

        // Provision aus bestehendem Deal (wir lesen, aber UI bleibt Prozent-only)
        final pVal = (s0['provision_value'] ?? '').toString();
        if (pVal.isNotEmpty) {
          _provisionValueCtrl.text = pVal;
        }

        final due = (s0['provision_due'] ?? 'award').toString();
        switch (due) {
          case 'handover':
            _provisionDue = ProvisionDue.handover;
            break;
          case 'finalInvoice':
            _provisionDue = ProvisionDue.finalInvoice;
            break;
          default:
            _provisionDue = ProvisionDue.award;
        }
      }

      _publishNow = false;

      final v = d['verifications'] as Map<String, dynamic>?;
      if (v != null) {
        final ok = (v['customer_ok_urls'] as List?)?.cast<String>() ?? const [];
        final offer = (v['offer_urls'] as List?)?.cast<String>() ?? const [];
        _okFiles.addAll(ok);
        _offerFiles.addAll(offer);
        final preview =
            (v['preview_urls'] as List?)?.cast<String>() ?? const [];
        _previewFiles.addAll(preview);

        final String? phone = (v['customer_phone_e164'] as String?);
        if (phone != null && phone.isNotEmpty) {
          _customerPhoneCtrl.text = phone;
        }
        final String? name = (v['customer_name'] as String?);
        if (name != null && name.isNotEmpty) {
          _customerNameCtrl.text = name;
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _targetPriceCtrl.dispose();
    _provisionValueCtrl.dispose();
    _customerNameCtrl.dispose();
    _customerPhoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = (isStart ? (_startAfter ?? now) : (_deadline ?? now));
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      initialDate: initial,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startAfter = picked;
          if (_deadline != null && _deadline!.isBefore(_startAfter!)) {
            _deadline = null;
          }
        } else {
          _deadline = picked;
        }
      });
    }
  }

  String? _required(String? v) {
    final l10n = AppLocalizations.of(context)!;
    return (v == null || v.trim().isEmpty) ? l10n.formErrorRequired : null;
  }

  String? _validateMoney(String? v) {
    final l10n = AppLocalizations.of(context)!;
    if (v == null || v.trim().isEmpty) return l10n.formErrorRequired;
    final num? n = num.tryParse(v.replaceAll(',', '.'));
    if (n == null) return l10n.formErrorInvalidAmount;
    if (n <= 0) return l10n.formErrorGreaterZero;
    if (n > 1000000) return l10n.formErrorRealistic;
    return null;
  }

  // Nur noch Prozent-Provision
  String? _validateProvisionPercent(String? v) {
    final l10n = AppLocalizations.of(context)!;
    if (v == null || v.trim().isEmpty) return l10n.formErrorRequired;
    final num? n = num.tryParse(v.replaceAll(',', '.'));
    if (n == null) return l10n.formErrorInvalidValue;
    if (n <= 0 || n > 30) return l10n.formErrorPercentRange;
    return null;
  }

  int _eurToCents(String s) {
    final n = num.parse(s.replaceAll(',', '.'));
    return (n * 100).round();
  }

  List<String> _collectFormErrors(AppLocalizations l10n) {
    final errs = <String>[];
    if (_titleCtrl.text.trim().isEmpty) errs.add(l10n.fieldTitle);
    if (_descCtrl.text.trim().isEmpty) errs.add(l10n.fieldDescription);
    if (_locationCtrl.text.trim().isEmpty) errs.add(l10n.fieldLocation);
    if (_startAfter == null) errs.add(l10n.pickStartDate);
    if (_deadline == null) errs.add(l10n.pickDeadline);
    if (_category == null || _category!.trim().isEmpty) {
      errs.add(l10n.fieldCategory);
    }
    if (_targetPriceCtrl.text.trim().isEmpty) {
      errs.add(l10n.fieldTargetPriceEur);
    }
    if (_provisionValueCtrl.text.trim().isEmpty) {
      errs.add(l10n.fieldProvisionValuePercent);
    }
    if (_publishNow && _okFiles.isEmpty) errs.add(l10n.errCustomerOkRequired);
    if (_publishNow && !_attested) errs.add(l10n.errAttestRequired);
    return errs;
  }

  void _dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  // ---------- Upload helpers über DealsService ----------
  Future<void> _ensureShellDealForUpload() async {
    if (_effectiveDealId != null) return;
    final svc = DealsService(Supabase.instance.client);
    final l10n = AppLocalizations.of(context)!;
    final title = _titleCtrl.text.trim().isEmpty
        ? l10n.draftDefaultTitle
        : _titleCtrl.text.trim();
    final id = await svc.createDraftShellS0(title: title);
    setState(() => _draftDealId = id);
  }

  Future<void> _pickAndUpload({required String type}) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await _ensureShellDealForUpload();
      final dealId = _effectiveDealId!;
      final res = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg', 'heic', 'webp'],
      );
      if (res == null || res.files.isEmpty) return;

      final f = res.files.first;
      final Uint8List? bytes = f.bytes;
      final origName = f.name;
      if (bytes == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
        return;
      }

      setState(() {
        if (type == 'ok') {
          _uploadingOk = true;
        } else if (type == 'offer') {
          _uploadingOffer = true;
        } else {
          _uploadingPreview = true;
        }
      });

      final deals = DealsService(Supabase.instance.client);
      final path = await deals.uploadEvidence(
        dealId: dealId,
        kind: type, // 'ok' | 'offer' | 'preview'
        fileName: origName,
        bytes: bytes,
      );

      setState(() {
        if (type == 'ok') {
          _okFiles.add(path);
        } else if (type == 'offer') {
          _offerFiles.add(path);
        } else {
          _previewFiles.add(path);
        }
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.genericError)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _uploadingOk = false;
          _uploadingOffer = false;
          _uploadingPreview = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    _dismissKeyboard();

    final missing = _collectFormErrors(l10n);
    if (missing.isNotEmpty) {
      _scrollCtrl.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      final msg = '${l10n.genericPleaseFix}\n• ' + missing.join('\n• ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }

    setState(() => _submitting = true);
    final service = DealsService(Supabase.instance.client);

    try {
      final addr = _locationCtrl.text.trim();
      final coords = await GeocodingService().getCoordinates(addr);
      if (coords == null) {
        if (!mounted) return;
        setState(() => _submitting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errGeocodingFailed)));
        return;
      }
      final double lat = coords['lat']!, lng = coords['lng']!;

      final targetPriceCents = _eurToCents(_targetPriceCtrl.text.trim());
      final provisionValueNum = double.parse(
        _provisionValueCtrl.text.trim().replaceAll(',', '.'),
      );

      final String? phoneE164 = _normalizeE164(_customerPhoneCtrl.text.trim());
      final String? phoneLast4 = phoneE164 == null ? null : _last4(phoneE164);
      final String? customerName = _customerNameCtrl.text.trim().isEmpty
          ? null
          : _customerNameCtrl.text.trim();

      // Provision Type immer percent
      final provisionTypeString = ProvisionType.percent.name;

      if (_effectiveDealId != null) {
        final dealId = _effectiveDealId!;
        await service.updateDraftS0(
          dealId: dealId,
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          locationText: addr,
          startAfter: _startAfter!,
          deadline: _deadline!,
          targetPriceCents: targetPriceCents,
          provisionType: provisionTypeString,
          provisionValue: provisionValueNum,
          provisionDue: _provisionDue.name,
          locationLat: lat,
          locationLng: lng,
          category: _category!,
        );

        await service.upsertVerification(
          dealId: dealId,
          hasCustomerOk: _okFiles.isNotEmpty,
          customerOkUrls: _okFiles.isEmpty ? null : _okFiles,
          offerUrls: _offerFiles.isEmpty ? null : _offerFiles,
          customerName: customerName,
          customerPhoneE164: phoneE164,
          customerPhoneLast4: phoneLast4,
        );

        if (_publishNow) {
          await service.publishDeal(dealId, attested: _attested);
        }
      } else {
        final dealId = await service.createDealS0(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          locationText: addr,
          startAfter: _startAfter!,
          deadline: _deadline!,
          targetPriceCents: targetPriceCents,
          provisionType: provisionTypeString,
          provisionValue: provisionValueNum,
          provisionDue: _provisionDue.name,
          locationLat: lat,
          locationLng: lng,
          category: _category!,
        );
        _draftDealId = dealId;

        await service.upsertVerification(
          dealId: dealId,
          hasCustomerOk: _okFiles.isNotEmpty,
          customerOkUrls: _okFiles.isEmpty ? null : _okFiles,
          offerUrls: _offerFiles.isEmpty ? null : _offerFiles,
          customerName: customerName,
          customerPhoneE164: phoneE164,
          customerPhoneLast4: phoneLast4,
        );

        if (_publishNow) {
          await service.publishDeal(dealId, attested: _attested);
        }
      }

      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_hasExisting ? l10n.saved : l10n.draftSaved)),
      );
      Navigator.of(context).pop({'deal_id': _effectiveDealId, 'changed': true});
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);

      String nice = AppLocalizations.of(context)!.genericError;
      if (e is PostgrestException) {
        final m = (e.message ?? '').toLowerCase();
        if (m.contains('customer ok required')) {
          nice = l10n.errCustomerOkRequired;
        } else if (m.contains(
          'award provision requires at least one document',
        )) {
          nice = l10n.errAwardNeedsDoc;
        } else if (m.contains('not owner')) {
          nice = l10n.errNotOwner;
        } else if (m.contains('deal not draft') || m.contains('already live')) {
          nice = l10n.errPublishOnlyFromDraft;
        } else {
          nice = '${l10n.genericError}\nDetails: ${e.message}';
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(nice)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final roundedMenu = MenuStyle(
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maximumSize: const MaterialStatePropertyAll(Size.fromHeight(320)),
      padding: const MaterialStatePropertyAll(
        EdgeInsets.symmetric(vertical: 6),
      ),
    );
    final dropdownInputTheme = InputDecorationTheme(
      contentPadding: _inputPadding,
      border: _rounded,
      enabledBorder: _rounded,
      focusedBorder: _rounded,
    );

    String _dateLabel(DateTime? d, String fallback) =>
        d == null ? fallback : d.toLocal().toString().split(' ').first;
    String _fileLabel(String storagePath) {
      final parts = storagePath.split('/');
      return parts.isNotEmpty ? parts.last : storagePath;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_hasExisting ? l10n.s0EditTitle : l10n.s0Title),
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _dismissKeyboard,
          child: Form(
            key: _formKey,
            child: ListView(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              children: [
                // ======= Basics =======
                Text(
                  l10n.sectionBasics,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.fieldTitle,
                    hintText: l10n.hintTitleExample,
                    contentPadding: _inputPadding,
                    border: _rounded,
                    enabledBorder: _rounded,
                    focusedBorder: _rounded,
                  ),
                  validator: _required,
                  onFieldSubmitted: (_) => _dismissKeyboard(),
                  onTapOutside: (_) => _dismissKeyboard(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descCtrl,
                  textInputAction: TextInputAction.next,
                  minLines: 3,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: l10n.fieldDescription,
                    hintText: l10n.hintDescription,
                    contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    border: _rounded,
                    enabledBorder: _rounded,
                    focusedBorder: _rounded,
                  ),
                  validator: _required,
                  onFieldSubmitted: (_) => _dismissKeyboard(),
                  onTapOutside: (_) => _dismissKeyboard(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _category,
                  items: _categoriesL10n(context)
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  menuMaxHeight: 320,
                  borderRadius: BorderRadius.circular(12),
                  decoration: InputDecoration(
                    labelText: l10n.fieldCategory,
                    border: _rounded,
                    enabledBorder: _rounded,
                    focusedBorder: _rounded,
                    contentPadding: _inputPadding,
                  ),
                  onChanged: (v) => setState(() => _category = v),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.formErrorRequired : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.fieldLocation,
                    hintText: l10n.hintLocation,
                    contentPadding: _inputPadding,
                    border: _rounded,
                    enabledBorder: _rounded,
                    focusedBorder: _rounded,
                  ),
                  validator: _required,
                  onFieldSubmitted: (_) => _dismissKeyboard(),
                  onTapOutside: (_) => _dismissKeyboard(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: _fieldHeight,
                        child: OutlinedButton(
                          onPressed: () => _pickDate(isStart: true),
                          child: Text(
                            _dateLabel(_startAfter, l10n.pickStartDate),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: _fieldHeight,
                        child: OutlinedButton(
                          onPressed: () => _pickDate(isStart: false),
                          child: Text(_dateLabel(_deadline, l10n.pickDeadline)),
                        ),
                      ),
                    ),
                  ],
                ),

                // ======= Preis & Provision =======
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n.sectionS0PriceProvision,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 6),
                    Tooltip(
                      message: l10n.tooltipS0PriceProvision,
                      child: const Icon(Icons.info_outline, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _targetPriceCtrl,
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.fieldTargetPriceEur,
                    hintText: l10n.hintTargetPriceExample,
                    prefixText: '€ ',
                    helperText: l10n.helpTargetPrice,
                    contentPadding: _inputPadding,
                    border: _rounded,
                    enabledBorder: _rounded,
                    focusedBorder: _rounded,
                  ),
                  validator: _validateMoney,
                  onFieldSubmitted: (_) => _dismissKeyboard(),
                  onTapOutside: (_) => _dismissKeyboard(),
                ),
                const SizedBox(height: 12),

                // Nur noch Prozent-Provision
                SizedBox(
                  height: _fieldHeight,
                  child: TextFormField(
                    controller: _provisionValueCtrl,
                    textInputAction: TextInputAction.done,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.fieldProvisionValuePercent,
                      suffixText: '%',
                      contentPadding: _inputPadding,
                      border: _rounded,
                      enabledBorder: _rounded,
                      focusedBorder: _rounded,
                    ),
                    validator: _validateProvisionPercent,
                    onFieldSubmitted: (_) => _dismissKeyboard(),
                    onTapOutside: (_) => _dismissKeyboard(),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.helpProvisionPercent,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: _fieldHeight,
                  child: DropdownMenu<ProvisionDue>(
                    initialSelection: _provisionDue,
                    requestFocusOnTap: false,
                    inputDecorationTheme: dropdownInputTheme,
                    label: Text(l10n.fieldProvisionDue),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: ProvisionDue.award,
                        label: l10n.provisionDueAwardLabel,
                      ),
                      DropdownMenuEntry(
                        value: ProvisionDue.handover,
                        label: l10n.provisionDueHandoverLabel,
                      ),
                      DropdownMenuEntry(
                        value: ProvisionDue.finalInvoice,
                        label: l10n.provisionDueFinalInvoiceLabel,
                      ),
                    ],
                    onSelected: (v) =>
                        setState(() => _provisionDue = v ?? ProvisionDue.award),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _provisionDue == ProvisionDue.award
                        ? l10n.provisionDueAwardHelp
                        : _provisionDue == ProvisionDue.handover
                        ? l10n.provisionDueHandoverHelp
                        : l10n.provisionDueFinalInvoiceHelp,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),

                // ======= Evidence (Preview / OK / Angebot) =======
                const SizedBox(height: 24),
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PREVIEW
                      _headerWithAction(
                        title: l10n.sectionPreviewPublic,
                        tooltip: l10n.tooltipPreviewPublic,
                        action: FilledButton.tonalIcon(
                          onPressed: _uploadingPreview
                              ? null
                              : () => _pickAndUpload(type: 'preview'),
                          icon: _uploadingPreview
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.upload_file),
                          label: Text(l10n.btnUploadPreview),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.privacy_tip_outlined, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.previewRedactionNoticeTitle,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.previewRedactionNoticeBody,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_previewFiles.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: -6,
                          children: _previewFiles.asMap().entries.map((e) {
                            final path = e.value;
                            return Chip(
                              label: Text(_fileLabel(path)),
                              onDeleted: () =>
                                  setState(() => _previewFiles.removeAt(e.key)),
                            );
                          }).toList(),
                        ),
                      const Divider(height: 24),

                      // CUSTOMER OK
                      _headerWithAction(
                        title: l10n.sectionCustomerOk,
                        tooltip: l10n.helpCustomerOk,
                        action: FilledButton.icon(
                          onPressed: _uploadingOk
                              ? null
                              : () => _pickAndUpload(type: 'ok'),
                          icon: _uploadingOk
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.upload_file),
                          label: Text(l10n.btnUploadCustomerOk),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_okFiles.isEmpty)
                        Text(
                          l10n.errCustomerOkRequired,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (_okFiles.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: -6,
                          children: _okFiles.asMap().entries.map((e) {
                            final path = e.value;
                            return Chip(
                              label: Text(_fileLabel(path)),
                              onDeleted: () =>
                                  setState(() => _okFiles.removeAt(e.key)),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 16),

                      // ANGEBOT
                      _headerWithAction(
                        title: l10n.sectionOffer,
                        tooltip: l10n.helpOfferOptional,
                        action: FilledButton.tonalIcon(
                          onPressed: _uploadingOffer
                              ? null
                              : () => _pickAndUpload(type: 'offer'),
                          icon: _uploadingOffer
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.upload_file),
                          label: Text(l10n.btnUploadOffer),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_offerFiles.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: -6,
                          children: _offerFiles.asMap().entries.map((e) {
                            final path = e.value;
                            return Chip(
                              label: Text(_fileLabel(path)),
                              onDeleted: () =>
                                  setState(() => _offerFiles.removeAt(e.key)),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 16),

                      // Kundendaten (optional)
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _customerNameCtrl,
                              decoration: InputDecoration(
                                labelText: l10n.customerNameOptional,
                                contentPadding: _inputPadding,
                                border: _rounded,
                                enabledBorder: _rounded,
                                focusedBorder: _rounded,
                              ),
                              onTapOutside: (_) => _dismissKeyboard(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _customerPhoneCtrl,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: l10n.customerPhoneOptional,
                                hintText: l10n.hintPhoneExample,
                                contentPadding: _inputPadding,
                                border: _rounded,
                                enabledBorder: _rounded,
                                focusedBorder: _rounded,
                              ),
                              onTapOutside: (_) => _dismissKeyboard(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (!_publishNow &&
                    _okFiles.isEmpty &&
                    _offerFiles.isEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceVariant.withOpacity(0.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l10n.warnMissingDocsBody)),
                      ],
                    ),
                  ),
                ],

                // ======= Attest & Publish =======
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _attested,
                  onChanged: (v) => setState(() => _attested = v ?? false),
                  title: Text(l10n.attestLabel),
                  subtitle: Text(l10n.attestConsequences),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SwitchListTile(
                        title: Text(l10n.publishNow),
                        subtitle: Text(l10n.publishNowHint),
                        value: _publishNow,
                        onChanged: (v) => setState(() => _publishNow = v),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        final reqs = <String>[
                          l10n.infoReqCustomerOk,
                          if (_provisionDue == ProvisionDue.award)
                            l10n.infoReqDocForAward,
                          l10n.infoReqAttest,
                        ];
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.publishRequirementsTitle,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 12),
                                ...reqs.map(
                                  (r) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(r)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _submitting ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(
                    _submitting
                        ? l10n.btnSaving
                        : _hasExisting
                        ? l10n.btnSaveChanges
                        : l10n.btnCreateDraft,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.noteSupabaseActive,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- kleinere UI-Helfer ----
  Widget _sectionCard({required Widget child}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.35),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: child,
  );

  Widget _headerWithAction({
    required String title,
    required String tooltip,
    required Widget action,
  }) {
    return LayoutBuilder(
      builder: (context, c) {
        final isNarrow = c.maxWidth < 360;
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(width: 6),
                  Tooltip(
                    message: tooltip,
                    child: const Icon(Icons.info_outline, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerLeft, child: action),
            ],
          );
        }
        return Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 6),
            Tooltip(
              message: tooltip,
              child: const Icon(Icons.info_outline, size: 18),
            ),
            const Spacer(),
            action,
          ],
        );
      },
    );
  }
}
