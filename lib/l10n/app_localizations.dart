import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('tr')
  ];

  // ------ Hier alle Keys als Abstract Getter ------
  String get registerAppBar;
  String get registerTitle;
  String get roleLabel;
  String get roleKunde;
  String get roleDienstleister;
  String get categoryLabel;
  String get categoryValidator;
  String get emailLabel;
  String get emailEmpty;
  String get emailInvalid;
  String get passwordLabel;
  String get passwordEmpty;
  String get passwordTooShort;
  String get registerButton;
  String get registerSuccess;
  String get registerExists;
  String get registerInvalidEmail;
  String get registerPasswordShort;
  String registerFailed(Object error);
  String registerUnknownError(Object error);
  String get profileAppBar;
  String get profileAddressLabel;
  String get profileAddressEmpty;
  String get profileSaveButton;
  String get profileAddressSaved;
  String profileLoadError(Object error);
  String profileSaveError(Object error);
  String get notLoggedIn;
  String get pleaseLogin;
  String get changeNotAllowedTitle;
  String changeNotAllowedContent(Object date);
  String get ok;
  String get profileSaved;
  String get changeProfileImage;
  String get upgradeToPremium;
  String get noRatingsYet;
  String get nameLabel;
  String get nameValidator;
  String get descriptionLabel;
  String get addressLabel;
  String get phoneLabel;
  String get phoneValidator;
  String get emailEmptyValidator;
  String get emailInvalidValidator;
  String errorPrefix(Object error);
  String changeLimitHint(Object date);
  String get addressNotFound;
  String ratingsCount(Object count);
  String get premiumAppBar;
  String get premiumChoosePlan;
  String get premiumCurrentPlan;
  String get premiumFreePrice;
  String get premiumSilverPrice;
  String get premiumGoldPrice;
  String get premiumFreeFeature1;
  String get premiumFreeFeature2;
  String get premiumFreeFeature3;
  String get premiumFreeFeature4;
  String get premiumSilverFeature1;
  String get premiumSilverFeature2;
  String get premiumSilverFeature3;
  String get premiumGoldFeature1;
  String get premiumGoldFeature2;
  String get premiumGoldFeature3;
  String get premiumGoldFeature4;
  String premiumChooseButton(Object title);
  String get premiumPaymentNote;
  String get premiumSilverComingSoon;
  String get premiumGoldComingSoon;
  String get auftragHidden;
  String auftragHideError(Object error);
  String get meineAuftraegeAppBar;
  String get refreshTooltip;
  String get noAuftraegeFound;
  String get geplanterAuftrag;
  String get auftragAusblenden;
  String get loginFailedDetails;
  String get loginSuccess;
  String loginFailedPrefix(Object error);
  String loginUnknownError(Object error);
  String get emailValidatorEmpty;
  String get emailValidatorInvalid;
  String get passwordValidatorEmpty;
  String get passwordValidatorShort;
  String get loginKundeAppBar;
  String get loginKundeHeadline;
  String get loginButton;
  String get noAccountYet;
  String get loginFailedDetailsDL;
  String get wrongRoleDL;
  String get loginDLAppBar;
  String get loginDLHeadline;
  String get kundenDashboardHeader;
  String get kundenDashboardAppBar;
  String get laufendeAuftraege;
  String statusPrefix(Object status);
  String dienstleisterPrefix(Object dienstleister);
  String get offeneAuftraege;
  String get noOffeneAuftraege;
  String get abgeschlosseneAuftraege;
  String get abgeschlossenStatus;
  String get neuerAuftrag;
  String get pleaseCreateProfile;
  String get profilMissingCategory;
  String get dienstleisterDashboardHeader;
  String get dienstleisterDashboardAppBar;
  String get meineLaufendenAuftraege;
  String kundePrefix(Object kunde);
  String get offenePassendeAuftraege;
  String get noPassendeAuftraege;
  String entfernungSuffix(Object dist);
  String get auftragBereitsBewertet;
  String get bewertungDialogTitle;
  String get bewertungKommentarLabel;
  String get abbrechen;
  String get abschicken;
  String get auftragErstellenTitle;
  String get auftragEinstellenUeberschrift;
  String get titelLabel;
  String get titelValidator;
  String get beschreibungLabel;
  String get kategorieLabel;
  String get heimatadresseEinfuegen;
  String get adresseLabel;
  String get telefonnummerLabel;
  String get telefonnummerValidator;
  String get ausfuehrungszeitpunkt;
  String get soSchnellWieMoeglich;
  String get geplant;
  String get datumWaehlen;
  String get zeitVon;
  String get zeitBis;
  String get wiederkehrendCheckbox;
  String get intervallLabel;
  String get intervallValidator;
  String get wochentagLabel;
  String get wochentagValidator;
  String get anzahlWiederholungenLabel;
  String get wiederholenBisNichtGesetzt;
  String wiederholenBisLabel(Object date);
  String get auftragAbschicken;
  String get auftragGespeichert;
  String get bitteEinloggen;
  String get adresseNichtGefunden;
  String unbekannterFehler(Object error);
  String get auftragDetailTitle;
  String get nichtEingeloggt;
  String get rolleNichtErmittelt;
  String get auftragNichtGefunden;
  String get bewertungDanke;
  String get limitErreicht;
  String get limitFree;
  String get limitSilver;
  String get auftragAnnehmen;
  String get auftragBeenden;
  String get auftragEntfernenUebersicht;
  String get auftragEntfernen;
  String get auftragEntfernenTitel;
  String get auftragEntfernenText;
  String get entfernen;
  String get keineDatenVerfuegbar;
  String get beschreibung;
  String get kategorie;
  String get adresse;
  String get status;
  String jedenWochentag(Object wochentag);
  String bisDatum(Object datum);
  String get malSuffix;
  String kontaktZuLabel(Object label);
  String get nummerKopiert;
  String get nummerKopieren;
  String get anrufen;
  String fehlerPrefix(Object error);
  String get editProfileTooltip;
  String get appTitle;
  String get hello;
  String get kundeButton;
  String get dienstleisterButton;

  // --- Kategorien (Beispiel) ---
  String get category_babysitter;
  String get category_catering;
  String get category_dachdecker;
  String get category_elektriker;
  String get category_ernaehrungsberatung;
  String get category_eventplanung;
  String get category_fahrdienste;
  String get category_fahrlehrer;
  String get category_fensterputzer;
  String get category_fliesenleger;
  String get category_fotografie;
  String get category_friseur;
  String get category_gartenpflege;
  String get category_grafikdesign;
  String get category_handy_reparatur;
  String get category_haushaltsreinigung;
  String get category_hausmeisterservice;
  String get category_heizungsbauer;
  String get category_hundesitter;
  String get category_it_support;
  String get category_klempner;
  String get category_kosmetik;
  String get category_kuenstler;
  String get category_kurierdienst;
  String get category_maler;
  String get category_massagen;
  String get category_maurer;
  String get category_moebelaufbau;
  String get category_musikunterricht;
  String get category_nachhilfe;
  String get category_nagelstudio;
  String get category_pc_reparatur;
  String get category_partyservice;
  String get category_personal_trainer;
  String get category_rasenmaeher_service;
  String get category_rechtsberatung;
  String get category_reparaturdienste;
  String get category_seniorenbetreuung;
  String get category_social_media;
  String get category_sonstige;
  String get category_sprachunterricht;
  String get category_steuerberatung;
  String get category_tischler;
  String get category_transport;
  String get category_umzugstransporte;
  String get category_umzugshelfer;
  String get category_uebersetzungen;
  String get category_waescheservice;
  String get category_webdesign;
  String get category_einkaufsservice;
  String get category_haustierbetreuung;
  String get premiumBadgeLabel;
  String get statusOffen;
  String get statusInBearbeitung;
  String get statusAbgeschlossen;
}

// ---- Delegate-Klasse wie gehabt ----
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

// ----------- STATUS-EXTENSION für Multilanguage Status-Übersetzung -----------

extension StatusValueExtension on AppLocalizations {
  String statusValue(String status) {
    switch (status.toLowerCase()) {
      case 'offen':
      case 'open':
        return statusOffen;
      case 'in bearbeitung':
      case 'in progress':
        return statusInBearbeitung;
      case 'abgeschlossen':
      case 'completed':
        return statusAbgeschlossen;
      default:
        return status; // Fallback, falls unbekannter Status kommt
    }
  }
}
