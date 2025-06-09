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
  String get premiumFreeFeature1 => 'Auftragsradius: 10 km';

  @override
  String get premiumFreeFeature2 => 'Max. 2 Aufträge/Woche';

  @override
  String get premiumFreeFeature3 => 'Kategorie/Adresse selten änderbar';

  @override
  String get premiumSilverPrice => '4,99 € / Monat';

  @override
  String get premiumSilverFeature1 => 'Auftragsradius: 30 km';

  @override
  String get premiumSilverFeature2 => 'Max. 5 Aufträge/Woche';

  @override
  String get premiumSilverFeature3 => 'Kategorie/Adresse jederzeit ändern';

  @override
  String get premiumSilverFeature4 => 'Normale Sichtbarkeit';

  @override
  String get premiumGoldPrice => '9,99 € / Monat';

  @override
  String get premiumGoldFeature1 => 'Auftragsradius: 70 km';

  @override
  String get premiumGoldFeature2 => 'Unbegrenzte Aufträge';

  @override
  String get premiumGoldFeature3 => 'Hervorgehobenes Profil';

  @override
  String get premiumGoldFeature4 => 'Premium-Support';

  @override
  String get premiumGoldFeature5 => 'Kategorie/Adresse jederzeit ändern';

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
}
