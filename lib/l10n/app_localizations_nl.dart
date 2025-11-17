// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get registerAppBar => 'Registratie';

  @override
  String get registerTitle => 'Registreren';

  @override
  String get roleLabel => 'Rol selecteren';

  @override
  String get roleKunde => 'Klant';

  @override
  String get roleDienstleister => 'Dienstverlener';

  @override
  String get categoryLabel => 'Dienstcategorie';

  @override
  String get categoryValidator => 'Selecteer een categorie';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailEmpty => 'Voer een e-mailadres in';

  @override
  String get emailInvalid => 'Voer een geldig e-mailadres in';

  @override
  String get passwordLabel => 'Wachtwoord';

  @override
  String get passwordEmpty => 'Voer een wachtwoord in';

  @override
  String get passwordTooShort => 'Het wachtwoord moet minstens 8 tekens bevatten.';

  @override
  String get registerButton => 'Registreren';

  @override
  String get registerSuccess => 'Registratie geslaagd! Bevestig je e-mail.';

  @override
  String get registerExists => 'Dit e-mailadres is al geregistreerd. Log in of reset je wachtwoord.';

  @override
  String get registerInvalidEmail => 'Voer een geldig e-mailadres in.';

  @override
  String get registerPasswordShort => 'Het wachtwoord moet minimaal 6 tekens bevatten.';

  @override
  String registerFailed(Object error) {
    return 'Registratie mislukt: $error';
  }

  @override
  String registerUnknownError(Object error) {
    return 'Onbekende fout: $error';
  }

  @override
  String get profileAppBar => 'Profiel – Adres';

  @override
  String get profileAddressLabel => 'Thuisadres (bijv. Voorbeeldstraat 12, 1234 AB Voorbeeldstad)';

  @override
  String get profileAddressEmpty => 'Voer een adres in';

  @override
  String get profileSaveButton => 'Opslaan';

  @override
  String get profileAddressSaved => 'Adres opgeslagen!';

  @override
  String profileLoadError(Object error) {
    return 'Fout bij het laden: $error';
  }

  @override
  String profileSaveError(Object error) {
    return 'Fout bij het opslaan: $error';
  }

  @override
  String get notLoggedIn => 'Niet ingelogd';

  @override
  String get pleaseLogin => 'Log eerst in';

  @override
  String get changeNotAllowedTitle => 'Wijziging niet toegestaan';

  @override
  String changeNotAllowedContent(Object date) {
    return 'Als gratis gebruiker kun je categorie of adres slechts om de 20 dagen wijzigen.\nVolgende wijziging mogelijk op: $date';
  }

  @override
  String get ok => 'OK';

  @override
  String get profileSaved => 'Profiel succesvol opgeslagen!';

  @override
  String get changeProfileImage => 'Profielfoto wijzigen';

  @override
  String get upgradeToPremium => 'Upgrade naar Premium';

  @override
  String get noRatingsYet => 'Nog geen beoordelingen';

  @override
  String get nameLabel => 'Naam';

  @override
  String get nameValidator => 'Voer een naam in';

  @override
  String get descriptionLabel => 'Beschrijving van de dienst:';

  @override
  String get addressLabel => 'Adres (bijv. Straat, Postcode, Stad)';

  @override
  String get phoneLabel => 'Telefoon';

  @override
  String get phoneValidator => 'Voer een telefoonnummer in';

  @override
  String get emailEmptyValidator => 'Voer een e-mailadres in';

  @override
  String get emailInvalidValidator => 'Voer een geldig e-mailadres in';

  @override
  String errorPrefix(Object error) {
    return 'Fout: $error';
  }

  @override
  String changeLimitHint(Object date) {
    return 'Categorie/adres kan pas gewijzigd worden vanaf $date.';
  }

  @override
  String get addressNotFound => 'Adres niet gevonden. Controleer a.u.b.';

  @override
  String ratingsCount(Object count) {
    return '($count beoordelingen)';
  }

  @override
  String get premiumAppBar => 'Upgrade naar Premium';

  @override
  String get premiumChoosePlan => 'Kies je Premium-plan';

  @override
  String get premiumCurrentPlan => 'Huidig abonnement:';

  @override
  String get premiumFreePrice => 'gratis';

  @override
  String get premiumSilverPrice => '€4.99 / month';

  @override
  String get premiumGoldPrice => '€9.99 / month';

  @override
  String get premiumFreeFeature1 => '1 opdracht per week aannemen';

  @override
  String get premiumFreeFeature2 => 'Opdrachten binnen 5 km';

  @override
  String get premiumFreeFeature3 => 'Alleen basiscategorieën';

  @override
  String get premiumFreeFeature4 => 'Categorie wijzigen slechts om de 20 dagen';

  @override
  String get premiumSilverFeature1 => '2 opdrachten per week aannemen';

  @override
  String get premiumSilverFeature2 => 'Opdrachten binnen 15 km';

  @override
  String get premiumSilverFeature3 => 'Alle categorieën beschikbaar';

  @override
  String get premiumGoldFeature1 => '5 opdrachten per week aannemen';

  @override
  String get premiumGoldFeature2 => 'Opdrachten binnen 30 km';

  @override
  String get premiumGoldFeature3 => 'Alle categorieën beschikbaar';

  @override
  String get premiumGoldFeature4 => 'Premium-badge (zichtbaar voor klanten)';

  @override
  String premiumChooseButton(Object title) {
    return '$title kiezen';
  }

  @override
  String get premiumPaymentNote => 'Let op: Alle betalingen verlopen veilig via Apple of Google. Je kunt je abonnement altijd opzeggen of beheren in de store.';

  @override
  String get premiumSilverComingSoon => 'Silver binnenkort beschikbaar!';

  @override
  String get premiumGoldComingSoon => 'Gold binnenkort beschikbaar!';

  @override
  String get auftragHidden => 'Opdracht verborgen.';

  @override
  String auftragHideError(Object error) {
    return 'Fout bij het verbergen: $error';
  }

  @override
  String get meineAuftraegeAppBar => 'Mijn opdrachten';

  @override
  String get refreshTooltip => 'Vernieuwen';

  @override
  String get noAuftraegeFound => 'Geen opdrachten gevonden.';

  @override
  String get geplanterAuftrag => 'Geplande opdracht';

  @override
  String get auftragAusblenden => 'Opdracht verbergen';

  @override
  String get loginFailedDetails => 'Inloggen mislukt. Controleer je gegevens of bevestig je e-mail.';

  @override
  String get loginSuccess => 'Succesvol ingelogd!';

  @override
  String loginFailedPrefix(Object error) {
    return 'Inloggen mislukt: $error';
  }

  @override
  String loginUnknownError(Object error) {
    return 'Onbekende fout: $error';
  }

  @override
  String get emailValidatorEmpty => 'Voer een e-mailadres in';

  @override
  String get emailValidatorInvalid => 'Voer een geldig e-mailadres in';

  @override
  String get passwordValidatorEmpty => 'Voer een wachtwoord in';

  @override
  String get passwordValidatorShort => 'Het wachtwoord moet minimaal 6 tekens bevatten';

  @override
  String get loginKundeAppBar => 'Login voor klanten';

  @override
  String get loginKundeHeadline => 'Inloggen';

  @override
  String get loginButton => 'Login';

  @override
  String get noAccountYet => 'Nog geen account? Nu registreren';

  @override
  String get loginFailedDetailsDL => 'Inloggen mislukt. Controleer je gegevens of bevestig je e-mail.';

  @override
  String get wrongRoleDL => 'Dit account is geen dienstverlener. Gebruik de klant-login.';

  @override
  String get loginDLAppBar => 'Login voor dienstverleners';

  @override
  String get loginDLHeadline => 'Inloggen';

  @override
  String get kundenDashboardHeader => 'Jouw dashboard';

  @override
  String get kundenDashboardAppBar => 'Klantendashboard';

  @override
  String get laufendeAuftraege => 'Lopende opdrachten';

  @override
  String statusPrefix(Object status) {
    return 'Status: $status';
  }

  @override
  String dienstleisterPrefix(Object dienstleister) {
    return 'Dienstverlener: $dienstleister';
  }

  @override
  String get offeneAuftraege => 'Openstaande opdrachten';

  @override
  String get noOffeneAuftraege => 'Geen openstaande opdrachten gevonden.';

  @override
  String get abgeschlosseneAuftraege => 'Afgeronde opdrachten';

  @override
  String get abgeschlossenStatus => 'Afgerond';

  @override
  String get neuerAuftrag => 'Nieuwe opdracht';

  @override
  String get pleaseCreateProfile => 'Maak eerst je profiel aan.';

  @override
  String get profilMissingCategory => 'Categorie in profiel ontbreekt.';

  @override
  String get dienstleisterDashboardHeader => 'Jouw dashboard';

  @override
  String get dienstleisterDashboardAppBar => 'Dashboard dienstverlener';

  @override
  String get meineLaufendenAuftraege => 'Mijn lopende opdrachten';

  @override
  String kundePrefix(Object kunde) {
    return 'Klant: $kunde';
  }

  @override
  String get offenePassendeAuftraege => 'Open, passende opdrachten';

  @override
  String get noPassendeAuftraege => 'Geen passende opdrachten gevonden.';

  @override
  String entfernungSuffix(Object dist) {
    return '$dist km verwijderd';
  }

  @override
  String get auftragBereitsBewertet => 'Je hebt deze opdracht al beoordeeld.';

  @override
  String get bewertungDialogTitle => 'Dienstverlener beoordelen';

  @override
  String get bewertungKommentarLabel => 'Opmerking (optioneel)';

  @override
  String get abbrechen => 'Annuleren';

  @override
  String get abschicken => 'Verzenden';

  @override
  String get auftragErstellenTitle => 'Nieuwe opdracht aanmaken';

  @override
  String get auftragEinstellenUeberschrift => 'Nu opdracht plaatsen';

  @override
  String get titelLabel => 'Titel';

  @override
  String get titelValidator => 'Voer een titel in';

  @override
  String get beschreibungLabel => 'Beschrijving';

  @override
  String get kategorieLabel => 'Categorie';

  @override
  String get heimatadresseEinfuegen => 'Thuisadres invoegen';

  @override
  String get adresseLabel => 'Adres (bijv. Oude Markt 76, 50667 Keulen)';

  @override
  String get telefonnummerLabel => 'Telefoonnummer';

  @override
  String get telefonnummerValidator => 'Voer een telefoonnummer in';

  @override
  String get ausfuehrungszeitpunkt => 'Tijdstip uitvoering';

  @override
  String get soSchnellWieMoeglich => 'Zo snel mogelijk';

  @override
  String get geplant => 'Gepland';

  @override
  String get datumWaehlen => 'Datum kiezen';

  @override
  String get zeitVon => 'Tijd van';

  @override
  String get zeitBis => 'Tijd tot';

  @override
  String get wiederkehrendCheckbox => 'Terugkerende opdracht?';

  @override
  String get intervallLabel => 'Interval';

  @override
  String get intervallValidator => 'Selecteer een interval';

  @override
  String get wochentagLabel => 'Weekdag';

  @override
  String get wochentagValidator => 'Selecteer een weekdag';

  @override
  String get anzahlWiederholungenLabel => 'Aantal herhalingen (optioneel)';

  @override
  String get wiederholenBisNichtGesetzt => 'Herhalen tot: niet ingesteld';

  @override
  String wiederholenBisLabel(Object date) {
    return 'Herhalen tot: $date';
  }

  @override
  String get auftragAbschicken => 'Opdracht plaatsen';

  @override
  String get auftragGespeichert => 'Opdracht opgeslagen!';

  @override
  String get bitteEinloggen => 'Log eerst in';

  @override
  String get adresseNichtGefunden => 'Adres niet gevonden.';

  @override
  String unbekannterFehler(Object error) {
    return 'Onbekende fout: $error';
  }

  @override
  String get auftragDetailTitle => 'Opdrachtgegevens';

  @override
  String get nichtEingeloggt => 'Niet ingelogd';

  @override
  String get rolleNichtErmittelt => 'Rol kon niet worden bepaald';

  @override
  String get auftragNichtGefunden => 'Opdracht niet gevonden';

  @override
  String get bewertungDanke => 'Bedankt voor je beoordeling!';

  @override
  String get limitErreicht => 'Limiet bereikt';

  @override
  String get limitFree => 'Als Freemium-dienstverlener kun je maximaal 2 opdrachten per week aannemen. Upgrade naar Silver of Gold voor meer mogelijkheden!';

  @override
  String get limitSilver => 'Als Silver-dienstverlener kun je maximaal 5 opdrachten per week aannemen. Upgrade naar Gold voor onbeperkt opdrachten!';

  @override
  String get auftragAnnehmen => 'Opdracht aannemen';

  @override
  String get auftragBeenden => 'Opdracht voltooien';

  @override
  String get auftragEntfernenUebersicht => 'Opdracht uit overzicht verwijderen';

  @override
  String get auftragEntfernen => 'Opdracht verwijderen';

  @override
  String get auftragEntfernenTitel => 'Opdracht verwijderen?';

  @override
  String get auftragEntfernenText => 'Wil je deze opdracht uit je overzicht verwijderen?';

  @override
  String get entfernen => 'Verwijderen';

  @override
  String get keineDatenVerfuegbar => 'Geen gegevens beschikbaar';

  @override
  String get beschreibung => 'Beschrijving:';

  @override
  String get kategorie => 'Categorie:';

  @override
  String get adresse => 'Adres:';

  @override
  String get status => 'Status:';

  @override
  String jedenWochentag(Object wochentag) {
    return 'Elke $wochentag';
  }

  @override
  String bisDatum(Object datum) {
    return 'tot $datum';
  }

  @override
  String get malSuffix => 'keer';

  @override
  String kontaktZuLabel(Object label) {
    return 'Contact met $label:';
  }

  @override
  String get nummerKopiert => 'Nummer gekopieerd!';

  @override
  String get nummerKopieren => 'Nummer kopiëren';

  @override
  String get anrufen => 'Bellen';

  @override
  String fehlerPrefix(Object error) {
    return 'Fout: $error';
  }

  @override
  String get editProfileTooltip => 'Profiel bewerken';

  @override
  String get appTitle => 'AtYourService';

  @override
  String get hello => 'Welkom!';

  @override
  String get kundeButton => 'Ik zoek een dienstverlener';

  @override
  String get dienstleisterButton => 'Ik ben dienstverlener';

  @override
  String get category_babysitter => 'Oppas / Kinderopvang';

  @override
  String get category_catering => 'Catering';

  @override
  String get category_dachdecker => 'Dakdekker';

  @override
  String get category_elektriker => 'Elektricien';

  @override
  String get category_ernaehrungsberatung => 'Voedingsadvies';

  @override
  String get category_eventplanung => 'Eventplanning';

  @override
  String get category_fahrdienste => 'Vervoersdiensten';

  @override
  String get category_fahrlehrer => 'Rij-instructeur';

  @override
  String get category_fensterputzer => 'Glazenwasser';

  @override
  String get category_fliesenleger => 'Tegelzetter';

  @override
  String get category_fotografie => 'Fotografie / Videografie';

  @override
  String get category_friseur => 'Kapper';

  @override
  String get category_gartenpflege => 'Tuinonderhoud / Grasmaaien';

  @override
  String get category_grafikdesign => 'Grafisch ontwerp';

  @override
  String get category_handy_reparatur => 'Smartphone/Tablet-reparatie';

  @override
  String get category_haushaltsreinigung => 'Huishoudelijke schoonmaak';

  @override
  String get category_hausmeisterservice => 'Conciërgediensten';

  @override
  String get category_heizungsbauer => 'Verwarmingsmonteur';

  @override
  String get category_hundesitter => 'Hondenuitlaatservice';

  @override
  String get category_it_support => 'IT-support';

  @override
  String get category_klempner => 'Loodgieter';

  @override
  String get category_kosmetik => 'Schoonheidsspecialist';

  @override
  String get category_kuenstler => 'Artiest (bijv. muzikant voor events)';

  @override
  String get category_kurierdienst => 'Koeriersdienst';

  @override
  String get category_maler => 'Schilder';

  @override
  String get category_massagen => 'Massages';

  @override
  String get category_maurer => 'Metselaar';

  @override
  String get category_moebelaufbau => 'Meubelmontage';

  @override
  String get category_musikunterricht => 'Muziekles';

  @override
  String get category_nachhilfe => 'Bijles';

  @override
  String get category_nagelstudio => 'Nagelstudio';

  @override
  String get category_pc_reparatur => 'PC-/laptopreparatie';

  @override
  String get category_partyservice => 'Feestservice';

  @override
  String get category_personal_trainer => 'Personal trainer';

  @override
  String get category_rasenmaeher_service => 'Tuinonderhoud / Tuinaanleg';

  @override
  String get category_rechtsberatung => 'Juridisch advies';

  @override
  String get category_reparaturdienste => 'Reparatiediensten';

  @override
  String get category_seniorenbetreuung => 'Ouderenzorg';

  @override
  String get category_social_media => 'Social Media beheer';

  @override
  String get category_sonstige => 'Overige diensten';

  @override
  String get category_sprachunterricht => 'Taalonderwijs';

  @override
  String get category_steuerberatung => 'Belastingadvies';

  @override
  String get category_tischler => 'Timmerman';

  @override
  String get category_transport => 'Transport & mobiliteit';

  @override
  String get category_umzugstransporte => 'Verhuisdiensten';

  @override
  String get category_umzugshelfer => 'Verhuishelpers';

  @override
  String get category_uebersetzungen => 'Vertalingen';

  @override
  String get category_waescheservice => 'Wasservice';

  @override
  String get category_webdesign => 'Webdesign';

  @override
  String get category_einkaufsservice => 'Boodschappendienst';

  @override
  String get category_haustierbetreuung => 'Dierenverzorging';

  @override
  String get premiumBadgeLabel => 'Premium';

  @override
  String get statusOffen => 'Open';

  @override
  String get statusInBearbeitung => 'In behandeling';

  @override
  String get statusAbgeschlossen => 'Afgerond';

  @override
  String get privacyButton => 'Privacy';

  @override
  String get interval_weekly => 'Wekelijks';

  @override
  String get interval_biweekly => 'Om de week';

  @override
  String get interval_monthly => 'Maandelijks';

  @override
  String get weekday_monday => 'Maandag';

  @override
  String get weekday_tuesday => 'Dinsdag';

  @override
  String get weekday_wednesday => 'Woensdag';

  @override
  String get weekday_thursday => 'Donderdag';

  @override
  String get weekday_friday => 'Vrijdag';

  @override
  String get weekday_saturday => 'Zaterdag';

  @override
  String get weekday_sunday => 'Zondag';

  @override
  String get kundenInfoBanner => 'U bent aangemeld als klant. Beschrijf welke dienst u nodig heeft. Dienstverleners zullen u vervolgens aanbiedingen doen.';

  @override
  String get titelHint => 'Bijv. woning laten schoonmaken';

  @override
  String get beschreibungHint => 'Beschrijf wat er moet gebeuren – bijv. 3 kamers, keuken, badkamer schoonmaken ...';

  @override
  String get invoiceSectionTitle => 'Factuurgegevens (alleen voor Gold)';

  @override
  String get invoiceNameLabel => 'Factuurnaam (bijv. bedrijfsnaam)';

  @override
  String get invoiceAddressLabel => 'Factuuradres';

  @override
  String get invoiceTaxNumberLabel => 'BTW-nummer (optioneel)';

  @override
  String get invoiceIbanLabel => 'IBAN (optioneel)';

  @override
  String get invoiceLogoUrlLabel => 'Logo-URL (optioneel)';

  @override
  String get invoiceGoldInfo => 'Factuurgegevens zijn alleen bewerkbaar met het GOLD-abonnement.';

  @override
  String get rechnungGenerierenButtonLabel => 'Factuur genereren';

  @override
  String get meineAbgeschlossenenAuftraege => 'Mijn afgeronde opdrachten';

  @override
  String get verbergenButtonLabel => 'Verbergen';

  @override
  String get rechnungGenerierenAppBar => 'Factuur genereren';

  @override
  String get rechnungAlsPdfAnzeigenLabel => 'Factuur als PDF weergeven';

  @override
  String get invoiceLabel => 'Factuur';

  @override
  String get fromLabel => 'Van:';

  @override
  String get taxNumberLabel => 'BTW-nummer:';

  @override
  String get ibanLabel => 'IBAN:';

  @override
  String get toLabel => 'Voor:';

  @override
  String get amountLabel => 'Bedrag:';

  @override
  String get dateLabel => 'Datum:';

  @override
  String get generatedByText => 'Deze factuur is automatisch gegenereerd via AtYourService.';

  @override
  String get currencyLabel => 'Valuta';

  @override
  String get amountRequired => 'Voer een geldig bedrag in.';

  @override
  String get premiumGoldInvoiceFeature => 'Facturering als PDF';

  @override
  String get onlyForGoldTooltip => 'Deze functie is alleen beschikbaar voor Gold-abonnees.';

  @override
  String get deleteJobTooltip => 'Opdracht uit de lijst verwijderen';

  @override
  String get invoiceNumberLabel => 'Factuurnummer';

  @override
  String get invoiceProfileHint => 'Vul je factuurgegevens in bij je profiel. Deze worden automatisch overgenomen in de PDF-factuur.';

  @override
  String get auftragErneutPosten => 'Opdracht opnieuw plaatsen';

  @override
  String get auftragErneutPostenTitle => 'Opdracht opnieuw plaatsen?';

  @override
  String get auftragErneutPostenText => 'De huidige dienstverlener wordt verwijderd. De opdracht wordt weer zichtbaar voor anderen. Wil je doorgaan?';

  @override
  String get auftragErneutGepostet => 'De opdracht is opnieuw geplaatst.';

  @override
  String get premiumActivated => 'Abonnement succesvol geactiveerd!';

  @override
  String premiumPurchaseFailed(Object error) {
    return 'Aankoop mislukt: $error';
  }

  @override
  String get premiumProductNotFound => 'Product niet gevonden!';

  @override
  String get premiumStoreNotLoaded => 'Winkelproducten konden niet worden geladen.';

  @override
  String premiumYearlySuffix(Object price) {
    return 'Jaarlijks: $price';
  }

  @override
  String premiumYearlyButton(Object plan) {
    return '$plan (Jaarlijks)';
  }

  @override
  String get deleteAccountTitle => 'Account verwijderen';

  @override
  String get deleteAccountWarning => 'Weet je zeker dat je je account permanent wilt verwijderen? Al je gegevens worden onherroepelijk verwijderd.';

  @override
  String get deleteAccountButton => 'Account verwijderen';

  @override
  String get accountDeleted => 'Je account is verwijderd.';

  @override
  String get cancel => 'Annuleren';

  @override
  String get premiumDeactivated => 'Premium gedeactiveerd.';

  @override
  String acceptedByLabel(Object name) {
    return 'Geaccepteerd door $name';
  }

  @override
  String get adresseValidator => 'Vul een adres in.';

  @override
  String get abgeschlosseneAuftraegeHinweis => 'Hier kun je voltooide opdrachten verwijderen en je dienstverlener beoordelen.';

  @override
  String get goldBadgeLabel => 'Gold-abonnement';

  @override
  String get silverBadgeLabel => 'Silver-abonnement';

  @override
  String get topBewertetBadgeLabel => 'Top beoordeeld';

  @override
  String get badgeCertified => 'Gecertificeerd';

  @override
  String get badgeExperienced => 'Ervaren';

  @override
  String get badgeExpert => 'Expert';

  @override
  String get badgeMaster => 'Meester';

  @override
  String badgeCertifiedCounter(Object count) {
    return '$count klussen afgerond';
  }

  @override
  String badgeExperiencedCounter(Object count) {
    return '$count klussen afgerond';
  }

  @override
  String badgeExpertCounter(Object count) {
    return '$count klussen afgerond';
  }

  @override
  String badgeMasterCounter(Object count) {
    return '$count klussen afgerond';
  }

  @override
  String get achievementTitle => 'Successen & Badges';

  @override
  String get goldBadgeDesc => 'Je hebt een Gold-abonnement en kunt onbeperkt klussen aannemen.';

  @override
  String get silverBadgeDesc => 'Je hebt een Silver-abonnement en kunt 3 klussen per week aannemen.';

  @override
  String get topBewertetBadgeDesc => 'Behaal een gemiddelde van minimaal 4,5 sterren uit minstens 5 beoordelingen.';

  @override
  String badgeCertifiedProgress(Object count) {
    return 'Gecertificeerd ($count/1)';
  }

  @override
  String get badgeCertifiedDesc => 'Voltooi 3 klussen.';

  @override
  String badgeExperiencedProgress(Object count) {
    return 'Ervaren ($count/2)';
  }

  @override
  String get badgeExperiencedDesc => 'Rond in totaal 10 klussen af.';

  @override
  String badgeExpertProgress(Object count) {
    return 'Expert ($count/3)';
  }

  @override
  String get badgeExpertDesc => 'Rond in totaal 25 klussen af.';

  @override
  String badgeMasterProgress(Object count) {
    return 'Meester ($count/4)';
  }

  @override
  String get badgeMasterDesc => 'Rond in totaal 50 klussen af.';

  @override
  String get trafficScreenInfoText => 'Hier ziet u hoeveel dienstverleners per categorie momenteel actief zijn in uw omgeving. Hoe meer dienstverleners, hoe sneller uw opdracht meestal wordt geaccepteerd.';

  @override
  String get filterAbgeschlossen => 'Afgerond';

  @override
  String get auftraege => 'Opdrachten';

  @override
  String get profil => 'Profiel';

  @override
  String get filterAlle => 'Alles';

  @override
  String get filterOffen => 'Open';

  @override
  String get filterLaufend => 'Lopend';

  @override
  String get forgotPasswordButton => 'Wachtwoord vergeten?';

  @override
  String get forgotPasswordInfo => 'Voer je geregistreerde e-mailadres in. Je ontvangt een link om je wachtwoord te resetten.';

  @override
  String get sendResetLinkButton => 'Reset-link versturen';

  @override
  String get resetMailSent => 'De link is verstuurd. Controleer je inbox!';

  @override
  String get keineDienstleisterInRegion => 'Nog geen dienstverlener gevonden in jouw regio.';

  @override
  String get trafficScreenKeineAdresse => 'Geen adres gevonden in je profiel.';

  @override
  String get trafficScreenAdresseFehler => 'Je adres kon niet worden omgezet in coördinaten.';

  @override
  String get auftragWiederkehrendAppBar => 'Terugkerende opdracht';

  @override
  String get auftragWiederkehrendHeadline => 'Moet deze opdracht regelmatig herhaald worden?';

  @override
  String get auftragWiederkehrendInfo => 'Kies of en hoe vaak de opdracht automatisch moet worden uitgevoerd.';

  @override
  String get auftragReviewAppBar => 'Controleren & verzenden';

  @override
  String get auftragReviewHeadline => 'Alles correct?';

  @override
  String get auftragReviewInfo => 'Controleer je invoer voordat je de opdracht verstuurt.';

  @override
  String get absendenButton => 'Verzenden';

  @override
  String get ja => 'Ja';

  @override
  String get nein => 'Nee';

  @override
  String get wiederholenBisLabelPlain => 'Herhalen tot';

  @override
  String get auftragAdresseAppBar => 'Adres & contact';

  @override
  String get auftragAdresseHeadline => 'Waar moet de opdracht worden uitgevoerd?';

  @override
  String get auftragAdresseInfo => 'Vul het adres en je telefoonnummer in zodat de dienstverlener contact kan opnemen.';

  @override
  String get adresseHint => 'bijv. Voorbeeldstraat 12, 1234 AB Amsterdam';

  @override
  String get telefonnummerHint => 'bijv. 06 12345678';

  @override
  String get zurueckButton => 'Terug';

  @override
  String get weiterButton => 'Volgende';

  @override
  String get auftragKategorieAppBar => 'Categorie kiezen';

  @override
  String get auftragKategorieHeadline => 'Voor welke categorie zoek je hulp?';

  @override
  String get auftragKategorieInfo => 'Kies de juiste dienst. Je kunt later nog details toevoegen.';

  @override
  String get kategorieValidator => 'Selecteer een categorie.';

  @override
  String get auftragDetailsAppBar => 'Opdracht details';

  @override
  String get auftragDetailsHeadline => 'Beschrijf je opdracht';

  @override
  String get auftragDetailsInfo => 'Wat moet er gebeuren? Hoe meer details, hoe beter!';

  @override
  String get auftragTerminAppBar => 'Datum & tijd';

  @override
  String get auftragTerminHeadline => 'Wanneer moet de opdracht worden uitgevoerd?';

  @override
  String get auftragTerminInfo => 'Stel de datum en tijd in of kies \'zo snel mogelijk\'.';

  @override
  String get terminLabel => 'Datum';

  @override
  String get preisLabel => 'Prijs (€) of \'onderhandelbaar\'';

  @override
  String get preisHint => 'bijv. 60 of \'onderhandelbaar\'';

  @override
  String get preisValidator => 'Voer een geldige prijs in of \'onderhandelbaar\'.';

  @override
  String get preisHinweisLabel => 'Prijs-opmerking (optioneel)';

  @override
  String get preisHinweisHint => 'bijv. uurloon, materiaalkosten, onderhandelbaar, enz.';

  @override
  String get preisTypLabel => 'Prijsoptie selecteren';

  @override
  String get preisTypGesamt => 'Totaalprijs';

  @override
  String get preisTypStunden => 'Uurloon';

  @override
  String get preisTypVerhandelbar => 'In overleg / onderhandelbaar';

  @override
  String get preisLabelGesamt => 'Totaalprijs (€)';

  @override
  String get preisHintGesamt => 'bijv. 120';

  @override
  String get preisLabelStunden => 'Uurloon (€ per uur)';

  @override
  String get preisHintStunden => 'bijv. 20';

  @override
  String get preisHinweisVerhandelbar => 'Prijs in overleg / voorstellen welkom';

  @override
  String get preisTypGesamtDesc => 'Je geeft de totale prijs voor de opdracht op.';

  @override
  String get preisTypStundenDesc => 'Je geeft een uurtarief voor de opdracht op.';

  @override
  String get preisTypVerhandelbarDesc => 'De prijs wordt in overleg met de dienstverlener bepaald.';

  @override
  String get heimatadresseButtonInfo => 'Klik hier om je opgeslagen thuisadres automatisch in te vullen.';

  @override
  String get verhandelbarLabel => 'Onderhandelbaar';

  @override
  String get terminValidierungFehler => 'Selecteer een datum en beide tijdstippen.';

  @override
  String get wiederkehrendValidierungFehler => 'Selecteer het interval, de weekdag en het aantal herhalingen correct voor terugkerende taken.';

  @override
  String priceTotal(Object amount) {
    return '$amount €';
  }

  @override
  String pricePerHour(Object amount, Object hourShort) {
    return '$amount € / $hourShort';
  }

  @override
  String get priceNegotiable => 'Onderhandelbaar';

  @override
  String get hourShort => 'u';

  @override
  String get setNewPasswordTitle => 'Nieuw wachtwoord instellen';

  @override
  String get setNewPasswordInfo => 'Voer je nieuwe wachtwoord twee keer in om te bevestigen.';

  @override
  String get newPasswordLabel => 'Nieuw wachtwoord';

  @override
  String get confirmNewPasswordLabel => 'Bevestig nieuw wachtwoord';

  @override
  String get saveNewPasswordButton => 'Nieuw wachtwoord opslaan';

  @override
  String get passwordEmptyError => 'Wachtwoord mag niet leeg zijn.';

  @override
  String get passwordsDontMatch => 'Wachtwoorden komen niet overeen.';

  @override
  String get passwordResetSuccess => 'Wachtwoord succesvol gewijzigd. Je kunt nu inloggen.';

  @override
  String get premiumRestorePurchases => 'Aankopen herstellen';

  @override
  String get premiumRetry => 'Opnieuw proberen';

  @override
  String get wrongRoleCustomer => 'Dit account is geregistreerd als dienstverlener en kan niet worden gebruikt om in te loggen als klant.';

  @override
  String get accountNotRegistered => 'Geen account gevonden met dit e-mailadres. Registreer u eerst.';

  @override
  String get wrongCredentials => 'Onjuist e-mailadres of wachtwoord.';

  @override
  String get premiumPushDelayFree => 'Pushmeldingen: 1 u vertraging';

  @override
  String get premiumPushDelaySilver => 'Pushmeldingen: 30 min vertraging';

  @override
  String get premiumPushDelayGold => 'Pushmeldingen: direct bij nieuwe opdrachten';

  @override
  String get companyNameOptional => 'Bedrijfsnaam (optioneel)';

  @override
  String get vatIdOptional => 'Btw-nummer (optioneel)';

  @override
  String get bicOptional => 'BIC (optioneel)';

  @override
  String get smallBusinessLabel => 'Kleineondernemer volgens §19 UStG';

  @override
  String get defaultVatRateLabel => 'Standaard btw-tarief (%)';

  @override
  String get invalidVatRate => 'Ongeldig btw-tarief';

  @override
  String get profileNameLabel => 'Volledige naam';

  @override
  String get invoiceNoShort => 'Nr:';

  @override
  String get netAmountLabel => 'Netto';

  @override
  String vatLabelWithPercent(Object percent) {
    return 'Btw ($percent%)';
  }

  @override
  String get totalLabel => 'Totaal';

  @override
  String get dueOnLabel => 'Vervaldatum:';

  @override
  String get vatIdLabel => 'Btw-nr.:';

  @override
  String get bicLabel => 'BIC:';

  @override
  String paymentTermsDefault(Object days) {
    return 'Betaalbaar binnen $days dagen zonder aftrek.';
  }

  @override
  String get badgeInfoText => 'Deze badges kunnen alleen door dienstverleners worden behaald en verschijnen wanneer de dienstverlener de opdracht accepteert.';

  @override
  String get noAuftraegeKundeHint => 'Maak je eerste opdracht aan door op de plusknop (+) te tikken.';

  @override
  String get upsellCardTitle => 'Opdracht bij jou in de buurt';

  @override
  String upsellCategoryLabel(String category) {
    return 'Categorie: $category';
  }

  @override
  String upsellUpgradeButton(String plan) {
    return 'Upgrade naar $plan om deze opdracht te zien';
  }

  @override
  String get planFree => 'Gratis';

  @override
  String get planSilver => 'Zilver';

  @override
  String get planGold => 'Goud';

  @override
  String get filterNeu => 'Nieuw';

  @override
  String onlyNewWindowInfo(int hours) {
    return 'Toont opdrachten van de laatste $hours uur.';
  }

  @override
  String get cancelLabel => 'Annuleren';

  @override
  String get editProfileCta => 'Profiel voltooien';

  @override
  String get update_required_title => 'Update vereist';

  @override
  String get update_required_message => 'Werk de app bij om verder te gaan.';

  @override
  String get update_available_title => 'Update beschikbaar';

  @override
  String get update_available_message => 'Er is een nieuwe versie beschikbaar. Nu updaten?';

  @override
  String get update_action_update_now => 'Nu updaten';

  @override
  String get update_action_later => 'Later';

  @override
  String get invoiceSectionSubtitle => 'Optioneel: bedrijfs- en btw-gegevens voor automatische facturatie';

  @override
  String get marketplaceTitle => 'Opdrachten verhandelen';

  @override
  String get marketplaceTabSell => 'Verkopen';

  @override
  String get marketplaceTabBuy => 'Kopen';

  @override
  String get marketplaceOfferCreateCta => 'Opdracht doorgeven';

  @override
  String get marketplaceFilter => 'Filter';

  @override
  String get marketplaceSort => 'Sorteren';

  @override
  String get marketplaceBuyNow => 'Nu aanmelden';

  @override
  String get marketplaceSnackOpenForm => 'Formulier openen…';

  @override
  String get marketplaceSnackStartCheckout => 'Afrekenproces starten…';

  @override
  String marketplaceOfferTitle(int index) {
    return 'Aanbod #$index';
  }

  @override
  String marketplaceOfferSubtitle(String category, String price, Object distanceKm) {
    return '$category • $distanceKm km';
  }

  @override
  String marketplaceBuyTitle(int index) {
    return 'Advertentie #$index · Kleine reparatie';
  }

  @override
  String marketplaceBuySubtitle(String category, String price, String distance) {
    return 'Categorie: $category · $price/u · $distance km';
  }

  @override
  String get marketplaceEmptyList => 'Geen passende aanbiedingen gevonden.';

  @override
  String get marketplaceErrorLoading => 'Lijst kon niet worden geladen.';

  @override
  String get marketplaceAppliedSuccess => 'Aangemeld — de verkoper kan je aanvraag zien.';

  @override
  String get marketplaceAlreadyApplied => 'Je hebt je al aangemeld.';

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
    return 'Doelprijs: $price';
  }

  @override
  String marketplaceChipProvision(Object value) {
    return 'Commissie: $value';
  }

  @override
  String get s0Title => 'Opdracht doorgeven (S0)';

  @override
  String get sectionBasics => 'Basis';

  @override
  String get fieldTitle => 'Titel';

  @override
  String get hintTitleExample => 'bijv. Dakrenovatie EHF, 120 m²';

  @override
  String get fieldDescription => 'Beschrijving';

  @override
  String get hintDescription => 'Korte beschrijving, bijzonderheden, materiaal incl./excl.';

  @override
  String get fieldLocation => 'Locatie/radius (voor nu tekst)';

  @override
  String get hintLocation => 'bijv. Keulen, 15 km';

  @override
  String get pickStartDate => 'Startdatum kiezen';

  @override
  String get pickDeadline => 'Deadline kiezen';

  @override
  String get labelStart => 'Start';

  @override
  String get labelDeadline => 'Deadline';

  @override
  String get sectionS0PriceProvision => 'S0 – Prijs & Provisie';

  @override
  String get tooltipS0PriceProvision => 'Doelprijs = totale prijs van de opdracht.\nProvisie = vergoeding voor het doorgeven.';

  @override
  String get fieldTargetPriceEur => 'Doelprijs (EUR)';

  @override
  String get hintTargetPriceExample => 'bijv. 12.500';

  @override
  String get helpTargetPrice => 'Totale waarde die de koper overneemt.';

  @override
  String get fieldProvisionType => 'Provisietype';

  @override
  String get provisionTypePercent => 'Procent';

  @override
  String get provisionTypeFixed => 'Vast';

  @override
  String get fieldProvisionValuePercent => 'Provisiewaarde (%)';

  @override
  String get fieldProvisionValueFixed => 'Provisiewaarde (€)';

  @override
  String get helpProvisionPercent => 'Gebruikelijk: 5–12% (cap mogelijk).';

  @override
  String get helpProvisionFixed => 'Vast provisiebedrag.';

  @override
  String get fieldProvisionDue => 'Wanneer is de provisie verschuldigd?';

  @override
  String get provisionDueAward => 'bij toekenning';

  @override
  String get provisionDueHandover => 'bij overdracht';

  @override
  String get provisionDueFinalInvoice => 'bij eindfactuur';

  @override
  String get provisionDueAwardHelp => 'Bij toekenning: de provisie wordt direct na de toekenning verschuldigd.';

  @override
  String get provisionDueHandoverHelp => 'Bij overdracht: na akkoord klant & overdracht.';

  @override
  String get provisionDueFinalInvoiceHelp => 'Bij eindfactuur: wanneer koper de opdracht voltooit.';

  @override
  String get sectionEvidencePlaceholder => 'Bewijzen (placeholder)';

  @override
  String get btnUploadEvidence => 'Offerte/klant-OK uploaden';

  @override
  String get btnCreateDraft => 'Concept aanmaken';

  @override
  String get btnSaving => 'Opslaan…';

  @override
  String get noteSupabaseActive => 'Let op: Supabase-opslag actief. Betalingen & uploads volgen.';

  @override
  String get formErrorRequired => 'Verplicht';

  @override
  String get formErrorInvalidAmount => 'Ongeldig bedrag';

  @override
  String get formErrorGreaterZero => 'Moet > 0 zijn';

  @override
  String get formErrorRealistic => 'Graag realistisch blijven';

  @override
  String get formErrorInvalidValue => 'Ongeldige waarde';

  @override
  String get formErrorPercentRange => 'Toegestaan: 0–30%';

  @override
  String get errPickStartDate => 'Kies een startdatum';

  @override
  String get errPickDeadline => 'Kies een deadline';

  @override
  String get draftSaved => 'S0-concept opgeslagen.';

  @override
  String get genericError => 'Er ging iets mis.';

  @override
  String get btnMyDeals => 'Mijn deals';

  @override
  String get myDealsTitle => 'Mijn deals';

  @override
  String get myDealsEmpty => 'Nog geen opdrachten.';

  @override
  String get myDealsErrorLoading => 'Je opdrachten konden niet worden geladen.';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterDraft => 'Concepten';

  @override
  String get filterLive => 'Live';

  @override
  String get filterAwarded => 'Gegund';

  @override
  String get manageTitle => 'Opdracht beheren';

  @override
  String get manageErrorLoading => 'Details konden niet worden geladen.';

  @override
  String get btnPublish => 'Publiceren';

  @override
  String get publishSuccess => 'Opdracht gepubliceerd.';

  @override
  String get applicationsTitle => 'Aanmeldingen';

  @override
  String get applicationsEmpty => 'Nog geen aanmeldingen.';

  @override
  String get applicationNote => 'Notitie';

  @override
  String get applicationStatusPending => 'Status: in behandeling';

  @override
  String get applicationStatusAwarded => 'Status: gegund';

  @override
  String get btnAward => 'Gunnen';

  @override
  String get btnManage => 'Beheren';

  @override
  String get labelStatus => 'Status';

  @override
  String get statusDraft => 'Concept';

  @override
  String get statusLive => 'Live';

  @override
  String get statusAwarded => 'Gegund';

  @override
  String get awardSuccess => 'Aanmelding succesvol gegund.';

  @override
  String get snackNewApplication => 'Nieuwe aanmelding ontvangen';

  @override
  String applicationsCount(Object count) {
    return '$count aanvragen';
  }

  @override
  String get btnApplied => 'Aangemeld';

  @override
  String get s0EditTitle => 'S0 bewerken';

  @override
  String get publishNow => 'Na opslaan publiceren';

  @override
  String get publishNowHint => 'Indien ingeschakeld, wordt het concept na het opslaan op \"Live\" gezet.';

  @override
  String get btnSaveChanges => 'Wijzigingen opslaan';

  @override
  String get saved => 'Opgeslagen';

  @override
  String get marketplaceLocationLoadedFromProfile => 'Locatie uit je profiel geladen — radiusfilter actief.';

  @override
  String get marketplaceNoHomeAddressHint => 'Geen adres in profiel — alle aanbiedingen zonder afstandsfilter.';

  @override
  String get fieldCategory => 'Categorie';

  @override
  String get categoryAll => 'Alle';

  @override
  String get categoryRoofer => 'Dakdekker';

  @override
  String get categorySolar => 'PV / Zonne-energie';

  @override
  String get categoryHVAC => 'Verwarming / Sanitair / HVAC';

  @override
  String get categoryElectrical => 'Elektricien';

  @override
  String get categoryDrywall => 'Gipsplaten / Afbouw';

  @override
  String get categoryPainter => 'Schilder';

  @override
  String get categoryTiling => 'Tegels zetten';

  @override
  String get categoryFlooring => 'Vloerleggen';

  @override
  String get categoryWindowsDoors => 'Ramen & Deuren';

  @override
  String get categoryInsulationFacade => 'Isolatie & Gevel';

  @override
  String get categoryMasonryConcrete => 'Metsel- & Betonwerk';

  @override
  String get categoryCarpentryJoinery => 'Timmerwerk & Meubelmakerij';

  @override
  String get categoryLandscaping => 'Tuin- & Landschapsbouw';

  @override
  String get categoryScaffolding => 'Steigerbouw';

  @override
  String get categoryCleaningRestoration => 'Reiniging & Restauratie';

  @override
  String get categoryMovingTransport => 'Verhuizen & Transport';

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
  String get genericPleaseFix => 'Corrigeer de gemarkeerde velden:';

  @override
  String get errAwardNeedsDoc => 'Als de vervaldag \"bij gunning\" is, is een document/offerte vereist.';

  @override
  String get errNotOwner => 'Je bent niet de eigenaar van deze opdracht.';

  @override
  String get errPublishOnlyFromDraft => 'Publiceren kan alleen vanuit de conceptstatus.';

  @override
  String get publishRequirementsTitle => 'Vereisten om te publiceren';

  @override
  String get infoReqCustomerOk => 'Minstens één klanttoestemming is toegevoegd.';

  @override
  String get infoReqDocForAward => 'Voor \"bij gunning\": upload offerte/orderbevestiging.';

  @override
  String get infoReqAttest => 'De bevestiging in het formulier is aangevinkt.';

  @override
  String get draftChecklistTitle => 'Checklist vóór publiceren';

  @override
  String get chkTitle => 'Titel ingevuld';

  @override
  String get chkDescription => 'Beschrijving ingevuld';

  @override
  String get chkLocation => 'Adres/locatie ingesteld';

  @override
  String get chkTargetPrice => 'Doelprijs ingesteld';

  @override
  String get chkCustomerOk => 'Klanttoestemming aanwezig';

  @override
  String get chkDocIfAward => 'Document/offerte aanwezig (aanbevolen bij \"bij gunning\")';

  @override
  String get chkAttestAtPublish => 'Bevestiging aanvinken bij publiceren';

  @override
  String get draftChecklistCta => 'Beheer openen';

  @override
  String get uploadSuccess => 'Upload geslaagd.';

  @override
  String get uploadInProgress => 'Upload bezig...';

  @override
  String get uploadFailed => 'Upload mislukt.';

  @override
  String get draftDefaultTitle => 'Concept';

  @override
  String get errGeocodingFailed => 'Adres kon niet worden gegeocodeerd.';

  @override
  String get provisionDueAwardLabel => 'Beauftragung';

  @override
  String get provisionDueHandoverLabel => 'Overdracht';

  @override
  String get provisionDueFinalInvoiceLabel => 'Eindfactuur';

  @override
  String get sectionPreviewPublic => 'Preview (publiek)';

  @override
  String get tooltipPreviewPublic => 'Deze bestanden zijn zichtbaar vóór aankoop. Upload alleen geanonimiseerde/zwartgemaakte previews.';

  @override
  String get btnUploadPreview => 'Preview uploaden';

  @override
  String get previewRedactionNoticeTitle => 'Belangrijke preview-melding';

  @override
  String get previewRedactionNoticeBody => 'Previews zijn vóór aankoop zichtbaar voor kopers. Zwartmaak gevoelige gegevens (bv. namen, adressen, telefoonnummers, contract-/klantnrs., handtekeningen, QR-/barcodes). Upload geen documenten met onbewerkte persoonsgegevens.';

  @override
  String get hintPhoneExample => '+31 6 12345678';

  @override
  String get createDealTitle => 'Handel aanmaken';

  @override
  String get chooseDealTypeTitle => 'Kies handelstype';

  @override
  String get dealTypeS0Title => 'S0 – Doorverkoop';

  @override
  String get dealTypeS0Subtitle => 'Volledige opdracht doorverkopen aan een andere dienstverlener.';

  @override
  String get dealTypeS1Title => 'S1 – Deeltaak/onderaannemer (mijlpalen)';

  @override
  String get dealTypeS1Subtitle => 'Onderopdracht met mijlpalen en bewijsstukken.';

  @override
  String get s1Title => 'Onder­aannemers zoeken (S1)';

  @override
  String get sectionS1Pricing => 'Prijsstelling';

  @override
  String get sectionS1Provision => 'Provisie';

  @override
  String get sectionMilestones => 'Mijlpalen';

  @override
  String get pricingModeFixed => 'Vaste prijs';

  @override
  String get pricingModeTm => 'Uren & Materiaal';

  @override
  String get basePriceLabel => 'Totaalbudget (€)';

  @override
  String get hourlyRateLabel => 'Uurtarief (€)';

  @override
  String get expectedHoursLabel => 'Geschatte uren';

  @override
  String get dueTypeAward => 'Beauftragung';

  @override
  String get dueTypeDate => 'Datum';

  @override
  String get dueTypeHandover => 'Overdracht';

  @override
  String get dueTypeCustom => 'Aangepast';

  @override
  String get dueTypeCustomHelp => 'Aangepaste vervaldatum (graag datum/opmerking toevoegen).';

  @override
  String get milestoneLabel => 'Mijlpaal';

  @override
  String get milestoneTitle => 'Titel van mijlpaal';

  @override
  String get milestoneDescription => 'Beschrijving van mijlpaal';

  @override
  String get milestoneAmount => 'Bedrag (€)';

  @override
  String get milestonePercent => 'Percentage (%)';

  @override
  String get milestoneDue => 'Vervaldatum';

  @override
  String get btnAddMilestonePercent => 'Mijlpaal (%) toevoegen';

  @override
  String get btnAddMilestoneAmount => 'Mijlpaal (€) toevoegen';

  @override
  String get milestoneEmptyHint => 'Nog geen mijlpalen (optioneel).';

  @override
  String get milestoneBlocking => 'Blokkerend';

  @override
  String get milestoneBlockingHelp => 'Moet voltooid zijn voordat de volgende stap vrijgegeven wordt.';

  @override
  String get validationMilestoneSum => 'Totalen kloppen niet: bij percentage moet het 100% zijn; bij vaste prijs moet het totaal gelijk zijn aan het budget.';

  @override
  String get btnReorder => 'Volgorde wijzigen';

  @override
  String get infoS1PricingHelp => 'Hoe je het werk voor onderaannemers prijst. ‘Vaste prijs’ = één totaalbudget voor het werk. ‘Uren & materiaal’ = uurtarief + geschatte uren; afrekening op werkelijk bestede tijd.';

  @override
  String get infoS1ProvisionHelp => 'Jouw provisie per toegewezen onderaannemer. Stel een percentage of vast bedrag én het betaalmoment in.';

  @override
  String get coordChipNoCoords => 'Geen coördinaten';

  @override
  String get coordMissingLabel => 'Coördinaten (lat/lng)';

  @override
  String get s0DetailsMissingLabel => 'S0-details';

  @override
  String get s1DetailsMissingLabel => 'S1-details';

  @override
  String get marketplaceTypeS0 => 'S0 – Opdracht doorgeven';

  @override
  String get marketplaceTypeS1 => 'S1 – Subzoek';

  @override
  String get filterTypeAll => 'Alle types';

  @override
  String get filterTypeS0 => 'Alleen S0';

  @override
  String get filterTypeS1 => 'Alleen S1';

  @override
  String get badgeAwardedToYou => 'Aan jou toegewezen';

  @override
  String get badgeAwardedGiven => 'Opdracht toegewezen';

  @override
  String get btnAssigned => 'Toegewezen';

  @override
  String get marketplaceOwnDealPill => 'Jouw opdracht';
}
