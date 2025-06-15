import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import '../utils/entfernung_utils.dart';
import 'auftrag_detail_screen.dart';
import 'profil_dienstleister_screen.dart';
import '../l10n/app_localizations.dart';

class DienstleisterDashboardScreen extends StatefulWidget {
  const DienstleisterDashboardScreen({Key? key}) : super(key: key);

  @override
  _DienstleisterDashboardScreenState createState() => _DienstleisterDashboardScreenState();
}

class _DienstleisterDashboardScreenState extends State<DienstleisterDashboardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  bool _isLoading = true;
  String? _errorMessage;

  String? _meineKategorie;
  double? _meineLatitude;
  double? _meineLongitude;
  String? _aboTyp;

  List<Map<String, dynamic>> _alleOffenenAuftraegeRaw = [];
  List<Map<String, dynamic>> _alleLaufendenAuftraegeRaw = [];
  List<Auftrag> _offenePassendeAuftraege = [];
  List<Map<String, dynamic>> _laufendeAuftraegeMitUser = [];

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ladeProfilUndAuftraege();
    });
  }

  Future<void> _ladeProfilUndAuftraege() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _alleOffenenAuftraegeRaw = [];
      _alleLaufendenAuftraegeRaw = [];
      _offenePassendeAuftraege = [];
      _laufendeAuftraegeMitUser = [];
    });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception(l10n.notLoggedIn);

      // 1) Profil abrufen (kategorie, latitude, longitude)
      final List<dynamic> profilList = await supabase
          .from('dienstleister_details')
          .select('kategorie, latitude, longitude')
          .eq('user_id', user.id);

      if (profilList.isEmpty) throw Exception(l10n.pleaseCreateProfile);

      final profilData = profilList.first as Map<String, dynamic>;
      final String? kategorie = profilData['kategorie'] as String?;
      final double? latitude = (profilData['latitude'] as num?)?.toDouble();
      final double? longitude = (profilData['longitude'] as num?)?.toDouble();

      if (kategorie == null) throw Exception(l10n.profilMissingCategory);

      _meineKategorie = kategorie;
      _meineLatitude = latitude;
      _meineLongitude = longitude;

      // 1b) Abo-Typ aus users-Tabelle holen
      final userData = await supabase
          .from('users')
          .select('abo_typ')
          .eq('id', user.id)
          .maybeSingle();
      _aboTyp = userData?['abo_typ'] as String? ?? 'free';

      // 2) Alle offenen Aufträge derselben Kategorie laden
      final List<dynamic> rawOffen = await supabase
          .from('auftraege')
          .select()
          .eq('kategorie', kategorie)
          .eq('status', 'offen');
      _alleOffenenAuftraegeRaw = rawOffen.cast<Map<String, dynamic>>();

      // 3) Laufende (in bearbeitung) Aufträge dieses Dienstleisters (mit Kunden-Email)
      final List<dynamic> rawLaufend = await supabase
          .from('auftraege')
          .select('*, kunde:users!auftraege_kunde_id_fkey(email)')
          .eq('status', 'in bearbeitung')
          .eq('dienstleister_id', user.id);
      _alleLaufendenAuftraegeRaw = rawLaufend.cast<Map<String, dynamic>>();
      _laufendeAuftraegeMitUser = _alleLaufendenAuftraegeRaw;

      // Radius nach Abo-Typ bestimmen
      double radiusKm = 5.0;
      if (_aboTyp == 'silver') {
        radiusKm = 15.0;
      } else if (_aboTyp == 'gold') {
        radiusKm = 40.0;
      }

      // Offene Aufträge, nur im passenden Radius!
      if (_meineLatitude != null && _meineLongitude != null) {
        _offenePassendeAuftraege = _alleOffenenAuftraegeRaw
            .map((map) => Auftrag.fromJson(map))
            .where((auftrag) {
          if (auftrag.latitude == null || auftrag.longitude == null) return false;
          final dist = berechneEntfernung(
            _meineLatitude!, _meineLongitude!,
            auftrag.latitude!, auftrag.longitude!,
          );
          return dist <= radiusKm;
        }).toList();
      } else {
        _offenePassendeAuftraege =
            _alleOffenenAuftraegeRaw.map((map) => Auftrag.fromJson(map)).toList();
      }

      setState(() => _isLoading = false);
    } on PostgrestException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _dashboardHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 2),
      child: Row(
        children: [
          Icon(Icons.handyman, color: primaryColor, size: 28),
          const SizedBox(width: 10),
          Text(
            l10n.dienstleisterDashboardHeader,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: primaryColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(
          l10n.dienstleisterDashboardAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refreshTooltip,
            onPressed: _ladeProfilUndAuftraege,
            color: primaryColor,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: l10n.editProfileTooltip,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilDienstleisterScreen()),
              );
              _ladeProfilUndAuftraege();
            },
            color: primaryColor,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(l10n.errorPrefix(_errorMessage!)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dashboardHeader(),
                      if (_laufendeAuftraegeMitUser.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.meineLaufendenAuftraege,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 7),
                        SizedBox(
                          height: 155,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _laufendeAuftraegeMitUser.length,
                            separatorBuilder: (context, i) => const SizedBox(width: 13),
                            itemBuilder: (context, index) {
                              final map = _laufendeAuftraegeMitUser[index];
                              final auftrag = Auftrag.fromJson(map);
                              final kunde = map['kunde'];
                              final kundenEmail = kunde?['email'] ?? 'Kunde';

                              return Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
                                      ),
                                    ).then((_) => _ladeProfilUndAuftraege());
                                  },
                                  child: Container(
                                    width: 240,
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                auftrag.titel,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (!auftrag.soSchnellWieMoeglich)
                                              Tooltip(
                                                message: l10n.geplanterAuftrag,
                                                child: Icon(Icons.access_time_rounded, color: Colors.teal[700], size: 20),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Icon(Icons.assignment, size: 17, color: primaryColor),
                                            const SizedBox(width: 5),
                                            Text(
                                              l10n.statusPrefix(l10n.statusValue(auftrag.status)),
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          l10n.kundePrefix(kundenEmail),
                                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(height: 32, thickness: 1.2),
                      ],
                      Text(
                        l10n.offenePassendeAuftraege,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 7),
                      Expanded(
                        child: _offenePassendeAuftraege.isEmpty
                            ? Center(
                                child: Text(
                                  l10n.noPassendeAuftraege,
                                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                                ),
                              )
                            : ListView.separated(
                                itemCount: _offenePassendeAuftraege.length,
                                separatorBuilder: (context, i) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final Auftrag auftrag = _offenePassendeAuftraege[index];

                                  String distText = '';
                                  if (_meineLatitude != null &&
                                      _meineLongitude != null &&
                                      auftrag.latitude != null &&
                                      auftrag.longitude != null) {
                                    final double dist = berechneEntfernung(
                                      _meineLatitude!,
                                      _meineLongitude!,
                                      auftrag.latitude!,
                                      auftrag.longitude!,
                                    );
                                    distText = l10n.entfernungSuffix(dist.toStringAsFixed(1));
                                  }

                                  return Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    elevation: 2,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                      leading: Icon(Icons.assignment_outlined, color: primaryColor, size: 30),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              auftrag.titel,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (!auftrag.soSchnellWieMoeglich)
                                            Tooltip(
                                              message: l10n.geplanterAuftrag,
                                              child: Icon(Icons.access_time_rounded, color: Colors.teal[700], size: 20),
                                            ),
                                        ],
                                      ),
                                      subtitle: distText.isNotEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: 3.0),
                                              child: Text(distText, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                                            )
                                          : null,
                                      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
                                          ),
                                        ).then((_) => _ladeProfilUndAuftraege());
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
