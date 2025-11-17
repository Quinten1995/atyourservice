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
  String get passwordTooShort => 'Das Passwort muss mindestens 8 Zeichen lang sein.';

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
  String get descriptionLabel => 'Leistungsbeschreibung:';

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
  String get premiumSilverFeature1 => '2 Aufträge pro Woche annehmen';

  @override
  String get premiumSilverFeature2 => 'Aufträge im Umkreis von 15 km';

  @override
  String get premiumSilverFeature3 => 'Alle Kategorien verfügbar';

  @override
  String get premiumGoldFeature1 => '5 Aufträge pro Woche annehmen';

  @override
  String get premiumGoldFeature2 => 'Aufträge im Umkreis von 30 km';

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
  String get category_gartenpflege => 'Gartenpflege / GaLa-Bau';

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

  @override
  String get invoiceSectionTitle => 'Rechnungsdaten (nur für Gold)';

  @override
  String get invoiceNameLabel => 'Rechnungsname (z.B. Firmenname)';

  @override
  String get invoiceAddressLabel => 'Rechnungsadresse:';

  @override
  String get invoiceTaxNumberLabel => 'Steuernummer (optional)';

  @override
  String get invoiceIbanLabel => 'IBAN (optional)';

  @override
  String get invoiceLogoUrlLabel => 'Logo-URL (optional)';

  @override
  String get invoiceGoldInfo => 'Rechnungsdaten sind im GOLD-Abo bearbeitbar.';

  @override
  String get rechnungGenerierenButtonLabel => 'Rechnung generieren';

  @override
  String get meineAbgeschlossenenAuftraege => 'Meine abgeschlossenen Aufträge';

  @override
  String get verbergenButtonLabel => 'Verbergen';

  @override
  String get rechnungGenerierenAppBar => 'Rechnung generieren';

  @override
  String get rechnungAlsPdfAnzeigenLabel => 'Rechnung als PDF anzeigen';

  @override
  String get invoiceLabel => 'Rechnung';

  @override
  String get fromLabel => 'Von:';

  @override
  String get taxNumberLabel => 'Steuernummer:';

  @override
  String get ibanLabel => 'IBAN:';

  @override
  String get toLabel => 'Für:';

  @override
  String get amountLabel => 'Betrag:';

  @override
  String get dateLabel => 'Datum:';

  @override
  String get generatedByText => 'Diese Rechnung wurde automatisch über AtYourService generiert.';

  @override
  String get currencyLabel => 'Währung';

  @override
  String get amountRequired => 'Bitte einen gültigen Betrag eingeben.';

  @override
  String get premiumGoldInvoiceFeature => 'Rechnungsstellung als PDF';

  @override
  String get onlyForGoldTooltip => 'Diese Funktion ist nur für Gold-Abonnenten verfügbar.';

  @override
  String get deleteJobTooltip => 'Auftrag von der Liste entfernen';

  @override
  String get invoiceNumberLabel => 'Rechnungsnummer';

  @override
  String get invoiceProfileHint => 'Bitte trage deine Rechnungsdaten im Profil ein. Diese werden automatisch in die PDF-Rechnung übernommen.';

  @override
  String get auftragErneutPosten => 'Auftrag erneut posten';

  @override
  String get auftragErneutPostenTitle => 'Auftrag erneut veröffentlichen?';

  @override
  String get auftragErneutPostenText => 'Der aktuelle Dienstleister wird entfernt. Der Auftrag ist wieder für andere sichtbar. Möchtest du fortfahren?';

  @override
  String get auftragErneutGepostet => 'Der Auftrag wurde erneut veröffentlicht.';

  @override
  String get premiumActivated => 'Abo erfolgreich aktiviert!';

  @override
  String premiumPurchaseFailed(Object error) {
    return 'Fehler beim Kauf: $error';
  }

  @override
  String get premiumProductNotFound => 'Produkt nicht gefunden!';

  @override
  String get premiumStoreNotLoaded => 'Store-Produkte konnten nicht geladen werden.';

  @override
  String premiumYearlySuffix(Object price) {
    return 'Jährlich: $price';
  }

  @override
  String premiumYearlyButton(Object plan) {
    return '$plan (Jährlich)';
  }

  @override
  String get deleteAccountTitle => 'Konto löschen';

  @override
  String get deleteAccountWarning => 'Möchten Sie Ihr Konto wirklich dauerhaft löschen? Alle Ihre Daten werden unwiderruflich entfernt.';

  @override
  String get deleteAccountButton => 'Konto löschen';

  @override
  String get accountDeleted => 'Ihr Konto wurde gelöscht.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get premiumDeactivated => 'Premium deaktiviert.';

  @override
  String acceptedByLabel(Object name) {
    return 'Angenommen von $name';
  }

  @override
  String get adresseValidator => 'Bitte gib eine Adresse an.';

  @override
  String get abgeschlosseneAuftraegeHinweis => 'Hier kannst du abgeschlossene Aufträge löschen und deinen Dienstleister bewerten.';

  @override
  String get goldBadgeLabel => 'Gold-Abo';

  @override
  String get silverBadgeLabel => 'Silber-Abo';

  @override
  String get topBewertetBadgeLabel => 'Top bewertet';

  @override
  String get badgeCertified => 'Zertifiziert';

  @override
  String get badgeExperienced => 'Erfahren';

  @override
  String get badgeExpert => 'Experte';

  @override
  String get badgeMaster => 'Master';

  @override
  String badgeCertifiedCounter(Object count) {
    return '$count Aufträge abgeschlossen';
  }

  @override
  String badgeExperiencedCounter(Object count) {
    return '$count Aufträge abgeschlossen';
  }

  @override
  String badgeExpertCounter(Object count) {
    return '$count Aufträge abgeschlossen';
  }

  @override
  String badgeMasterCounter(Object count) {
    return '$count Aufträge abgeschlossen';
  }

  @override
  String get achievementTitle => 'Erfolge & Abzeichen';

  @override
  String get goldBadgeDesc => 'Du besitzt ein Gold-Abo und kannst 5 Aufträge pro Woche annehmen.';

  @override
  String get silverBadgeDesc => 'Du besitzt ein Silber-Abo und kannst 2 Aufträge pro Woche annehmen.';

  @override
  String get topBewertetBadgeDesc => 'Erhalte einen Schnitt von mindestens 4,5 Sternen aus mindestens 5 Bewertungen.';

  @override
  String badgeCertifiedProgress(Object count) {
    return 'Zertifiziert ($count/1)';
  }

  @override
  String get badgeCertifiedDesc => 'Schließe 3 Aufträge ab.';

  @override
  String badgeExperiencedProgress(Object count) {
    return 'Erfahren ($count/2)';
  }

  @override
  String get badgeExperiencedDesc => 'Schließe insgesamt 10 Aufträge ab.';

  @override
  String badgeExpertProgress(Object count) {
    return 'Experte ($count/3)';
  }

  @override
  String get badgeExpertDesc => 'Schließe insgesamt 25 Aufträge ab.';

  @override
  String badgeMasterProgress(Object count) {
    return 'Meister ($count/4)';
  }

  @override
  String get badgeMasterDesc => 'Schließe insgesamt 50 Aufträge ab.';

  @override
  String get trafficScreenInfoText => 'Hier sehen Sie, wie viele Dienstleister pro Kategorie aktuell in Ihrer Umgebung aktiv sind. Je mehr Dienstleister, desto schneller wird Ihr Auftrag in der Regel angenommen.';

  @override
  String get filterAbgeschlossen => 'Abgeschlossen';

  @override
  String get auftraege => 'Aufträge';

  @override
  String get profil => 'Profil';

  @override
  String get filterAlle => 'Alle';

  @override
  String get filterOffen => 'Offen';

  @override
  String get filterLaufend => 'Laufend';

  @override
  String get forgotPasswordButton => 'Passwort vergessen?';

  @override
  String get forgotPasswordInfo => 'Gib deine registrierte E-Mail-Adresse ein. Du erhältst einen Link zum Zurücksetzen deines Passworts.';

  @override
  String get sendResetLinkButton => 'Reset-Link senden';

  @override
  String get resetMailSent => 'Link wurde versendet. Prüfe dein Postfach!';

  @override
  String get keineDienstleisterInRegion => 'In deiner Region wurde noch kein Dienstleister gefunden.';

  @override
  String get trafficScreenKeineAdresse => 'Keine Adresse in deinem Profil gefunden.';

  @override
  String get trafficScreenAdresseFehler => 'Deine Adresse konnte nicht in Koordinaten umgewandelt werden.';

  @override
  String get auftragWiederkehrendAppBar => 'Wiederkehrender Auftrag';

  @override
  String get auftragWiederkehrendHeadline => 'Soll der Auftrag regelmäßig wiederholt werden?';

  @override
  String get auftragWiederkehrendInfo => 'Wähle aus, ob und wie oft der Auftrag automatisch ausgeführt werden soll.';

  @override
  String get auftragReviewAppBar => 'Überprüfen & Absenden';

  @override
  String get auftragReviewHeadline => 'Alles korrekt?';

  @override
  String get auftragReviewInfo => 'Bitte überprüfe deine Eingaben, bevor du den Auftrag absendest.';

  @override
  String get absendenButton => 'Absenden';

  @override
  String get ja => 'Ja';

  @override
  String get nein => 'Nein';

  @override
  String get wiederholenBisLabelPlain => 'Wiederholen bis';

  @override
  String get auftragAdresseAppBar => 'Adresse & Kontakt';

  @override
  String get auftragAdresseHeadline => 'Wo soll der Auftrag ausgeführt werden?';

  @override
  String get auftragAdresseInfo => 'Bitte gib die Adresse und deine Telefonnummer an, damit der Dienstleister dich erreichen kann.';

  @override
  String get adresseHint => 'z.B. Musterstraße 12, 12345 Berlin';

  @override
  String get telefonnummerHint => 'z.B. 0176 12345678';

  @override
  String get zurueckButton => 'Zurück';

  @override
  String get weiterButton => 'Weiter';

  @override
  String get auftragKategorieAppBar => 'Kategorie wählen';

  @override
  String get auftragKategorieHeadline => 'Für welche Kategorie suchst du Unterstützung?';

  @override
  String get auftragKategorieInfo => 'Wähle die passende Dienstleistung. Du kannst später noch Details angeben.';

  @override
  String get kategorieValidator => 'Bitte wähle eine Kategorie aus.';

  @override
  String get auftragDetailsAppBar => 'Auftragsdetails';

  @override
  String get auftragDetailsHeadline => 'Beschreibe deinen Auftrag';

  @override
  String get auftragDetailsInfo => 'Was soll gemacht werden? Je genauer, desto besser!';

  @override
  String get auftragTerminAppBar => 'Termin & Zeit';

  @override
  String get auftragTerminHeadline => 'Wann soll der Auftrag erledigt werden?';

  @override
  String get auftragTerminInfo => 'Lege den Zeitpunkt fest oder wähle „so schnell wie möglich“.';

  @override
  String get terminLabel => 'Termin';

  @override
  String get preisLabel => 'Preis (€) oder \'verhandelbar\'';

  @override
  String get preisHint => 'z.B. 60 oder \'verhandelbar\'';

  @override
  String get preisValidator => 'Bitte gib einen gültigen Preis an oder \'verhandelbar\'.';

  @override
  String get preisHinweisLabel => 'Preis-Hinweis (optional)';

  @override
  String get preisHinweisHint => 'z.B. Stundenlohn, Materialkosten, Verhandlungsbasis etc.';

  @override
  String get preisTypLabel => 'Preisoption auswählen';

  @override
  String get preisTypGesamt => 'Gesamtpreis';

  @override
  String get preisTypStunden => 'Stundenlohn';

  @override
  String get preisTypVerhandelbar => 'Nach Absprache / verhandelbar';

  @override
  String get preisLabelGesamt => 'Gesamtpreis (€)';

  @override
  String get preisHintGesamt => 'z.B. 120';

  @override
  String get preisLabelStunden => 'Stundenlohn (€ pro Stunde)';

  @override
  String get preisHintStunden => 'z.B. 20';

  @override
  String get preisHinweisVerhandelbar => 'Preis nach Absprache / Angebot erwünscht';

  @override
  String get preisTypGesamtDesc => 'Du gibst den vollständigen Gesamtpreis für den Auftrag an.';

  @override
  String get preisTypStundenDesc => 'Du gibst einen Stundenlohn für den Auftrag an.';

  @override
  String get preisTypVerhandelbarDesc => 'Der Preis wird individuell mit dem Dienstleister vereinbart.';

  @override
  String get heimatadresseButtonInfo => 'Klicke hier, um deine hinterlegte Heimatadresse automatisch einzufügen. (Im Profil einstellbar)';

  @override
  String get verhandelbarLabel => 'Verhandelbar';

  @override
  String get terminValidierungFehler => 'Bitte wähle ein Datum und beide Uhrzeiten aus.';

  @override
  String get wiederkehrendValidierungFehler => 'Bitte wähle für wiederkehrende Aufträge Intervall, Wochentag und Anzahl korrekt aus.';

  @override
  String priceTotal(Object amount) {
    return '$amount €';
  }

  @override
  String pricePerHour(Object amount, Object hourShort) {
    return '$amount € / $hourShort';
  }

  @override
  String get priceNegotiable => 'Verhandelbar';

  @override
  String get hourShort => 'Std.';

  @override
  String get setNewPasswordTitle => 'Neues Passwort festlegen';

  @override
  String get setNewPasswordInfo => 'Gib dein neues Passwort zur Bestätigung zweimal ein.';

  @override
  String get newPasswordLabel => 'Neues Passwort';

  @override
  String get confirmNewPasswordLabel => 'Neues Passwort bestätigen';

  @override
  String get saveNewPasswordButton => 'Neues Passwort speichern';

  @override
  String get passwordEmptyError => 'Passwort darf nicht leer sein.';

  @override
  String get passwordsDontMatch => 'Passwörter stimmen nicht überein.';

  @override
  String get passwordResetSuccess => 'Passwort erfolgreich zurückgesetzt. Du kannst dich jetzt anmelden.';

  @override
  String get premiumRestorePurchases => 'Käufe wiederherstellen';

  @override
  String get premiumRetry => 'Erneut versuchen';

  @override
  String get wrongRoleCustomer => 'Dieses Konto ist als Dienstleister registriert und kann nicht für den Kunden-Login verwendet werden.';

  @override
  String get accountNotRegistered => 'Kein Konto mit dieser E-Mail gefunden. Bitte registrieren Sie sich zuerst.';

  @override
  String get wrongCredentials => 'Falsche E-Mail oder falsches Passwort.';

  @override
  String get premiumPushDelayFree => 'Push notifications: 1h delay';

  @override
  String get premiumPushDelaySilver => 'Push notifications: 30 min delay';

  @override
  String get premiumPushDelayGold => 'Push notifications: instant on new jobs';

  @override
  String get companyNameOptional => 'Firmenname (optional)';

  @override
  String get vatIdOptional => 'USt-IdNr. (optional)';

  @override
  String get bicOptional => 'BIC (optional)';

  @override
  String get smallBusinessLabel => 'Kleinunternehmer gem. § 19 UStG';

  @override
  String get defaultVatRateLabel => 'Standard-USt-Satz (%)';

  @override
  String get invalidVatRate => 'Ungültiger USt-Satz';

  @override
  String get profileNameLabel => 'Voller Name';

  @override
  String get invoiceNoShort => 'Nr:';

  @override
  String get netAmountLabel => 'Netto';

  @override
  String vatLabelWithPercent(Object percent) {
    return 'USt ($percent%)';
  }

  @override
  String get totalLabel => 'Gesamt';

  @override
  String get dueOnLabel => 'Fällig am:';

  @override
  String get vatIdLabel => 'USt-IdNr.:';

  @override
  String get bicLabel => 'BIC:';

  @override
  String paymentTermsDefault(Object days) {
    return 'Zahlbar innerhalb von $days Tagen ohne Abzug.';
  }

  @override
  String get badgeInfoText => 'Diese Abzeichen können nur von Dienstleistern erworben werden und erscheinen, wenn der Dienstleister den Auftrag annimmt.';

  @override
  String get noAuftraegeKundeHint => 'Erstelle deinen ersten Auftrag, indem du auf das Plus-Symbol (+) tippst.';

  @override
  String get upsellCardTitle => 'Auftrag in deiner Nähe';

  @override
  String upsellCategoryLabel(String category) {
    return 'Kategorie: $category';
  }

  @override
  String upsellUpgradeButton(String plan) {
    return 'Upgrade auf $plan, um diesen Auftrag zu sehen';
  }

  @override
  String get planFree => 'Free';

  @override
  String get planSilver => 'Silber';

  @override
  String get planGold => 'Gold';

  @override
  String get filterNeu => 'Neu';

  @override
  String onlyNewWindowInfo(int hours) {
    return 'Zeigt Aufträge der letzten $hours Stunden.';
  }

  @override
  String get cancelLabel => 'Abbrechen';

  @override
  String get editProfileCta => 'Profil vervollständigen';

  @override
  String get update_required_title => 'Update erforderlich';

  @override
  String get update_required_message => 'Bitte aktualisiere die App, um fortzufahren.';

  @override
  String get update_available_title => 'Update verfügbar';

  @override
  String get update_available_message => 'Eine neue Version ist verfügbar. Jetzt aktualisieren?';

  @override
  String get update_action_update_now => 'Jetzt aktualisieren';

  @override
  String get update_action_later => 'Später';

  @override
  String get invoiceSectionSubtitle => 'Optional: Firmen- und Steuerdaten für die automatische Rechnungsstellung';

  @override
  String get marketplaceTitle => 'Aufträge handeln';

  @override
  String get marketplaceTabSell => 'Verkaufen';

  @override
  String get marketplaceTabBuy => 'Kaufen';

  @override
  String get marketplaceOfferCreateCta => 'Auftrag weitergeben';

  @override
  String get marketplaceFilter => 'Filter';

  @override
  String get marketplaceSort => 'Sortieren';

  @override
  String get marketplaceBuyNow => 'Jetzt bewerben';

  @override
  String get marketplaceSnackOpenForm => 'Formular zum Anbieten öffnen…';

  @override
  String get marketplaceSnackStartCheckout => 'Kauf-Flow starten…';

  @override
  String marketplaceOfferTitle(int index) {
    return 'Angebot #$index';
  }

  @override
  String marketplaceOfferSubtitle(String category, String price, Object distanceKm) {
    return '$category • $distanceKm km';
  }

  @override
  String marketplaceBuyTitle(int index) {
    return 'Kaufangebot #$index · Kleinreparatur';
  }

  @override
  String marketplaceBuySubtitle(String category, String price, String distance) {
    return 'Kategorie: $category · $price/h · $distance km';
  }

  @override
  String get marketplaceEmptyList => 'Keine passenden Angebote gefunden.';

  @override
  String get marketplaceErrorLoading => 'Liste konnte nicht geladen werden.';

  @override
  String get marketplaceAppliedSuccess => 'Beworben – der Verkäufer sieht deine Anfrage.';

  @override
  String get marketplaceAlreadyApplied => 'Du hast dich bereits beworben.';

  @override
  String marketplaceProvisionPercent(Object value) {
    return '$value %';
  }

  @override
  String marketplaceProvisionFixed(Object value) {
    return '$value';
  }

  @override
  String marketplaceChipTargetPrice(Object price) {
    return 'Zielpreis: $price';
  }

  @override
  String marketplaceChipProvision(Object value) {
    return 'Provision: $value';
  }

  @override
  String get s0Title => 'Auftrag weitergeben (S0)';

  @override
  String get sectionBasics => 'Basis';

  @override
  String get fieldTitle => 'Titel';

  @override
  String get hintTitleExample => 'z. B. Dachsanierung EFH, 120 m²';

  @override
  String get fieldDescription => 'Beschreibung';

  @override
  String get hintDescription => 'Kurzbeschreibung, Besonderheiten, Material inkl./exkl.';

  @override
  String get fieldLocation => 'Ort/Radius (vorerst Text)';

  @override
  String get hintLocation => 'z. B. Köln, 15 km';

  @override
  String get pickStartDate => 'Startdatum wählen';

  @override
  String get pickDeadline => 'Deadline wählen';

  @override
  String get labelStart => 'Start';

  @override
  String get labelDeadline => 'Deadline';

  @override
  String get sectionS0PriceProvision => 'S0 – Preis & Provision';

  @override
  String get tooltipS0PriceProvision => 'Zielpreis = Gesamtpreis des Auftrags.\nProvision = Vergütung für die Weitergabe.';

  @override
  String get fieldTargetPriceEur => 'Zielpreis (EUR)';

  @override
  String get hintTargetPriceExample => 'z. B. 12.500';

  @override
  String get helpTargetPrice => 'Gesamter Auftragswert, den der Käufer übernimmt.';

  @override
  String get fieldProvisionType => 'Provisionsart';

  @override
  String get provisionTypePercent => 'Prozent';

  @override
  String get provisionTypeFixed => 'Fix';

  @override
  String get fieldProvisionValuePercent => 'Provisionswert (%)';

  @override
  String get fieldProvisionValueFixed => 'Provisionswert (€)';

  @override
  String get helpProvisionPercent => 'Üblich: 5–12 % (Cap möglich).';

  @override
  String get helpProvisionFixed => 'Fixbetrag als Provision.';

  @override
  String get fieldProvisionDue => 'Wann wird die Provision fällig?';

  @override
  String get provisionDueAward => 'bei Vergabe';

  @override
  String get provisionDueHandover => 'bei Übergabe';

  @override
  String get provisionDueFinalInvoice => 'bei Schlussrechnung';

  @override
  String get provisionDueAwardHelp => 'Bei Vergabe: Die Provision wird direkt nach der Vergabe fällig.';

  @override
  String get provisionDueHandoverHelp => 'Bei Übergabe: nach Kunden-OK & Übergabe fällig.';

  @override
  String get provisionDueFinalInvoiceHelp => 'Bei Schlussrechnung: wenn der Käufer-DL den Auftrag abschließt.';

  @override
  String get sectionEvidencePlaceholder => 'Nachweise (Platzhalter)';

  @override
  String get btnUploadEvidence => 'Angebot/Kunden-OK hochladen';

  @override
  String get btnCreateDraft => 'Als Entwurf anlegen';

  @override
  String get btnSaving => 'Speichere…';

  @override
  String get noteSupabaseActive => 'Hinweis: Supabase-Speicherung aktiv. Payment & Upload folgen später.';

  @override
  String get formErrorRequired => 'Pflichtfeld';

  @override
  String get formErrorInvalidAmount => 'Ungültiger Betrag';

  @override
  String get formErrorGreaterZero => 'Muss > 0 sein';

  @override
  String get formErrorRealistic => 'Bitte realistisch bleiben';

  @override
  String get formErrorInvalidValue => 'Ungültiger Wert';

  @override
  String get formErrorPercentRange => '0–30 % erlaubt';

  @override
  String get errPickStartDate => 'Bitte Startdatum wählen';

  @override
  String get errPickDeadline => 'Bitte Enddatum/Deadline wählen';

  @override
  String get draftSaved => 'S0-Entwurf gespeichert.';

  @override
  String get genericError => 'Etwas ist schiefgelaufen.';

  @override
  String get btnMyDeals => 'Meine Deals';

  @override
  String get myDealsTitle => 'Meine Deals';

  @override
  String get myDealsEmpty => 'Noch keine Aufträge angelegt.';

  @override
  String get myDealsErrorLoading => 'Deine Aufträge konnten nicht geladen werden.';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterDraft => 'Entwürfe';

  @override
  String get filterLive => 'Live';

  @override
  String get filterAwarded => 'Vergeben';

  @override
  String get manageTitle => 'Auftrag verwalten';

  @override
  String get manageErrorLoading => 'Details konnten nicht geladen werden.';

  @override
  String get btnPublish => 'Veröffentlichen';

  @override
  String get publishSuccess => 'Auftrag veröffentlicht.';

  @override
  String get applicationsTitle => 'Bewerbungen';

  @override
  String get applicationsEmpty => 'Noch keine Bewerbungen.';

  @override
  String get applicationNote => 'Notiz';

  @override
  String get applicationStatusPending => 'Status: offen';

  @override
  String get applicationStatusAwarded => 'Status: vergeben';

  @override
  String get btnAward => 'Vergeben';

  @override
  String get btnManage => 'Verwalten';

  @override
  String get labelStatus => 'Status';

  @override
  String get statusDraft => 'Entwurf';

  @override
  String get statusLive => 'Live';

  @override
  String get statusAwarded => 'Vergeben';

  @override
  String get awardSuccess => 'Bewerbung erfolgreich vergeben.';

  @override
  String get snackNewApplication => 'Neue Bewerbung eingegangen';

  @override
  String applicationsCount(Object count) {
    return '$count Bewerbungen';
  }

  @override
  String get btnApplied => 'Beworben';

  @override
  String get s0EditTitle => 'S0 bearbeiten';

  @override
  String get publishNow => 'Nach dem Speichern veröffentlichen';

  @override
  String get publishNowHint => 'Wenn aktiviert, wird der Entwurf nach dem Speichern auf „Live“ gesetzt.';

  @override
  String get btnSaveChanges => 'Änderungen speichern';

  @override
  String get saved => 'Gespeichert';

  @override
  String get marketplaceLocationLoadedFromProfile => 'Position aus deinem Profil geladen – Radiusfilter aktiv.';

  @override
  String get marketplaceNoHomeAddressHint => 'Keine Adresse im Profil – zeige alle Angebote ohne Distanzfilter.';

  @override
  String get fieldCategory => 'Kategorie';

  @override
  String get categoryAll => 'Alle';

  @override
  String get categoryRoofer => 'Dachdecker';

  @override
  String get categorySolar => 'PV / Solar';

  @override
  String get categoryHVAC => 'Heizung / Sanitär / Klima';

  @override
  String get categoryElectrical => 'Elektrik';

  @override
  String get categoryDrywall => 'Trockenbau';

  @override
  String get categoryPainter => 'Maler';

  @override
  String get categoryTiling => 'Fliesenleger';

  @override
  String get categoryFlooring => 'Bodenleger';

  @override
  String get categoryWindowsDoors => 'Fenster & Türen';

  @override
  String get categoryInsulationFacade => 'Dämmung & Fassade';

  @override
  String get categoryMasonryConcrete => 'Maurer & Betonbauer';

  @override
  String get categoryCarpentryJoinery => 'Zimmerer & Tischler';

  @override
  String get categoryLandscaping => 'Garten- & Landschaftsbau';

  @override
  String get categoryScaffolding => 'Gerüstbau';

  @override
  String get categoryCleaningRestoration => 'Reinigung & Sanierung';

  @override
  String get categoryMovingTransport => 'Umzug & Transport';

  @override
  String get sectionCustomerOk => 'Kunden-OK';

  @override
  String get helpCustomerOk => 'Nachweis, dass der Kunde der Weitergabe zustimmt (z. B. unterschriebenes Angebot, E-Mail/SMS als PDF/Foto).';

  @override
  String get btnUploadCustomerOk => 'Kunden-OK hochladen';

  @override
  String get customerNameOptional => 'Kundenname (optional)';

  @override
  String get customerPhoneOptional => 'Telefon (optional)';

  @override
  String get sectionOffer => 'Angebot / Auftragsbestätigung';

  @override
  String get helpOfferOptional => 'Dein Angebot oder die Auftragsbestätigung. Optional, aber hilfreich für Käufer.';

  @override
  String get btnUploadOffer => 'Angebot hochladen';

  @override
  String get errCustomerOkRequired => 'Zum Veröffentlichen wird mindestens ein Kunden-OK benötigt.';

  @override
  String get warnMissingDocsBody => 'Hinweis: Ohne Kunden-OK/Angebot kannst du später nicht veröffentlichen. Du kannst die Nachweise jederzeit nachtragen.';

  @override
  String get attestLabel => 'Ich bestätige wahrheitsgemäß, dass der Kunde der Weitergabe zustimmt und alle Angaben korrekt sind.';

  @override
  String get attestConsequences => 'Bei Falschangaben behalten wir uns Sperre, Einbehalt von Auszahlungen sowie zivil- und ggf. strafrechtliche Schritte vor.';

  @override
  String get errAttestRequired => 'Zum Veröffentlichen musst du die Bestätigung ankreuzen.';

  @override
  String get genericPleaseFix => 'Bitte korrigiere die markierten Felder:';

  @override
  String get errAwardNeedsDoc => 'Bei Fälligkeit „bei Vergabe“ ist ein Nachweis/Angebot erforderlich.';

  @override
  String get errNotOwner => 'Du bist nicht Eigentümer dieses Auftrags.';

  @override
  String get errPublishOnlyFromDraft => 'Veröffentlichen ist nur aus dem Entwurfsstatus möglich.';

  @override
  String get publishRequirementsTitle => 'Voraussetzungen zum Veröffentlichen';

  @override
  String get infoReqCustomerOk => 'Mindestens ein Kunden-OK ist hinterlegt.';

  @override
  String get infoReqDocForAward => 'Bei „bei Vergabe“: Angebot/Auftragsbestätigung hochladen.';

  @override
  String get infoReqAttest => 'Bestätigung im Formular ist angehakt.';

  @override
  String get draftChecklistTitle => 'Checkliste vor dem Veröffentlichen';

  @override
  String get chkTitle => 'Titel ausgefüllt';

  @override
  String get chkDescription => 'Beschreibung ausgefüllt';

  @override
  String get chkLocation => 'Adresse/Ort gesetzt';

  @override
  String get chkTargetPrice => 'Zielpreis gesetzt';

  @override
  String get chkCustomerOk => 'Kunden-OK vorhanden';

  @override
  String get chkDocIfAward => 'Nachweis/Angebot vorhanden (empfohlen bei Fälligkeit „bei Vergabe“)';

  @override
  String get chkAttestAtPublish => 'Bestätigung im Formular anhaken';

  @override
  String get draftChecklistCta => 'Zur Verwaltung';

  @override
  String get uploadSuccess => 'Upload erfolgreich.';

  @override
  String get uploadInProgress => 'Upload läuft...';

  @override
  String get uploadFailed => 'Upload fehlgeschlagen.';

  @override
  String get draftDefaultTitle => 'Entwurf';

  @override
  String get errGeocodingFailed => 'Adresse konnte nicht geokodiert werden.';

  @override
  String get provisionDueAwardLabel => 'Beauftragung';

  @override
  String get provisionDueHandoverLabel => 'Übergabe';

  @override
  String get provisionDueFinalInvoiceLabel => 'Schlussrechnung';

  @override
  String get sectionPreviewPublic => 'Vorschau (öffentlich)';

  @override
  String get tooltipPreviewPublic => 'Diese Dateien sind vor dem Kauf sichtbar. Bitte nur anonymisierte/schwärzte Previews hochladen.';

  @override
  String get btnUploadPreview => 'Preview hochladen';

  @override
  String get previewRedactionNoticeTitle => 'Wichtiger Hinweis zur Vorschau';

  @override
  String get previewRedactionNoticeBody => 'Previews sind vor dem Kauf für Käufer sichtbar. Schwärze sensible Daten (z. B. Namen, Adressen, Telefonnummern, Vertrags-/Kundennummern, Unterschriften, QR-/Barcodes). Lade keine Dokumente hoch, die personenbezogene Daten ungeschwärzt enthalten.';

  @override
  String get hintPhoneExample => '+49 170 1234567';

  @override
  String get createDealTitle => 'Handel erstellen';

  @override
  String get chooseDealTypeTitle => 'Art des Handels wählen';

  @override
  String get dealTypeS0Title => 'S0 – Weiterverkauf';

  @override
  String get dealTypeS0Subtitle => 'Kompletten Auftrag an anderen Dienstleister weitergeben.';

  @override
  String get dealTypeS1Title => 'S1 – Teilgewerk/Subunternehmer (Meilensteine)';

  @override
  String get dealTypeS1Subtitle => 'Unterauftrag mit Meilensteinen & Nachweisen.';

  @override
  String get s1Title => 'Subunternehmer suchen (S1)';

  @override
  String get sectionS1Pricing => 'Preisgestaltung';

  @override
  String get sectionS1Provision => 'Provision';

  @override
  String get sectionMilestones => 'Meilensteine';

  @override
  String get pricingModeFixed => 'Festpreis';

  @override
  String get pricingModeTm => 'Zeit & Material';

  @override
  String get basePriceLabel => 'Gesamtbudget (€)';

  @override
  String get hourlyRateLabel => 'Stundensatz (€)';

  @override
  String get expectedHoursLabel => 'Erwartete Stunden';

  @override
  String get dueTypeAward => 'Beauftragung';

  @override
  String get dueTypeDate => 'Datum';

  @override
  String get dueTypeHandover => 'Übergabe';

  @override
  String get dueTypeCustom => 'Benutzerdefiniert';

  @override
  String get dueTypeCustomHelp => 'Eigener Fälligkeitszeitpunkt (bitte als Datum/Kommentar angeben).';

  @override
  String get milestoneLabel => 'Meilenstein';

  @override
  String get milestoneTitle => 'Titel des Meilensteins';

  @override
  String get milestoneDescription => 'Beschreibung des Meilensteins';

  @override
  String get milestoneAmount => 'Betrag (€)';

  @override
  String get milestonePercent => 'Prozent (%)';

  @override
  String get milestoneDue => 'Fälligkeit';

  @override
  String get btnAddMilestonePercent => 'Meilenstein (% ) hinzufügen';

  @override
  String get btnAddMilestoneAmount => 'Meilenstein (€) hinzufügen';

  @override
  String get milestoneEmptyHint => 'Noch keine Meilensteine hinzugefügt (optional).';

  @override
  String get milestoneBlocking => 'Blockierend';

  @override
  String get milestoneBlockingHelp => 'Muss erledigt sein, bevor der nächste Schritt freigeschaltet wird.';

  @override
  String get validationMilestoneSum => 'Die Meilensteinsumme passt nicht: Bei Prozenten 100 % erforderlich, bei Festpreis müssen Beträge dem Gesamtbudget entsprechen.';

  @override
  String get btnReorder => 'Reihenfolge ändern';

  @override
  String get infoS1PricingHelp => 'So kalkulierst du den Auftrag für Subunternehmer. „Festpreis“ = ein Gesamtbudget für das Teilgewerk. „Zeit & Material“ = Stundensatz + geschätzte Stunden; abgerechnet wird nach tatsächlichem Aufwand.';

  @override
  String get infoS1ProvisionHelp => 'Deine Vermittlungs-/Managementprovision je beauftragtem Subunternehmer. Lege Prozent oder festen Betrag und die Fälligkeit fest.';

  @override
  String get coordChipNoCoords => 'Ohne Koordinaten';

  @override
  String get coordMissingLabel => 'Koordinaten (lat/lng)';

  @override
  String get s0DetailsMissingLabel => 'S0-Details';

  @override
  String get s1DetailsMissingLabel => 'S1-Details';

  @override
  String get marketplaceTypeS0 => 'S0 – Auftrag weitergeben';

  @override
  String get marketplaceTypeS1 => 'S1 – Subsuche';

  @override
  String get filterTypeAll => 'Alle Typen';

  @override
  String get filterTypeS0 => 'Nur S0';

  @override
  String get filterTypeS1 => 'Nur S1';

  @override
  String get badgeAwardedToYou => 'Beauftragt (für dich)';

  @override
  String get badgeAwardedGiven => 'Beauftragung vergeben';

  @override
  String get btnAssigned => 'Beauftragt';

  @override
  String get marketplaceOwnDealPill => 'Dein Auftrag';
}
