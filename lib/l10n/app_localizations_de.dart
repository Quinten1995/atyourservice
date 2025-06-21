// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get registerAppBar => 'Registrierung';

  @override
  String get registerTitle => 'Registrieren';

  @override
  String get roleLabel => 'Rolle auswählen';

  @override
  String get roleKunde => 'Kunde';

  @override
  String get roleDienstleister => 'Dienstleister';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get categoryValidator => 'Bitte Kategorie auswählen';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get emailEmpty => 'Bitte E-Mail eingeben';

  @override
  String get emailInvalid => 'Bitte gültige E-Mail eingeben';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get passwordEmpty => 'Bitte Passwort eingeben';

  @override
  String get passwordTooShort => 'Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get registerButton => 'Registrieren';

  @override
  String get registerSuccess => 'Registrierung erfolgreich! Bitte bestätige deine E-Mail.';

  @override
  String get registerExists => 'Diese E-Mail ist bereits registriert. Bitte einloggen oder Passwort zurücksetzen.';

  @override
  String get registerInvalidEmail => 'Bitte eine gültige E-Mail-Adresse eingeben.';

  @override
  String get registerPasswordShort => 'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String registerFailed(Object error) {
    return 'Registrierung fehlgeschlagen: $error';
  }

  @override
  String registerUnknownError(Object error) {
    return 'Unbekannter Fehler: $error';
  }

  @override
  String get profileAppBar => 'Dienstleisterprofil';

  @override
  String get profileAddressLabel => 'Heimatadresse (z.B. Beispielstraße 12, 12345 Beispielstadt)';

  @override
  String get profileAddressEmpty => 'Bitte Adresse eingeben';

  @override
  String get profileSaveButton => 'Profil speichern';

  @override
  String get profileAddressSaved => 'Adresse gespeichert!';

  @override
  String profileLoadError(Object error) {
    return 'Fehler beim Laden: $error';
  }

  @override
  String profileSaveError(Object error) {
    return 'Fehler beim Speichern: $error';
  }

  @override
  String get notLoggedIn => 'Nicht eingeloggt';

  @override
  String get pleaseLogin => 'Bitte zuerst einloggen';

  @override
  String get changeNotAllowedTitle => 'Änderung nicht erlaubt';

  @override
  String changeNotAllowedContent(Object date) {
    return 'Als kostenloser Nutzer kannst du Kategorie oder Adresse nur alle 20 Tage ändern.\nNächste Änderung möglich ab: $date';
  }

  @override
  String get ok => 'OK';

  @override
  String get profileSaved => 'Profil erfolgreich gespeichert!';

  @override
  String get changeProfileImage => 'Profilbild ändern';

  @override
  String get upgradeToPremium => 'Zu Premium wechseln';

  @override
  String get noRatingsYet => 'Noch keine Bewertungen';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameValidator => 'Bitte Name eingeben';

  @override
  String get descriptionLabel => 'Beschreibung';

  @override
  String get addressLabel => 'Adresse (z.B. Straße, PLZ, Stadt)';

  @override
  String get phoneLabel => 'Telefon';

  @override
  String get phoneValidator => 'Bitte Telefonnummer eingeben';

  @override
  String get emailEmptyValidator => 'Bitte E-Mail eingeben';

  @override
  String get emailInvalidValidator => 'Bitte gültige E-Mail eingeben';

  @override
  String errorPrefix(Object error) {
    return 'Fehler: $error';
  }

  @override
  String changeLimitHint(Object date) {
    return 'Kategorie/Adresse kann erst ab dem $date geändert werden.';
  }

  @override
  String get addressNotFound => 'Adresse nicht gefunden. Bitte prüfen.';

  @override
  String ratingsCount(Object count) {
    return '($count Bewertungen)';
  }

  @override
  String get premiumAppBar => 'Zu Premium wechseln';

  @override
  String get premiumChoosePlan => 'Wähle deinen Premium-Plan';

  @override
  String get premiumCurrentPlan => 'Aktuelles Abo:';

  @override
  String get premiumFreePrice => 'kostenlos';

  @override
  String get premiumSilverPrice => '€4.99 / month';

  @override
  String get premiumGoldPrice => '€9.99 / month';

  @override
  String get premiumFreeFeature1 => '1 Auftrag pro Woche annehmen';

  @override
  String get premiumFreeFeature2 => 'Aufträge im Umkreis von 5 km';

  @override
  String get premiumFreeFeature3 => 'Nur Basis-Kategorien';

  @override
  String get premiumFreeFeature4 => 'Kategorie-Wechsel nur alle 20 Tage';

  @override
  String get premiumSilverFeature1 => 'Unbegrenzte Aufträge annehmen';

  @override
  String get premiumSilverFeature2 => 'Aufträge im Umkreis von 15 km';

  @override
  String get premiumSilverFeature3 => 'Alle Kategorien verfügbar';

  @override
  String get premiumGoldFeature1 => 'Unbegrenzte Aufträge annehmen';

  @override
  String get premiumGoldFeature2 => 'Aufträge im Umkreis von 40 km';

  @override
  String get premiumGoldFeature3 => 'Alle Kategorien verfügbar';

  @override
  String get premiumGoldFeature4 => 'Premium User Badge (sichtbar für Kunden)';

  @override
  String premiumChooseButton(Object title) {
    return '$title wählen';
  }

  @override
  String get premiumPaymentNote => 'Hinweis: Alle Zahlungen erfolgen sicher über Apple oder Google. Du kannst dein Abo jederzeit im Store kündigen oder verwalten.';

  @override
  String get premiumSilverComingSoon => 'Silver bald verfügbar!';

  @override
  String get premiumGoldComingSoon => 'Gold bald verfügbar!';

  @override
  String get auftragHidden => 'Auftrag ausgeblendet.';

  @override
  String auftragHideError(Object error) {
    return 'Fehler beim Ausblenden: $error';
  }

  @override
  String get meineAuftraegeAppBar => 'Meine Aufträge';

  @override
  String get refreshTooltip => 'Aktualisieren';

  @override
  String get noAuftraegeFound => 'Keine Aufträge gefunden.';

  @override
  String get geplanterAuftrag => 'Geplanter Auftrag';

  @override
  String get auftragAusblenden => 'Auftrag ausblenden';

  @override
  String get loginFailedDetails => 'Login fehlgeschlagen. Bitte überprüfe deine Daten oder bestätige deine E-Mail.';

  @override
  String get loginSuccess => 'Login erfolgreich!';

  @override
  String loginFailedPrefix(Object error) {
    return 'Login fehlgeschlagen: $error';
  }

  @override
  String loginUnknownError(Object error) {
    return 'Unbekannter Fehler: $error';
  }

  @override
  String get emailValidatorEmpty => 'Bitte E-Mail eingeben';

  @override
  String get emailValidatorInvalid => 'Bitte gültige E-Mail eingeben';

  @override
  String get passwordValidatorEmpty => 'Bitte Passwort eingeben';

  @override
  String get passwordValidatorShort => 'Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get loginKundeAppBar => 'Login für Kunden';

  @override
  String get loginKundeHeadline => 'Anmelden';

  @override
  String get loginButton => 'Login';

  @override
  String get noAccountYet => 'Noch kein Konto? Jetzt registrieren';

  @override
  String get loginFailedDetailsDL => 'Login fehlgeschlagen. Bitte überprüfe deine Daten oder bestätige deine E-Mail.';

  @override
  String get wrongRoleDL => 'Dieser Account ist kein Dienstleister. Bitte nutze den Kunden-Login.';

  @override
  String get loginDLAppBar => 'Login für Dienstleister';

  @override
  String get loginDLHeadline => 'Anmelden';

  @override
  String get kundenDashboardHeader => 'Dein Dashboard';

  @override
  String get kundenDashboardAppBar => 'Kunden-Dashboard';

  @override
  String get laufendeAuftraege => 'Laufende Aufträge';

  @override
  String statusPrefix(Object status) {
    return 'Status: $status';
  }

  @override
  String dienstleisterPrefix(Object dienstleister) {
    return 'Dienstleister: $dienstleister';
  }

  @override
  String get offeneAuftraege => 'Offene Aufträge';

  @override
  String get noOffeneAuftraege => 'Keine offenen Aufträge gefunden.';

  @override
  String get abgeschlosseneAuftraege => 'Abgeschlossene Aufträge';

  @override
  String get abgeschlossenStatus => 'Abgeschlossen';

  @override
  String get neuerAuftrag => 'Neuer Auftrag';

  @override
  String get pleaseCreateProfile => 'Bitte zunächst dein Profil anlegen.';

  @override
  String get profilMissingCategory => 'Kategorie im Profil fehlt.';

  @override
  String get dienstleisterDashboardHeader => 'Dein Dashboard';

  @override
  String get dienstleisterDashboardAppBar => 'Dashboard Dienstleister';

  @override
  String get meineLaufendenAuftraege => 'Meine laufenden Aufträge';

  @override
  String kundePrefix(Object kunde) {
    return 'Kunde: $kunde';
  }

  @override
  String get offenePassendeAuftraege => 'Offene, passende Aufträge';

  @override
  String get noPassendeAuftraege => 'Keine passenden Aufträge gefunden.';

  @override
  String entfernungSuffix(Object dist) {
    return '$dist km entfernt';
  }

  @override
  String get auftragBereitsBewertet => 'Du hast diesen Auftrag bereits bewertet.';

  @override
  String get bewertungDialogTitle => 'Dienstleister bewerten';

  @override
  String get bewertungKommentarLabel => 'Kommentar (optional)';

  @override
  String get abbrechen => 'Abbrechen';

  @override
  String get abschicken => 'Abschicken';

  @override
  String get auftragErstellenTitle => 'Neuen Auftrag erstellen';

  @override
  String get auftragEinstellenUeberschrift => 'Jetzt Auftrag einstellen';

  @override
  String get titelLabel => 'Titel';

  @override
  String get titelValidator => 'Bitte Titel eingeben';

  @override
  String get beschreibungLabel => 'Beschreibung';

  @override
  String get kategorieLabel => 'Kategorie';

  @override
  String get heimatadresseEinfuegen => 'Heimatadresse einfügen';

  @override
  String get adresseLabel => 'Adresse (z. B. Alter Markt 76, 50667 Köln)';

  @override
  String get telefonnummerLabel => 'Telefonnummer';

  @override
  String get telefonnummerValidator => 'Bitte Telefonnummer eingeben';

  @override
  String get ausfuehrungszeitpunkt => 'Ausführungszeitpunkt';

  @override
  String get soSchnellWieMoeglich => 'So schnell wie möglich';

  @override
  String get geplant => 'Geplant';

  @override
  String get datumWaehlen => 'Datum wählen';

  @override
  String get zeitVon => 'Zeit von';

  @override
  String get zeitBis => 'Zeit bis';

  @override
  String get wiederkehrendCheckbox => 'Wiederkehrender Auftrag?';

  @override
  String get intervallLabel => 'Intervall';

  @override
  String get intervallValidator => 'Bitte Intervall wählen';

  @override
  String get wochentagLabel => 'Wochentag';

  @override
  String get wochentagValidator => 'Bitte Wochentag wählen';

  @override
  String get anzahlWiederholungenLabel => 'Anzahl Wiederholungen (optional)';

  @override
  String get wiederholenBisNichtGesetzt => 'Wiederholen bis: nicht gesetzt';

  @override
  String wiederholenBisLabel(Object date) {
    return 'Wiederholen bis: $date';
  }

  @override
  String get auftragAbschicken => 'Auftrag abschicken';

  @override
  String get auftragGespeichert => 'Auftrag wurde gespeichert!';

  @override
  String get bitteEinloggen => 'Bitte zuerst einloggen';

  @override
  String get adresseNichtGefunden => 'Adresse nicht gefunden.';

  @override
  String unbekannterFehler(Object error) {
    return 'Unbekannter Fehler: $error';
  }

  @override
  String get auftragDetailTitle => 'Auftragsdetails';

  @override
  String get nichtEingeloggt => 'Nicht eingeloggt';

  @override
  String get rolleNichtErmittelt => 'Rolle konnte nicht ermittelt werden';

  @override
  String get auftragNichtGefunden => 'Auftrag nicht gefunden';

  @override
  String get bewertungDanke => 'Danke für deine Bewertung!';

  @override
  String get limitErreicht => 'Limit erreicht';

  @override
  String get limitFree => 'Als Freemium-Dienstleister kannst du pro Woche maximal 2 Aufträge annehmen. Upgrade auf Silver oder Gold für mehr Möglichkeiten!';

  @override
  String get limitSilver => 'Als Silver-Dienstleister kannst du pro Woche maximal 5 Aufträge annehmen. Upgrade auf Gold für unbegrenzte Aufträge!';

  @override
  String get auftragAnnehmen => 'Auftrag annehmen';

  @override
  String get auftragBeenden => 'Auftrag beenden';

  @override
  String get auftragEntfernenUebersicht => 'Auftrag aus Übersicht entfernen';

  @override
  String get auftragEntfernen => 'Auftrag entfernen';

  @override
  String get auftragEntfernenTitel => 'Auftrag entfernen?';

  @override
  String get auftragEntfernenText => 'Möchtest du diesen Auftrag aus deiner Übersicht entfernen?';

  @override
  String get entfernen => 'Entfernen';

  @override
  String get keineDatenVerfuegbar => 'Keine Daten verfügbar';

  @override
  String get beschreibung => 'Beschreibung:';

  @override
  String get kategorie => 'Kategorie:';

  @override
  String get adresse => 'Adresse:';

  @override
  String get status => 'Status:';

  @override
  String jedenWochentag(Object wochentag) {
    return 'Jeden $wochentag';
  }

  @override
  String bisDatum(Object datum) {
    return 'bis $datum';
  }

  @override
  String get malSuffix => 'mal';

  @override
  String kontaktZuLabel(Object label) {
    return 'Kontakt zu $label:';
  }

  @override
  String get nummerKopiert => 'Nummer kopiert!';

  @override
  String get nummerKopieren => 'Nummer kopieren';

  @override
  String get anrufen => 'Anrufen';

  @override
  String fehlerPrefix(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get editProfileTooltip => 'Profil bearbeiten';

  @override
  String get appTitle => 'AtYourService';

  @override
  String get hello => 'Willkommen!';

  @override
  String get kundeButton => 'Ich suche einen Dienstleister';

  @override
  String get dienstleisterButton => 'Ich bin Dienstleister';

  @override
  String get category_babysitter => 'Babysitter / Kinderbetreuung';

  @override
  String get category_catering => 'Catering';

  @override
  String get category_dachdecker => 'Dachdecker';

  @override
  String get category_elektriker => 'Elektriker';

  @override
  String get category_ernaehrungsberatung => 'Ernährungsberatung';

  @override
  String get category_eventplanung => 'Eventplanung';

  @override
  String get category_fahrdienste => 'Fahrdienste';

  @override
  String get category_fahrlehrer => 'Fahrlehrer/in';

  @override
  String get category_fensterputzer => 'Fensterputzer';

  @override
  String get category_fliesenleger => 'Fliesenleger';

  @override
  String get category_fotografie => 'Fotografie / Videografie';

  @override
  String get category_friseur => 'Friseur/in';

  @override
  String get category_gartenpflege => 'Gartenpflege / Rasenmähen';

  @override
  String get category_grafikdesign => 'Grafikdesign';

  @override
  String get category_handy_reparatur => 'Handy/Tablet-Reparatur';

  @override
  String get category_haushaltsreinigung => 'Haushaltsreinigung';

  @override
  String get category_hausmeisterservice => 'Hausmeisterservice';

  @override
  String get category_heizungsbauer => 'Heizungsbauer';

  @override
  String get category_hundesitter => 'Hundesitter / Gassi-Service';

  @override
  String get category_it_support => 'IT-Support';

  @override
  String get category_klempner => 'Klempner';

  @override
  String get category_kosmetik => 'Kosmetiker/in';

  @override
  String get category_kuenstler => 'Künstler (z.B. Musiker für Events)';

  @override
  String get category_kurierdienst => 'Kurierdienst';

  @override
  String get category_maler => 'Maler';

  @override
  String get category_massagen => 'Massagen';

  @override
  String get category_maurer => 'Maurer';

  @override
  String get category_moebelaufbau => 'Möbelaufbau / -montage';

  @override
  String get category_musikunterricht => 'Musikunterricht';

  @override
  String get category_nachhilfe => 'Nachhilfe';

  @override
  String get category_nagelstudio => 'Nagelstudio';

  @override
  String get category_pc_reparatur => 'PC-/Laptop-Reparatur';

  @override
  String get category_partyservice => 'Partyservice';

  @override
  String get category_personal_trainer => 'Personal Trainer';

  @override
  String get category_rasenmaeher_service => 'Rasenmäher-Service';

  @override
  String get category_rechtsberatung => 'Rechtsberatung';

  @override
  String get category_reparaturdienste => 'Reparaturdienste';

  @override
  String get category_seniorenbetreuung => 'Seniorenbetreuung';

  @override
  String get category_social_media => 'Social Media Betreuung';

  @override
  String get category_sonstige => 'Sonstige Dienstleistungen';

  @override
  String get category_sprachunterricht => 'Sprachunterricht';

  @override
  String get category_steuerberatung => 'Steuerberatung';

  @override
  String get category_tischler => 'Tischler/Schreiner';

  @override
  String get category_transport => 'Transport & Mobilität';

  @override
  String get category_umzugstransporte => 'Umzugstransporte';

  @override
  String get category_umzugshelfer => 'Umzugshelfer';

  @override
  String get category_uebersetzungen => 'Übersetzungen';

  @override
  String get category_waescheservice => 'Wäscheservice';

  @override
  String get category_webdesign => 'Webdesign';

  @override
  String get category_einkaufsservice => 'Einkaufsservice';

  @override
  String get category_haustierbetreuung => 'Haustierbetreuung';

  @override
  String get premiumBadgeLabel => 'Premium';

  @override
  String get statusOffen => 'Offen';

  @override
  String get statusInBearbeitung => 'In Bearbeitung';

  @override
  String get statusAbgeschlossen => 'Abgeschlossen';

  @override
  String get privacyButton => 'Datenschutz';

  @override
  String get interval_weekly => 'Wöchentlich';

  @override
  String get interval_biweekly => 'Alle 2 Wochen';

  @override
  String get interval_monthly => 'Monatlich';

  @override
  String get weekday_monday => 'Montag';

  @override
  String get weekday_tuesday => 'Dienstag';

  @override
  String get weekday_wednesday => 'Mittwoch';

  @override
  String get weekday_thursday => 'Donnerstag';

  @override
  String get weekday_friday => 'Freitag';

  @override
  String get weekday_saturday => 'Samstag';

  @override
  String get weekday_sunday => 'Sonntag';

  @override
  String get kundenInfoBanner => 'Sie sind als Kunde angemeldet. Bitte beschreiben Sie hier, welche Dienstleistung Sie benötigen. Dienstleister werden Ihnen daraufhin Angebote machen.';

  @override
  String get titelHint => 'z. B. Wohnung reinigen lassen';

  @override
  String get beschreibungHint => 'Beschreiben Sie, was gemacht werden soll – z. B. 3 Zimmer, Küche, Bad reinigen ...';
}
