import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../services/deals_service.dart';
import 'package:atyourservice/utils/geocoding_service.dart'; // ✅ Neu: Geocoding wie S0

enum S1PricingMode { fixed, tm }

enum S1DueType { award, date, handover, custom }

class HandelErstellenS1Screen extends StatefulWidget {
  const HandelErstellenS1Screen({super.key});
  @override
  State<HandelErstellenS1Screen> createState() =>
      _HandelErstellenS1ScreenState();
}

class _HandelErstellenS1ScreenState extends State<HandelErstellenS1Screen> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _deadline;

  late final OutlineInputBorder _rounded;
  final EdgeInsets _inputPadding = const EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 12,
  );

  String? _category;

  S1PricingMode _pricingMode = S1PricingMode.fixed;
  final _basePriceCtrl = TextEditingController();
  final _vatRateCtrl = TextEditingController();
  final _hourlyRateCtrl = TextEditingController();
  final _expectedHoursCtrl = TextEditingController();

  // Provision nur noch als Prozentwert
  final _provisionValueCtrl = TextEditingController();
  S1DueType _provisionDue = S1DueType.award;

  bool _attest = false;

  final List<String> _offerFiles = []; // Storage-Pfade
  final List<String> _previewFiles = []; // Storage-Pfade

  String? _dealId;
  late final DealsService _deals;

  @override
  void initState() {
    super.initState();
    _rounded = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1),
    );
    _deals = DealsService(Supabase.instance.client);
  }

  Future<void> _pickDate({
    required ValueChanged<DateTime?> onPicked,
    DateTime? initial,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      initialDate: initial ?? now,
    );
    onPicked(picked);
  }

  int _parseEuroToCents(String txt) {
    final t = txt.replaceAll(',', '.').trim();
    final v = double.tryParse(t);
    if (v == null) return 0;
    return (v * 100).round();
  }

  bool get _isFixed => _pricingMode == S1PricingMode.fixed;

  String? _requiredValidator(String? v) {
    final l10n = AppLocalizations.of(context)!;
    if (v == null || v.trim().isEmpty) return l10n.formErrorRequired;
    return null;
  }

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

  Future<void> _saveAll() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.genericPleaseFix)));
      return;
    }

    try {
      // 1) Draft sicherstellen (mit Basisfeldern, ohne strikte Koordinatenpflicht)
      _dealId ??= await _deals.createDraftShellS1(
        title: _titleCtrl.text.trim().isEmpty
            ? 'Entwurf'
            : _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        locationText: _locationCtrl.text.trim(),
        category: _category ?? '',
        startAfter: _startDate,
        deadline: _deadline,
      );

      // 2) Geocoding (✓ Wie in S0): Adresse → lat/lng
      final addr = _locationCtrl.text.trim();
      final coords = await GeocodingService().getCoordinates(addr);
      if (coords == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errGeocodingFailed)));
        return;
      }
      final double lat = coords['lat']!;
      final double lng = coords['lng']!;

      // 3) Basics inkl. Koordinaten aktualisieren (Deals → location_lat/lng)
      await _deals.updateS1Basics(
        dealId: _dealId!,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        locationText: addr,
        category: _category ?? '',
        startAfter: _startDate,
        deadline: _deadline,
        locationLat: lat,
        locationLng: lng,
      );

      // 4) Pricing speichern
      final pricingMode = _isFixed ? 'fixed' : 'tm';

      // Provision immer als Prozent
      final provisionType = 'percent';
      final provisionValue =
          double.tryParse(
            _provisionValueCtrl.text.replaceAll(',', '.').trim(),
          ) ??
          0.0;

      final due = switch (_provisionDue) {
        S1DueType.award => 'award',
        S1DueType.date => 'date',
        S1DueType.handover => 'handover',
        S1DueType.custom => 'custom',
      };

      int? basePriceCents;
      double? vatRate;
      int? hourlyRateCents;
      double? expectedHours;

      if (_isFixed) {
        basePriceCents = _parseEuroToCents(_basePriceCtrl.text);
        vatRate = double.tryParse(
          _vatRateCtrl.text.replaceAll(',', '.').trim(),
        );
      } else {
        hourlyRateCents = _parseEuroToCents(_hourlyRateCtrl.text);
        expectedHours = double.tryParse(
          _expectedHoursCtrl.text.replaceAll(',', '.').trim(),
        );
        vatRate = double.tryParse(
          _vatRateCtrl.text.replaceAll(',', '.').trim(),
        );
      }

      await _deals.updateS1Pricing(
        dealId: _dealId!,
        pricingMode: pricingMode,
        basePriceCents: basePriceCents,
        vatRate: vatRate,
        hourlyRateCents: hourlyRateCents,
        expectedHours: expectedHours,
        provisionType: provisionType,
        provisionValue: provisionValue,
        provisionDue: due,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.saved)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  Future<void> _publish() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_attest) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errAttestRequired)));
      return;
    }
    await _saveAll();
    if (_dealId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler: Kein Entwurf vorhanden')),
      );
      return;
    }
    await _deals.publishDeal(_dealId!, attested: _attest);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.publishSuccess)));
    Navigator.pop(context, {'changed': true});
  }

  Future<void> _pickAndUpload({
    required String kind, // 'preview' | 'offer'
    required void Function(String path) onDone,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      // Draft SICHERSTELLEN OHNE FORM-VALIDIERUNG:
      if (_dealId == null) {
        _dealId = await _deals.createDraftShellS1(
          title: _titleCtrl.text.trim().isEmpty
              ? 'Entwurf'
              : _titleCtrl.text.trim(),
        );
      }

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'heic', 'webp'],
      );
      if (result == null || result.files.isEmpty) return;

      final f = result.files.first;
      final Uint8List? bytes = f.bytes;
      final name = f.name;
      if (bytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datei konnte nicht geladen werden')),
        );
        return;
      }

      final path = await _deals.uploadEvidence(
        dealId: _dealId!,
        kind: kind,
        fileName: name,
        bytes: bytes,
      );

      if (kind == 'offer') {
        await _deals.upsertVerificationS1(dealId: _dealId!, offerUrls: [path]);
      }

      onDone(path);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.uploadSuccess)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload-Fehler: $e')));
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _basePriceCtrl.dispose();
    _vatRateCtrl.dispose();
    _hourlyRateCtrl.dispose();
    _expectedHoursCtrl.dispose();
    _provisionValueCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final kb = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(l10n.s1Title)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 14, 16, kb > 0 ? kb + 16 : 110),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Text(
                l10n.sectionBasics,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: l10n.fieldTitle,
                  hintText: l10n.hintTitleExample,
                  contentPadding: _inputPadding,
                  border: _rounded,
                  enabledBorder: _rounded,
                  focusedBorder: _rounded,
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
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
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                items: _categoriesL10n(context)
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                menuMaxHeight: 320,
                borderRadius: BorderRadius.circular(12),
                isDense: true,
                decoration: InputDecoration(
                  labelText: l10n.fieldCategory,
                  contentPadding: _inputPadding,
                  border: _rounded,
                  enabledBorder: _rounded,
                  focusedBorder: _rounded,
                ),
                onChanged: (v) => setState(() => _category = v),
                validator: (v) =>
                    (v == null || v.isEmpty) ? l10n.formErrorRequired : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationCtrl,
                decoration: InputDecoration(
                  labelText: l10n.fieldLocation,
                  hintText: l10n.hintLocation,
                  contentPadding: _inputPadding,
                  border: _rounded,
                  enabledBorder: _rounded,
                  focusedBorder: _rounded,
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DateTile(
                      label: l10n.labelStart,
                      value: _startDate,
                      onTap: () => _pickDate(
                        initial: _startDate,
                        onPicked: (d) => setState(() => _startDate = d),
                      ),
                      clear: () => setState(() => _startDate = null),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DateTile(
                      label: l10n.labelDeadline,
                      value: _deadline,
                      onTap: () => _pickDate(
                        initial: _deadline,
                        onPicked: (d) => setState(() => _deadline = d),
                      ),
                      clear: () => setState(() => _deadline = null),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                l10n.sectionS1Pricing,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              _InlineInfo(text: l10n.infoS1PricingHelp),
              const SizedBox(height: 8),
              SegmentedButton<S1PricingMode>(
                segments: [
                  ButtonSegment(
                    value: S1PricingMode.fixed,
                    label: Text(l10n.pricingModeFixed),
                    icon: const Icon(Icons.attach_money),
                  ),
                  ButtonSegment(
                    value: S1PricingMode.tm,
                    label: Text(l10n.pricingModeTm),
                    icon: const Icon(Icons.timer_outlined),
                  ),
                ],
                selected: {_pricingMode},
                onSelectionChanged: (s) =>
                    setState(() => _pricingMode = s.first),
              ),
              const SizedBox(height: 10),
              if (_isFixed) ...[
                TextFormField(
                  controller: _basePriceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.basePriceLabel,
                    contentPadding: _inputPadding,
                    border: _rounded,
                    enabledBorder: _rounded,
                    focusedBorder: _rounded,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _vatRateCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.defaultVatRateLabel,
                    contentPadding: _inputPadding,
                    border: _rounded,
                    enabledBorder: _rounded,
                    focusedBorder: _rounded,
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _hourlyRateCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.hourlyRateLabel,
                          contentPadding: _inputPadding,
                          border: _rounded,
                          enabledBorder: _rounded,
                          focusedBorder: _rounded,
                        ),
                        validator: _requiredValidator,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _expectedHoursCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.expectedHoursLabel,
                          contentPadding: _inputPadding,
                          border: _rounded,
                          enabledBorder: _rounded,
                          focusedBorder: _rounded,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _vatRateCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.defaultVatRateLabel,
                    contentPadding: _inputPadding,
                    border: _rounded,
                    enabledBorder: _rounded,
                    focusedBorder: _rounded,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Text(
                l10n.sectionS1Provision,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              _InlineInfo(text: l10n.infoS1ProvisionHelp),
              const SizedBox(height: 8),
              // Nur noch Prozent-Eingabe
              TextFormField(
                controller: _provisionValueCtrl,
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
              ),
              const SizedBox(height: 8),
              _DueTypePicker(
                label: l10n.fieldProvisionDue,
                value: _provisionDue,
                onChanged: (v) => setState(() => _provisionDue = v),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.sectionPreviewPublic,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.tooltipPreviewPublic,
                style: TextStyle(color: Colors.grey[700], fontSize: 12.5),
              ),
              const SizedBox(height: 8),
              _RedactionNotice(
                title: l10n.previewRedactionNoticeTitle,
                body: l10n.previewRedactionNoticeBody,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: () => _pickAndUpload(
                    kind: 'preview',
                    onDone: (p) => setState(() => _previewFiles.add(p)),
                  ),
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: Text(l10n.btnUploadPreview),
                ),
              ),
              if (_previewFiles.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: -6,
                  children: _previewFiles.asMap().entries.map((e) {
                    final path = e.value;
                    final file = path.split('/').isNotEmpty
                        ? path.split('/').last
                        : path;
                    return Chip(
                      label: Text(file),
                      onDeleted: () =>
                          setState(() => _previewFiles.removeAt(e.key)),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 18),
              Text(
                l10n.sectionOffer,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.helpOfferOptional,
                style: TextStyle(color: Colors.grey[700], fontSize: 12.5),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.tonalIcon(
                  onPressed: () => _pickAndUpload(
                    kind: 'offer',
                    onDone: (p) => setState(() => _offerFiles.add(p)),
                  ),
                  icon: const Icon(Icons.upload_file),
                  label: Text(l10n.btnUploadOffer),
                ),
              ),
              if (_offerFiles.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: -6,
                  children: _offerFiles.asMap().entries.map((e) {
                    final path = e.value;
                    final file = path.split('/').isNotEmpty
                        ? path.split('/').last
                        : path;
                    return Chip(
                      label: Text(file),
                      onDeleted: () =>
                          setState(() => _offerFiles.removeAt(e.key)),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 18),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _attest,
                onChanged: (v) => setState(() => _attest = v ?? false),
                title: Text(l10n.attestLabel),
                subtitle: Text(
                  l10n.attestConsequences,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: kb),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _saveAll,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(l10n.btnSaveChanges),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _publish,
                    icon: const Icon(Icons.rocket_launch_outlined),
                    label: Text(l10n.btnPublish),
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

// ---------- Helper Widgets ----------
class _InlineInfo extends StatelessWidget {
  final String text;
  const _InlineInfo({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback clear;
  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
    required this.clear,
  });
  @override
  Widget build(BuildContext context) {
    final has = value != null;
    final text = has
        ? '${value!.day.toString().padLeft(2, '0')}.${value!.month.toString().padLeft(2, '0')}.${value!.year}'
        : label;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.event, color: Colors.grey[700]),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: has ? Colors.black : Colors.grey[600],
                  fontWeight: has ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (has)
              IconButton(
                tooltip: 'Clear',
                onPressed: clear,
                icon: const Icon(Icons.close, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}

class _DueTypePicker extends StatelessWidget {
  final String label;
  final S1DueType value;
  final ValueChanged<S1DueType> onChanged;
  const _DueTypePicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: Wrap(
        spacing: 8,
        children: [
          ChoiceChip(
            label: Text(l10n.dueTypeAward),
            selected: value == S1DueType.award,
            onSelected: (_) => onChanged(S1DueType.award),
          ),
          ChoiceChip(
            label: Text(l10n.dueTypeDate),
            selected: value == S1DueType.date,
            onSelected: (_) => onChanged(S1DueType.date),
          ),
          ChoiceChip(
            label: Text(l10n.dueTypeHandover),
            selected: value == S1DueType.handover,
            onSelected: (_) => onChanged(S1DueType.handover),
          ),
          ChoiceChip(
            label: Text(l10n.dueTypeCustom),
            selected: value == S1DueType.custom,
            onSelected: (_) => onChanged(S1DueType.custom),
          ),
        ],
      ),
    );
  }
}

class _RedactionNotice extends StatelessWidget {
  final String title;
  final String body;
  const _RedactionNotice({required this.title, required this.body});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.35)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(fontSize: 12.5, height: 1.25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
