// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get registerAppBar => 'Registrazione';

  @override
  String get registerTitle => 'Registrati';

  @override
  String get roleLabel => 'Seleziona ruolo';

  @override
  String get roleKunde => 'Cliente';

  @override
  String get roleDienstleister => 'Fornitore di servizi';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get categoryValidator => 'Seleziona una categoria';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailEmpty => 'Inserisci l\'e-mail';

  @override
  String get emailInvalid => 'Inserisci un\'e-mail valida';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordEmpty => 'Inserisci la password';

  @override
  String get passwordTooShort => 'La password deve contenere almeno 8 caratteri.';

  @override
  String get registerButton => 'Registrati';

  @override
  String get registerSuccess => 'Registrazione avvenuta con successo! Conferma la tua e-mail.';

  @override
  String get registerExists => 'Questa e-mail è già registrata. Effettua il login o reimposta la password.';

  @override
  String get registerInvalidEmail => 'Inserisci un indirizzo e-mail valido.';

  @override
  String get registerPasswordShort => 'La password deve contenere almeno 6 caratteri.';

  @override
  String registerFailed(Object error) {
    return 'Registrazione non riuscita: $error';
  }

  @override
  String registerUnknownError(Object error) {
    return 'Errore sconosciuto: $error';
  }

  @override
  String get profileAppBar => 'Profilo fornitore';

  @override
  String get profileAddressLabel => 'Indirizzo di casa (es. Via Esempio 12, 12345 Città)';

  @override
  String get profileAddressEmpty => 'Inserisci l\'indirizzo';

  @override
  String get profileSaveButton => 'Salva profilo';

  @override
  String get profileAddressSaved => 'Indirizzo salvato!';

  @override
  String profileLoadError(Object error) {
    return 'Errore durante il caricamento: $error';
  }

  @override
  String profileSaveError(Object error) {
    return 'Errore durante il salvataggio: $error';
  }

  @override
  String get notLoggedIn => 'Non sei loggato';

  @override
  String get pleaseLogin => 'Effettua prima il login';

  @override
  String get changeNotAllowedTitle => 'Modifica non consentita';

  @override
  String changeNotAllowedContent(Object date) {
    return 'Come utente gratuito puoi cambiare categoria o indirizzo solo ogni 20 giorni.\nProssima modifica possibile dal: $date';
  }

  @override
  String get ok => 'OK';

  @override
  String get profileSaved => 'Profilo salvato con successo!';

  @override
  String get changeProfileImage => 'Cambia immagine profilo';

  @override
  String get upgradeToPremium => 'Passa a Premium';

  @override
  String get noRatingsYet => 'Nessuna valutazione ancora';

  @override
  String get nameLabel => 'Nome';

  @override
  String get nameValidator => 'Inserisci il nome';

  @override
  String get descriptionLabel => 'Descrizione del servizio:';

  @override
  String get addressLabel => 'Indirizzo (es. Via, CAP, Città)';

  @override
  String get phoneLabel => 'Telefono';

  @override
  String get phoneValidator => 'Inserisci il numero di telefono';

  @override
  String get emailEmptyValidator => 'Inserisci l\'e-mail';

  @override
  String get emailInvalidValidator => 'Inserisci un\'e-mail valida';

  @override
  String errorPrefix(Object error) {
    return 'Errore: $error';
  }

  @override
  String changeLimitHint(Object date) {
    return 'Categoria/indirizzo modificabili solo dal $date.';
  }

  @override
  String get addressNotFound => 'Indirizzo non trovato. Controlla per favore.';

  @override
  String ratingsCount(Object count) {
    return '($count valutazioni)';
  }

  @override
  String get premiumAppBar => 'Passa a Premium';

  @override
  String get premiumChoosePlan => 'Scegli il tuo piano Premium';

  @override
  String get premiumCurrentPlan => 'Abbonamento attuale:';

  @override
  String get premiumFreePrice => 'gratuito';

  @override
  String get premiumSilverPrice => '€4.99 / month';

  @override
  String get premiumGoldPrice => '€9.99 / month';

  @override
  String get premiumFreeFeature1 => '1 incarico a settimana';

  @override
  String get premiumFreeFeature2 => 'Incarichi nel raggio di 5 km';

  @override
  String get premiumFreeFeature3 => 'Solo categorie base';

  @override
  String get premiumFreeFeature4 => 'Cambio categoria solo ogni 20 giorni';

  @override
  String get premiumSilverFeature1 => '2 incarichi a settimana';

  @override
  String get premiumSilverFeature2 => 'Incarichi nel raggio di 15 km';

  @override
  String get premiumSilverFeature3 => 'Tutte le categorie disponibili';

  @override
  String get premiumGoldFeature1 => '5 incarichi a settimana';

  @override
  String get premiumGoldFeature2 => 'Incarichi nel raggio di 30 km';

  @override
  String get premiumGoldFeature3 => 'Tutte le categorie disponibili';

  @override
  String get premiumGoldFeature4 => 'Badge Premium (visibile ai clienti)';

  @override
  String premiumChooseButton(Object title) {
    return 'Scegli $title';
  }

  @override
  String get premiumPaymentNote => 'Nota: tutti i pagamenti sono gestiti in sicurezza tramite Apple o Google. Puoi cancellare o gestire il tuo abbonamento in qualsiasi momento tramite lo store.';

  @override
  String get premiumSilverComingSoon => 'Silver in arrivo!';

  @override
  String get premiumGoldComingSoon => 'Gold in arrivo!';

  @override
  String get auftragHidden => 'Incarico nascosto.';

  @override
  String auftragHideError(Object error) {
    return 'Errore durante la rimozione: $error';
  }

  @override
  String get meineAuftraegeAppBar => 'I miei incarichi';

  @override
  String get refreshTooltip => 'Aggiorna';

  @override
  String get noAuftraegeFound => 'Nessun incarico trovato.';

  @override
  String get geplanterAuftrag => 'Incarico programmato';

  @override
  String get auftragAusblenden => 'Nascondi incarico';

  @override
  String get loginFailedDetails => 'Login non riuscito. Controlla i tuoi dati o conferma la tua e-mail.';

  @override
  String get loginSuccess => 'Login avvenuto con successo!';

  @override
  String loginFailedPrefix(Object error) {
    return 'Login non riuscito: $error';
  }

  @override
  String loginUnknownError(Object error) {
    return 'Errore sconosciuto: $error';
  }

  @override
  String get emailValidatorEmpty => 'Inserisci l\'e-mail';

  @override
  String get emailValidatorInvalid => 'Inserisci un\'e-mail valida';

  @override
  String get passwordValidatorEmpty => 'Inserisci la password';

  @override
  String get passwordValidatorShort => 'La password deve contenere almeno 6 caratteri';

  @override
  String get loginKundeAppBar => 'Login clienti';

  @override
  String get loginKundeHeadline => 'Accedi';

  @override
  String get loginButton => 'Login';

  @override
  String get noAccountYet => 'Non hai ancora un account? Registrati ora';

  @override
  String get loginFailedDetailsDL => 'Login non riuscito. Controlla i tuoi dati o conferma la tua e-mail.';

  @override
  String get wrongRoleDL => 'Questo account non è un fornitore di servizi. Usa il login clienti.';

  @override
  String get loginDLAppBar => 'Login fornitori';

  @override
  String get loginDLHeadline => 'Accedi';

  @override
  String get kundenDashboardHeader => 'La tua dashboard';

  @override
  String get kundenDashboardAppBar => 'Dashboard clienti';

  @override
  String get laufendeAuftraege => 'Incarichi in corso';

  @override
  String statusPrefix(Object status) {
    return 'Stato: $status';
  }

  @override
  String dienstleisterPrefix(Object dienstleister) {
    return 'Fornitore: $dienstleister';
  }

  @override
  String get offeneAuftraege => 'Incarichi aperti';

  @override
  String get noOffeneAuftraege => 'Nessun incarico aperto trovato.';

  @override
  String get abgeschlosseneAuftraege => 'Incarichi conclusi';

  @override
  String get abgeschlossenStatus => 'Concluso';

  @override
  String get neuerAuftrag => 'Nuovo incarico';

  @override
  String get pleaseCreateProfile => 'Crea prima il tuo profilo.';

  @override
  String get profilMissingCategory => 'Categoria mancante nel profilo.';

  @override
  String get dienstleisterDashboardHeader => 'La tua dashboard';

  @override
  String get dienstleisterDashboardAppBar => 'Dashboard fornitori';

  @override
  String get meineLaufendenAuftraege => 'I miei incarichi in corso';

  @override
  String kundePrefix(Object kunde) {
    return 'Cliente: $kunde';
  }

  @override
  String get offenePassendeAuftraege => 'Incarichi aperti e adatti';

  @override
  String get noPassendeAuftraege => 'Nessun incarico adatto trovato.';

  @override
  String entfernungSuffix(Object dist) {
    return '$dist km di distanza';
  }

  @override
  String get auftragBereitsBewertet => 'Hai già valutato questo incarico.';

  @override
  String get bewertungDialogTitle => 'Valuta il fornitore';

  @override
  String get bewertungKommentarLabel => 'Commento (opzionale)';

  @override
  String get abbrechen => 'Annulla';

  @override
  String get abschicken => 'Invia';

  @override
  String get auftragErstellenTitle => 'Crea nuovo incarico';

  @override
  String get auftragEinstellenUeberschrift => 'Pubblica incarico ora';

  @override
  String get titelLabel => 'Titolo';

  @override
  String get titelValidator => 'Inserisci il titolo';

  @override
  String get beschreibungLabel => 'Descrizione';

  @override
  String get kategorieLabel => 'Categoria';

  @override
  String get heimatadresseEinfuegen => 'Inserisci indirizzo di casa';

  @override
  String get adresseLabel => 'Indirizzo (es. Via Esempio 76, 00100 Roma)';

  @override
  String get telefonnummerLabel => 'Numero di telefono';

  @override
  String get telefonnummerValidator => 'Inserisci il numero di telefono';

  @override
  String get ausfuehrungszeitpunkt => 'Quando eseguire';

  @override
  String get soSchnellWieMoeglich => 'Il prima possibile';

  @override
  String get geplant => 'Programmato';

  @override
  String get datumWaehlen => 'Scegli la data';

  @override
  String get zeitVon => 'Dalle';

  @override
  String get zeitBis => 'Alle';

  @override
  String get wiederkehrendCheckbox => 'Incarico ricorrente?';

  @override
  String get intervallLabel => 'Intervallo';

  @override
  String get intervallValidator => 'Scegli un intervallo';

  @override
  String get wochentagLabel => 'Giorno della settimana';

  @override
  String get wochentagValidator => 'Scegli un giorno';

  @override
  String get anzahlWiederholungenLabel => 'Numero ripetizioni (opzionale)';

  @override
  String get wiederholenBisNichtGesetzt => 'Ripetere fino a: non impostato';

  @override
  String wiederholenBisLabel(Object date) {
    return 'Ripetere fino a: $date';
  }

  @override
  String get auftragAbschicken => 'Invia incarico';

  @override
  String get auftragGespeichert => 'Incarico salvato!';

  @override
  String get bitteEinloggen => 'Effettua prima il login';

  @override
  String get adresseNichtGefunden => 'Indirizzo non trovato.';

  @override
  String unbekannterFehler(Object error) {
    return 'Errore sconosciuto: $error';
  }

  @override
  String get auftragDetailTitle => 'Dettagli incarico';

  @override
  String get nichtEingeloggt => 'Non sei loggato';

  @override
  String get rolleNichtErmittelt => 'Ruolo non identificato';

  @override
  String get auftragNichtGefunden => 'Incarico non trovato';

  @override
  String get bewertungDanke => 'Grazie per la tua valutazione!';

  @override
  String get limitErreicht => 'Limite raggiunto';

  @override
  String get limitFree => 'Come fornitore gratuito puoi accettare al massimo 2 incarichi a settimana. Passa a Silver o Gold per più opportunità!';

  @override
  String get limitSilver => 'Come fornitore Silver puoi accettare al massimo 5 incarichi a settimana. Passa a Gold per incarichi illimitati!';

  @override
  String get auftragAnnehmen => 'Accetta incarico';

  @override
  String get auftragBeenden => 'Completa incarico';

  @override
  String get auftragEntfernenUebersicht => 'Rimuovi incarico dalla panoramica';

  @override
  String get auftragEntfernen => 'Rimuovi incarico';

  @override
  String get auftragEntfernenTitel => 'Rimuovere incarico?';

  @override
  String get auftragEntfernenText => 'Vuoi rimuovere questo incarico dalla tua panoramica?';

  @override
  String get entfernen => 'Rimuovi';

  @override
  String get keineDatenVerfuegbar => 'Nessun dato disponibile';

  @override
  String get beschreibung => 'Descrizione:';

  @override
  String get kategorie => 'Categoria:';

  @override
  String get adresse => 'Indirizzo:';

  @override
  String get status => 'Stato:';

  @override
  String jedenWochentag(Object wochentag) {
    return 'Ogni $wochentag';
  }

  @override
  String bisDatum(Object datum) {
    return 'fino al $datum';
  }

  @override
  String get malSuffix => 'volte';

  @override
  String kontaktZuLabel(Object label) {
    return 'Contatto con $label:';
  }

  @override
  String get nummerKopiert => 'Numero copiato!';

  @override
  String get nummerKopieren => 'Copia numero';

  @override
  String get anrufen => 'Chiama';

  @override
  String fehlerPrefix(Object error) {
    return 'Errore: $error';
  }

  @override
  String get editProfileTooltip => 'Modifica profilo';

  @override
  String get appTitle => 'AtYourService';

  @override
  String get hello => 'Benvenuto!';

  @override
  String get kundeButton => 'Cerco un fornitore di servizi';

  @override
  String get dienstleisterButton => 'Sono un fornitore di servizi';

  @override
  String get category_babysitter => 'Baby-sitter / Assistenza bambini';

  @override
  String get category_catering => 'Catering';

  @override
  String get category_dachdecker => 'Copritetto';

  @override
  String get category_elektriker => 'Elettricista';

  @override
  String get category_ernaehrungsberatung => 'Consulenza nutrizionale';

  @override
  String get category_eventplanung => 'Organizzazione eventi';

  @override
  String get category_fahrdienste => 'Servizi di trasporto';

  @override
  String get category_fahrlehrer => 'Istruttore di guida';

  @override
  String get category_fensterputzer => 'Lavavetri';

  @override
  String get category_fliesenleger => 'Posatore di piastrelle';

  @override
  String get category_fotografie => 'Fotografia / Videografia';

  @override
  String get category_friseur => 'Parrucchiere/a';

  @override
  String get category_gartenpflege => 'Cura del giardino / Taglio erba';

  @override
  String get category_grafikdesign => 'Graphic Design';

  @override
  String get category_handy_reparatur => 'Riparazione smartphone/tablet';

  @override
  String get category_haushaltsreinigung => 'Pulizia domestica';

  @override
  String get category_hausmeisterservice => 'Servizio custode';

  @override
  String get category_heizungsbauer => 'Tecnico riscaldamento';

  @override
  String get category_hundesitter => 'Dog-sitter / Passeggiate';

  @override
  String get category_it_support => 'Assistenza IT';

  @override
  String get category_klempner => 'Idraulico';

  @override
  String get category_kosmetik => 'Estetista';

  @override
  String get category_kuenstler => 'Artista (es. musicisti per eventi)';

  @override
  String get category_kurierdienst => 'Corriere';

  @override
  String get category_maler => 'Imbianchino';

  @override
  String get category_massagen => 'Massaggi';

  @override
  String get category_maurer => 'Muratore';

  @override
  String get category_moebelaufbau => 'Montaggio mobili';

  @override
  String get category_musikunterricht => 'Lezioni di musica';

  @override
  String get category_nachhilfe => 'Ripetizioni';

  @override
  String get category_nagelstudio => 'Centro unghie';

  @override
  String get category_pc_reparatur => 'Riparazione PC/Laptop';

  @override
  String get category_partyservice => 'Servizio feste';

  @override
  String get category_personal_trainer => 'Personal Trainer';

  @override
  String get category_rasenmaeher_service => 'Cura del giardino / Paesaggistica';

  @override
  String get category_rechtsberatung => 'Consulenza legale';

  @override
  String get category_reparaturdienste => 'Servizi di riparazione';

  @override
  String get category_seniorenbetreuung => 'Assistenza anziani';

  @override
  String get category_social_media => 'Gestione social media';

  @override
  String get category_sonstige => 'Altri servizi';

  @override
  String get category_sprachunterricht => 'Lezioni di lingua';

  @override
  String get category_steuerberatung => 'Consulenza fiscale';

  @override
  String get category_tischler => 'Falegname';

  @override
  String get category_transport => 'Trasporti & Mobilità';

  @override
  String get category_umzugstransporte => 'Traslochi';

  @override
  String get category_umzugshelfer => 'Aiuto trasloco';

  @override
  String get category_uebersetzungen => 'Traduzioni';

  @override
  String get category_waescheservice => 'Servizio lavanderia';

  @override
  String get category_webdesign => 'Web design';

  @override
  String get category_einkaufsservice => 'Servizio spesa';

  @override
  String get category_haustierbetreuung => 'Assistenza animali';

  @override
  String get premiumBadgeLabel => 'Premium';

  @override
  String get statusOffen => 'Aperto';

  @override
  String get statusInBearbeitung => 'In lavorazione';

  @override
  String get statusAbgeschlossen => 'Completato';

  @override
  String get privacyButton => 'Privacy';

  @override
  String get interval_weekly => 'Settimanale';

  @override
  String get interval_biweekly => 'Ogni 2 settimane';

  @override
  String get interval_monthly => 'Mensile';

  @override
  String get weekday_monday => 'Lunedì';

  @override
  String get weekday_tuesday => 'Martedì';

  @override
  String get weekday_wednesday => 'Mercoledì';

  @override
  String get weekday_thursday => 'Giovedì';

  @override
  String get weekday_friday => 'Venerdì';

  @override
  String get weekday_saturday => 'Sabato';

  @override
  String get weekday_sunday => 'Domenica';

  @override
  String get kundenInfoBanner => 'Sei registrato come cliente. Descrivi qui il servizio di cui hai bisogno. I fornitori ti invieranno offerte.';

  @override
  String get titelHint => 'es. Pulizia appartamento';

  @override
  String get beschreibungHint => 'Descrivi cosa deve essere fatto – es. pulire 3 stanze, cucina, bagno ...';

  @override
  String get invoiceSectionTitle => 'Dati fattura (solo per Gold)';

  @override
  String get invoiceNameLabel => 'Nome fattura (es. nome azienda)';

  @override
  String get invoiceAddressLabel => 'Indirizzo di fatturazione:';

  @override
  String get invoiceTaxNumberLabel => 'Partita IVA (opzionale)';

  @override
  String get invoiceIbanLabel => 'IBAN (opzionale)';

  @override
  String get invoiceLogoUrlLabel => 'Logo URL (opzionale)';

  @override
  String get invoiceGoldInfo => 'I dati di fatturazione sono modificabili solo con l’abbonamento GOLD.';

  @override
  String get rechnungGenerierenButtonLabel => 'Genera fattura';

  @override
  String get meineAbgeschlossenenAuftraege => 'I miei incarichi conclusi';

  @override
  String get verbergenButtonLabel => 'Nascondi';

  @override
  String get rechnungGenerierenAppBar => 'Genera fattura';

  @override
  String get rechnungAlsPdfAnzeigenLabel => 'Mostra fattura in PDF';

  @override
  String get invoiceLabel => 'Fattura';

  @override
  String get fromLabel => 'Da:';

  @override
  String get taxNumberLabel => 'Partita IVA:';

  @override
  String get ibanLabel => 'IBAN:';

  @override
  String get toLabel => 'Per:';

  @override
  String get amountLabel => 'Importo:';

  @override
  String get dateLabel => 'Data:';

  @override
  String get generatedByText => 'Questa fattura è stata generata automaticamente tramite AtYourService.';

  @override
  String get currencyLabel => 'Valuta';

  @override
  String get amountRequired => 'Inserisci un importo valido.';

  @override
  String get premiumGoldInvoiceFeature => 'Fatturazione PDF';

  @override
  String get onlyForGoldTooltip => 'Questa funzione è disponibile solo per abbonati Gold.';

  @override
  String get deleteJobTooltip => 'Rimuovi incarico dall\'elenco';

  @override
  String get invoiceNumberLabel => 'Numero fattura';

  @override
  String get invoiceProfileHint => 'Inserisci i tuoi dati per la fatturazione nel profilo. Verranno riportati automaticamente nella fattura PDF.';

  @override
  String get auftragErneutPosten => 'Ripubblica l’incarico';

  @override
  String get auftragErneutPostenTitle => 'Ripubblicare questo incarico?';

  @override
  String get auftragErneutPostenText => 'L’attuale fornitore verrà rimosso. L’incarico sarà di nuovo visibile agli altri. Vuoi continuare?';

  @override
  String get auftragErneutGepostet => 'L’incarico è stato ripubblicato.';

  @override
  String get premiumActivated => 'Abbonamento attivato con successo!';

  @override
  String premiumPurchaseFailed(Object error) {
    return 'Acquisto non riuscito: $error';
  }

  @override
  String get premiumProductNotFound => 'Prodotto non trovato!';

  @override
  String get premiumStoreNotLoaded => 'Impossibile caricare i prodotti del negozio.';

  @override
  String premiumYearlySuffix(Object price) {
    return 'Annuale: $price';
  }

  @override
  String premiumYearlyButton(Object plan) {
    return '$plan (Annuale)';
  }

  @override
  String get deleteAccountTitle => 'Elimina account';

  @override
  String get deleteAccountWarning => 'Sei sicuro di voler eliminare definitivamente il tuo account? Tutti i tuoi dati saranno eliminati in modo irreversibile.';

  @override
  String get deleteAccountButton => 'Elimina account';

  @override
  String get accountDeleted => 'Il tuo account è stato eliminato.';

  @override
  String get cancel => 'Annulla';

  @override
  String get premiumDeactivated => 'Premium disattivato.';

  @override
  String acceptedByLabel(Object name) {
    return 'Accettato da $name';
  }

  @override
  String get adresseValidator => 'Per favore inserisci un indirizzo.';

  @override
  String get abgeschlosseneAuftraegeHinweis => 'Qui puoi eliminare incarichi completati e valutare il tuo fornitore di servizi.';

  @override
  String get goldBadgeLabel => 'Abbonamento Gold';

  @override
  String get silverBadgeLabel => 'Abbonamento Silver';

  @override
  String get topBewertetBadgeLabel => 'Valutazione top';

  @override
  String get badgeCertified => 'Certificato';

  @override
  String get badgeExperienced => 'Esperto';

  @override
  String get badgeExpert => 'Esperto';

  @override
  String get badgeMaster => 'Maestro';

  @override
  String badgeCertifiedCounter(Object count) {
    return '$count lavori completati';
  }

  @override
  String badgeExperiencedCounter(Object count) {
    return '$count lavori completati';
  }

  @override
  String badgeExpertCounter(Object count) {
    return '$count lavori completati';
  }

  @override
  String badgeMasterCounter(Object count) {
    return '$count lavori completati';
  }

  @override
  String get achievementTitle => 'Traguardi & Badge';

  @override
  String get goldBadgeDesc => 'Hai un abbonamento Gold e puoi accettare lavori illimitati.';

  @override
  String get silverBadgeDesc => 'Hai un abbonamento Silver e puoi accettare 3 lavori a settimana.';

  @override
  String get topBewertetBadgeDesc => 'Ottieni una media di almeno 4,5 stelle da almeno 5 recensioni.';

  @override
  String badgeCertifiedProgress(Object count) {
    return 'Certificato ($count/1)';
  }

  @override
  String get badgeCertifiedDesc => 'Completa 3 lavori.';

  @override
  String badgeExperiencedProgress(Object count) {
    return 'Esperto ($count/2)';
  }

  @override
  String get badgeExperiencedDesc => 'Completa un totale di 10 lavori.';

  @override
  String badgeExpertProgress(Object count) {
    return 'Professionista ($count/3)';
  }

  @override
  String get badgeExpertDesc => 'Completa un totale di 25 lavori.';

  @override
  String badgeMasterProgress(Object count) {
    return 'Maestro ($count/4)';
  }

  @override
  String get badgeMasterDesc => 'Completa un totale di 50 lavori.';

  @override
  String get trafficScreenInfoText => 'Qui puoi vedere quanti fornitori di servizi sono attualmente attivi per categoria nella tua zona. Più fornitori ci sono, più velocemente la tua richiesta verrà generalmente accettata.';

  @override
  String get filterAbgeschlossen => 'Completato';

  @override
  String get auftraege => 'Lavori';

  @override
  String get profil => 'Profilo';

  @override
  String get filterAlle => 'Tutti';

  @override
  String get filterOffen => 'Aperto';

  @override
  String get filterLaufend => 'In corso';

  @override
  String get forgotPasswordButton => 'Hai dimenticato la password?';

  @override
  String get forgotPasswordInfo => 'Inserisci il tuo indirizzo e-mail registrato. Riceverai un link per reimpostare la password.';

  @override
  String get sendResetLinkButton => 'Invia link di reset';

  @override
  String get resetMailSent => 'Il link è stato inviato. Controlla la tua casella di posta!';

  @override
  String get keineDienstleisterInRegion => 'Nessun fornitore di servizi trovato nella tua zona.';

  @override
  String get trafficScreenKeineAdresse => 'Nessun indirizzo trovato nel tuo profilo.';

  @override
  String get trafficScreenAdresseFehler => 'Il tuo indirizzo non può essere convertito in coordinate.';

  @override
  String get auftragWiederkehrendAppBar => 'Incarico ricorrente';

  @override
  String get auftragWiederkehrendHeadline => 'Questo incarico deve essere ripetuto regolarmente?';

  @override
  String get auftragWiederkehrendInfo => 'Scegli se e con quale frequenza l\'incarico deve essere eseguito automaticamente.';

  @override
  String get auftragReviewAppBar => 'Verifica e invia';

  @override
  String get auftragReviewHeadline => 'Tutto corretto?';

  @override
  String get auftragReviewInfo => 'Controlla i tuoi dati prima di inviare l\'incarico.';

  @override
  String get absendenButton => 'Invia';

  @override
  String get ja => 'Sì';

  @override
  String get nein => 'No';

  @override
  String get wiederholenBisLabelPlain => 'Ripeti fino a';

  @override
  String get auftragAdresseAppBar => 'Indirizzo e contatto';

  @override
  String get auftragAdresseHeadline => 'Dove deve essere svolto l\'incarico?';

  @override
  String get auftragAdresseInfo => 'Inserisci l\'indirizzo e il tuo numero di telefono così il fornitore può contattarti.';

  @override
  String get adresseHint => 'es. Via Esempio 12, 12345 Roma';

  @override
  String get telefonnummerHint => 'es. 333 1234567';

  @override
  String get zurueckButton => 'Indietro';

  @override
  String get weiterButton => 'Avanti';

  @override
  String get auftragKategorieAppBar => 'Seleziona categoria';

  @override
  String get auftragKategorieHeadline => 'Per quale categoria cerchi aiuto?';

  @override
  String get auftragKategorieInfo => 'Scegli il servizio giusto. Potrai specificare altri dettagli in seguito.';

  @override
  String get kategorieValidator => 'Seleziona una categoria.';

  @override
  String get auftragDetailsAppBar => 'Dettagli dell\'incarico';

  @override
  String get auftragDetailsHeadline => 'Descrivi l\'incarico';

  @override
  String get auftragDetailsInfo => 'Cosa bisogna fare? Più dettagli, meglio è!';

  @override
  String get auftragTerminAppBar => 'Data e ora';

  @override
  String get auftragTerminHeadline => 'Quando deve essere svolto l\'incarico?';

  @override
  String get auftragTerminInfo => 'Imposta data e ora oppure scegli \'prima possibile\'.';

  @override
  String get terminLabel => 'Data';

  @override
  String get preisLabel => 'Prezzo (€) o \'trattabile\'';

  @override
  String get preisHint => 'es. 60 o \'trattabile\'';

  @override
  String get preisValidator => 'Inserisci un prezzo valido o \'trattabile\'.';

  @override
  String get preisHinweisLabel => 'Nota sul prezzo (opzionale)';

  @override
  String get preisHinweisHint => 'es. tariffa oraria, costi materiali, trattabile, ecc.';

  @override
  String get preisTypLabel => 'Seleziona l\'opzione di prezzo';

  @override
  String get preisTypGesamt => 'Prezzo totale';

  @override
  String get preisTypStunden => 'Tariffa oraria';

  @override
  String get preisTypVerhandelbar => 'Da concordare / trattabile';

  @override
  String get preisLabelGesamt => 'Prezzo totale (€)';

  @override
  String get preisHintGesamt => 'es. 120';

  @override
  String get preisLabelStunden => 'Tariffa oraria (€ all’ora)';

  @override
  String get preisHintStunden => 'es. 20';

  @override
  String get preisHinweisVerhandelbar => 'Prezzo da concordare / offerte benvenute';

  @override
  String get preisTypGesamtDesc => 'Indichi il prezzo totale per l’incarico.';

  @override
  String get preisTypStundenDesc => 'Indichi una tariffa oraria per l’incarico.';

  @override
  String get preisTypVerhandelbarDesc => 'Il prezzo verrà concordato direttamente con il fornitore del servizio.';

  @override
  String get heimatadresseButtonInfo => 'Tocca qui per compilare automaticamente il tuo indirizzo di casa salvato.';

  @override
  String get verhandelbarLabel => 'Negoziaibile';

  @override
  String get terminValidierungFehler => 'Seleziona una data e entrambe le fasce orarie.';

  @override
  String get wiederkehrendValidierungFehler => 'Seleziona correttamente intervallo, giorno della settimana e numero di ripetizioni per le attività ricorrenti.';

  @override
  String priceTotal(Object amount) {
    return '$amount €';
  }

  @override
  String pricePerHour(Object amount, Object hourShort) {
    return '$amount € / $hourShort';
  }

  @override
  String get priceNegotiable => 'Negoziale';

  @override
  String get hourShort => 'h';

  @override
  String get setNewPasswordTitle => 'Imposta nuova password';

  @override
  String get setNewPasswordInfo => 'Inserisci la nuova password due volte per confermare.';

  @override
  String get newPasswordLabel => 'Nuova password';

  @override
  String get confirmNewPasswordLabel => 'Conferma nuova password';

  @override
  String get saveNewPasswordButton => 'Salva nuova password';

  @override
  String get passwordEmptyError => 'La password non può essere vuota.';

  @override
  String get passwordsDontMatch => 'Le password non corrispondono.';

  @override
  String get passwordResetSuccess => 'Password reimpostata con successo. Ora puoi accedere.';

  @override
  String get premiumRestorePurchases => 'Ripristina acquisti';

  @override
  String get premiumRetry => 'Riprova';

  @override
  String get wrongRoleCustomer => 'Questo account è registrato come fornitore di servizi e non può essere utilizzato per l\'accesso come cliente.';

  @override
  String get accountNotRegistered => 'Nessun account trovato con questa e-mail. Registrati prima.';

  @override
  String get wrongCredentials => 'Email o password errati.';

  @override
  String get premiumPushDelayFree => 'Notifiche push: ritardo di 1 h';

  @override
  String get premiumPushDelaySilver => 'Notifiche push: ritardo di 30 min';

  @override
  String get premiumPushDelayGold => 'Notifiche push: immediate per i nuovi lavori';

  @override
  String get companyNameOptional => 'Nome azienda (opzionale)';

  @override
  String get vatIdOptional => 'P. IVA (opzionale)';

  @override
  String get bicOptional => 'BIC (opzionale)';

  @override
  String get smallBusinessLabel => 'Regime forfettario ai sensi §19 UStG';

  @override
  String get defaultVatRateLabel => 'Aliquota IVA standard (%)';

  @override
  String get invalidVatRate => 'Aliquota IVA non valida';

  @override
  String get profileNameLabel => 'Nome completo';

  @override
  String get invoiceNoShort => 'N.';

  @override
  String get netAmountLabel => 'Netto';

  @override
  String vatLabelWithPercent(Object percent) {
    return 'IVA ($percent%)';
  }

  @override
  String get totalLabel => 'Totale';

  @override
  String get dueOnLabel => 'Scadenza:';

  @override
  String get vatIdLabel => 'P. IVA:';

  @override
  String get bicLabel => 'BIC:';

  @override
  String paymentTermsDefault(Object days) {
    return 'Pagabile entro $days giorni senza detrazioni.';
  }

  @override
  String get badgeInfoText => 'Questi badge possono essere ottenuti solo dai fornitori di servizi e compaiono quando il fornitore accetta l\'incarico.';

  @override
  String get noAuftraegeKundeHint => 'Crea il tuo primo incarico toccando il pulsante più (+).';

  @override
  String get upsellCardTitle => 'Incarico vicino a te';

  @override
  String upsellCategoryLabel(String category) {
    return 'Categoria: $category';
  }

  @override
  String upsellUpgradeButton(String plan) {
    return 'Passa a $plan per vedere questo incarico';
  }

  @override
  String get planFree => 'Gratuito';

  @override
  String get planSilver => 'Argento';

  @override
  String get planGold => 'Oro';

  @override
  String get filterNeu => 'Nuovi';

  @override
  String onlyNewWindowInfo(int hours) {
    return 'Mostra gli incarichi delle ultime $hours ore.';
  }

  @override
  String get cancelLabel => 'Annulla';

  @override
  String get editProfileCta => 'Completa il profilo';

  @override
  String get update_required_title => 'Aggiornamento richiesto';

  @override
  String get update_required_message => 'Aggiorna l\'app per continuare.';

  @override
  String get update_available_title => 'Aggiornamento disponibile';

  @override
  String get update_available_message => 'È disponibile una nuova versione. Vuoi aggiornare ora?';

  @override
  String get update_action_update_now => 'Aggiorna ora';

  @override
  String get update_action_later => 'Più tardi';

  @override
  String get invoiceSectionSubtitle => 'Opzionale: dati aziendali e fiscali per la fatturazione automatica';

  @override
  String get marketplaceTitle => 'Scambia incarichi';

  @override
  String get marketplaceTabSell => 'Vendi';

  @override
  String get marketplaceTabBuy => 'Acquista';

  @override
  String get marketplaceOfferCreateCta => 'Passa un incarico';

  @override
  String get marketplaceFilter => 'Filtra';

  @override
  String get marketplaceSort => 'Ordina';

  @override
  String get marketplaceBuyNow => 'Candidati ora';

  @override
  String get marketplaceSnackOpenForm => 'Apertura del modulo offerta…';

  @override
  String get marketplaceSnackStartCheckout => 'Avvio del checkout…';

  @override
  String marketplaceOfferTitle(int index) {
    return 'Offerta n.$index';
  }

  @override
  String marketplaceOfferSubtitle(String category, String price, Object distanceKm) {
    return '$category • $distanceKm km';
  }

  @override
  String marketplaceBuyTitle(int index) {
    return 'Annuncio n.$index · Piccola riparazione';
  }

  @override
  String marketplaceBuySubtitle(String category, String price, String distance) {
    return 'Categoria: $category · $price/h · $distance km';
  }

  @override
  String get marketplaceEmptyList => 'Nessuna offerta trovata.';

  @override
  String get marketplaceErrorLoading => 'Impossibile caricare l’elenco.';

  @override
  String get marketplaceAppliedSuccess => 'Candidatura inviata — il venditore può vederla.';

  @override
  String get marketplaceAlreadyApplied => 'Ti sei già candidato.';

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
    return 'Prezzo obiettivo: $price';
  }

  @override
  String marketplaceChipProvision(Object value) {
    return 'Provvigione: $value';
  }

  @override
  String get s0Title => 'Trasferisci incarico (S0)';

  @override
  String get sectionBasics => 'Base';

  @override
  String get fieldTitle => 'Titolo';

  @override
  String get hintTitleExample => 'es. Ristrutturazione tetto, 120 m²';

  @override
  String get fieldDescription => 'Descrizione';

  @override
  String get hintDescription => 'Breve descrizione, particolarità, materiali incl./escl.';

  @override
  String get fieldLocation => 'Luogo/raggio (per ora testo)';

  @override
  String get hintLocation => 'es. Colonia, 15 km';

  @override
  String get pickStartDate => 'Seleziona data inizio';

  @override
  String get pickDeadline => 'Seleziona scadenza';

  @override
  String get labelStart => 'Inizio';

  @override
  String get labelDeadline => 'Scadenza';

  @override
  String get sectionS0PriceProvision => 'S0 – Prezzo & Provvigione';

  @override
  String get tooltipS0PriceProvision => 'Prezzo obiettivo = prezzo totale dell’incarico.\nProvvigione = compenso per il passaggio.';

  @override
  String get fieldTargetPriceEur => 'Prezzo obiettivo (EUR)';

  @override
  String get hintTargetPriceExample => 'es. 12.500';

  @override
  String get helpTargetPrice => 'Valore totale rilevato dall’acquirente.';

  @override
  String get fieldProvisionType => 'Tipo di provvigione';

  @override
  String get provisionTypePercent => 'Percentuale';

  @override
  String get provisionTypeFixed => 'Fisso';

  @override
  String get fieldProvisionValuePercent => 'Valore provvigione (%)';

  @override
  String get fieldProvisionValueFixed => 'Valore provvigione (€)';

  @override
  String get helpProvisionPercent => 'Tipico: 5–12% (cap possibile).';

  @override
  String get helpProvisionFixed => 'Importo fisso della provvigione.';

  @override
  String get fieldProvisionDue => 'Quando è dovuta la provvigione?';

  @override
  String get provisionDueAward => 'all’assegnazione';

  @override
  String get provisionDueHandover => 'alla consegna';

  @override
  String get provisionDueFinalInvoice => 'alla fattura finale';

  @override
  String get provisionDueAwardHelp => 'All’assegnazione: la commissione è dovuta subito dopo l’assegnazione.';

  @override
  String get provisionDueHandoverHelp => 'Alla consegna: dopo OK del cliente e consegna.';

  @override
  String get provisionDueFinalInvoiceHelp => 'Alla fattura finale: quando l’acquirente conclude il lavoro.';

  @override
  String get sectionEvidencePlaceholder => 'Prove (placeholder)';

  @override
  String get btnUploadEvidence => 'Carica offerta/OK cliente';

  @override
  String get btnCreateDraft => 'Crea bozza';

  @override
  String get btnSaving => 'Salvataggio…';

  @override
  String get noteSupabaseActive => 'Nota: archiviazione Supabase attiva. Pagamenti & upload seguiranno.';

  @override
  String get formErrorRequired => 'Obbligatorio';

  @override
  String get formErrorInvalidAmount => 'Importo non valido';

  @override
  String get formErrorGreaterZero => 'Deve essere > 0';

  @override
  String get formErrorRealistic => 'Rimani realistico';

  @override
  String get formErrorInvalidValue => 'Valore non valido';

  @override
  String get formErrorPercentRange => 'Consentito: 0–30%';

  @override
  String get errPickStartDate => 'Seleziona una data di inizio';

  @override
  String get errPickDeadline => 'Seleziona una scadenza';

  @override
  String get draftSaved => 'Bozza S0 salvata.';

  @override
  String get genericError => 'Qualcosa è andato storto.';

  @override
  String get btnMyDeals => 'I miei deal';

  @override
  String get myDealsTitle => 'I miei deal';

  @override
  String get myDealsEmpty => 'Nessun incarico al momento.';

  @override
  String get myDealsErrorLoading => 'Impossibile caricare i tuoi incarichi.';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterDraft => 'Bozze';

  @override
  String get filterLive => 'Online';

  @override
  String get filterAwarded => 'Aggiudicati';

  @override
  String get manageTitle => 'Gestisci incarico';

  @override
  String get manageErrorLoading => 'Impossibile caricare i dettagli.';

  @override
  String get btnPublish => 'Pubblica';

  @override
  String get publishSuccess => 'Incarico pubblicato.';

  @override
  String get applicationsTitle => 'Candidature';

  @override
  String get applicationsEmpty => 'Ancora nessuna candidatura.';

  @override
  String get applicationNote => 'Nota';

  @override
  String get applicationStatusPending => 'Stato: in attesa';

  @override
  String get applicationStatusAwarded => 'Stato: aggiudicato';

  @override
  String get btnAward => 'Aggiudica';

  @override
  String get btnManage => 'Gestisci';

  @override
  String get labelStatus => 'Stato';

  @override
  String get statusDraft => 'Bozza';

  @override
  String get statusLive => 'Online';

  @override
  String get statusAwarded => 'Aggiudicato';

  @override
  String get awardSuccess => 'Candidatura aggiudicata con successo.';

  @override
  String get snackNewApplication => 'Nuova candidatura ricevuta';

  @override
  String applicationsCount(Object count) {
    return '$count candidature';
  }

  @override
  String get btnApplied => 'Candidato';

  @override
  String get s0EditTitle => 'Modifica S0';

  @override
  String get publishNow => 'Pubblica dopo il salvataggio';

  @override
  String get publishNowHint => 'Se attivato, la bozza verrà impostata su «Live» dopo il salvataggio.';

  @override
  String get btnSaveChanges => 'Salva modifiche';

  @override
  String get saved => 'Salvato';

  @override
  String get marketplaceLocationLoadedFromProfile => 'Posizione dal profilo — filtro raggio attivo.';

  @override
  String get marketplaceNoHomeAddressHint => 'Nessun indirizzo nel profilo — mostro tutte le offerte senza filtro distanza.';

  @override
  String get fieldCategory => 'Categoria';

  @override
  String get categoryAll => 'Tutte';

  @override
  String get categoryRoofer => 'Lattoniere / Coperture';

  @override
  String get categorySolar => 'FV / Solare';

  @override
  String get categoryHVAC => 'Riscaldamento / Idraulica / HVAC';

  @override
  String get categoryElectrical => 'Elettrico';

  @override
  String get categoryDrywall => 'Cartongesso';

  @override
  String get categoryPainter => 'Imbianchino';

  @override
  String get categoryTiling => 'Posa piastrelle';

  @override
  String get categoryFlooring => 'Posa pavimenti';

  @override
  String get categoryWindowsDoors => 'Finestre & Porte';

  @override
  String get categoryInsulationFacade => 'Isolamento & Facciate';

  @override
  String get categoryMasonryConcrete => 'Muratura & Calcestruzzo';

  @override
  String get categoryCarpentryJoinery => 'Carpenteria & Falegnameria';

  @override
  String get categoryLandscaping => 'Giardinaggio / Paesaggistica';

  @override
  String get categoryScaffolding => 'Ponteggi';

  @override
  String get categoryCleaningRestoration => 'Pulizie & Restauro';

  @override
  String get categoryMovingTransport => 'Traslochi & Trasporti';

  @override
  String get sectionCustomerOk => 'Consenso del cliente';

  @override
  String get helpCustomerOk => 'Prova che il cliente accetta il trasferimento (es. offerta firmata, email/SMS in PDF/foto).';

  @override
  String get btnUploadCustomerOk => 'Carica consenso cliente';

  @override
  String get customerNameOptional => 'Nome cliente (opzionale)';

  @override
  String get customerPhoneOptional => 'Telefono (opzionale)';

  @override
  String get sectionOffer => 'Offerta / Conferma d’ordine';

  @override
  String get helpOfferOptional => 'La tua offerta o conferma. Opzionale ma utile per gli acquirenti.';

  @override
  String get btnUploadOffer => 'Carica offerta';

  @override
  String get errCustomerOkRequired => 'È richiesto almeno un documento di consenso per pubblicare.';

  @override
  String get warnMissingDocsBody => 'Attenzione: senza consenso/offerta non potrai pubblicare più tardi. Puoi aggiungere i documenti in qualsiasi momento.';

  @override
  String get attestLabel => 'Confermo veridicamente che il cliente ha acconsentito al trasferimento e che tutte le informazioni sono corrette.';

  @override
  String get attestConsequences => 'In caso di dichiarazioni false possiamo sospendere l’account, trattenere i pagamenti e avviare azioni civili e, ove applicabile, penali.';

  @override
  String get errAttestRequired => 'Devi spuntare la conferma per pubblicare.';

  @override
  String get genericPleaseFix => 'Correggi i campi evidenziati:';

  @override
  String get errAwardNeedsDoc => 'Se la scadenza è \"alla aggiudicazione\", è richiesto un documento/offerta.';

  @override
  String get errNotOwner => 'Non sei il proprietario di questo incarico.';

  @override
  String get errPublishOnlyFromDraft => 'La pubblicazione è possibile solo dallo stato bozza.';

  @override
  String get publishRequirementsTitle => 'Requisiti per pubblicare';

  @override
  String get infoReqCustomerOk => 'È allegato almeno un consenso del cliente.';

  @override
  String get infoReqDocForAward => 'Per \"alla aggiudicazione\": carica offerta/conferma d’ordine.';

  @override
  String get infoReqAttest => 'La conferma nel modulo è selezionata.';

  @override
  String get draftChecklistTitle => 'Checklist prima della pubblicazione';

  @override
  String get chkTitle => 'Titolo compilato';

  @override
  String get chkDescription => 'Descrizione compilata';

  @override
  String get chkLocation => 'Indirizzo/località impostati';

  @override
  String get chkTargetPrice => 'Prezzo obiettivo impostato';

  @override
  String get chkCustomerOk => 'Consenso cliente presente';

  @override
  String get chkDocIfAward => 'Documento/offerta presente (consigliato se \"alla aggiudicazione\")';

  @override
  String get chkAttestAtPublish => 'Spunta la conferma al momento della pubblicazione';

  @override
  String get draftChecklistCta => 'Apri gestione';

  @override
  String get uploadSuccess => 'Caricamento riuscito.';

  @override
  String get uploadInProgress => 'Caricamento in corso...';

  @override
  String get uploadFailed => 'Caricamento non riuscito.';

  @override
  String get draftDefaultTitle => 'Bozza';

  @override
  String get errGeocodingFailed => 'Impossibile geocodificare l’indirizzo.';

  @override
  String get provisionDueAwardLabel => 'Assegnazione';

  @override
  String get provisionDueHandoverLabel => 'Consegna';

  @override
  String get provisionDueFinalInvoiceLabel => 'Fattura finale';

  @override
  String get sectionPreviewPublic => 'Anteprima (pubblica)';

  @override
  String get tooltipPreviewPublic => 'Questi file sono visibili agli acquirenti prima dell’acquisto. Carica solo anteprime oscurate/anonimizzate.';

  @override
  String get btnUploadPreview => 'Carica anteprima';

  @override
  String get previewRedactionNoticeTitle => 'Avviso importante sull’anteprima';

  @override
  String get previewRedactionNoticeBody => 'Le anteprime sono visibili agli acquirenti prima dell’acquisto. Oscura i dati sensibili (nomi, indirizzi, numeri di telefono, n. contratto/cliente, firme, codici QR/a barre). Non caricare documenti con dati personali non oscurati.';

  @override
  String get hintPhoneExample => '+39 347 123 4567';

  @override
  String get createDealTitle => 'Crea offerta';

  @override
  String get chooseDealTypeTitle => 'Scegli il tipo di offerta';

  @override
  String get dealTypeS0Title => 'S0 – Rivendere l’incarico';

  @override
  String get dealTypeS0Subtitle => 'Cedere l’intero incarico a un altro fornitore.';

  @override
  String get dealTypeS1Title => 'S1 – Sotto-lavoro/Subappalto (milestone)';

  @override
  String get dealTypeS1Subtitle => 'Subappalto con milestone e prove.';

  @override
  String get s1Title => 'Cercare subappaltatori (S1)';

  @override
  String get sectionS1Pricing => 'Prezzi';

  @override
  String get sectionS1Provision => 'Provvigione';

  @override
  String get sectionMilestones => 'Traguardi';

  @override
  String get pricingModeFixed => 'Prezzo fisso';

  @override
  String get pricingModeTm => 'Tempo & Materiali';

  @override
  String get basePriceLabel => 'Budget totale (€)';

  @override
  String get hourlyRateLabel => 'Tariffa oraria (€)';

  @override
  String get expectedHoursLabel => 'Ore stimate';

  @override
  String get dueTypeAward => 'Aggiudicazione';

  @override
  String get dueTypeDate => 'Data';

  @override
  String get dueTypeHandover => 'Consegna';

  @override
  String get dueTypeCustom => 'Personalizzato';

  @override
  String get dueTypeCustomHelp => 'Scadenza personalizzata (indicare data/commento).';

  @override
  String get milestoneLabel => 'Traguardo';

  @override
  String get milestoneTitle => 'Titolo del traguardo';

  @override
  String get milestoneDescription => 'Descrizione del traguardo';

  @override
  String get milestoneAmount => 'Importo (€)';

  @override
  String get milestonePercent => 'Percentuale (%)';

  @override
  String get milestoneDue => 'Scadenza';

  @override
  String get btnAddMilestonePercent => 'Aggiungi traguardo (%)';

  @override
  String get btnAddMilestoneAmount => 'Aggiungi traguardo (€)';

  @override
  String get milestoneEmptyHint => 'Nessun traguardo ancora (opzionale).';

  @override
  String get milestoneBlocking => 'Bloccante';

  @override
  String get milestoneBlockingHelp => 'Da completare prima di sbloccare il passo successivo.';

  @override
  String get validationMilestoneSum => 'I totali dei traguardi non tornano: serve 100% nel modo percentuale, oppure somma pari al budget nel prezzo fisso.';

  @override
  String get btnReorder => 'Riordina';

  @override
  String get infoS1PricingHelp => 'Come prezzi il lavoro in subappalto. «Prezzo fisso» = un budget totale per il lotto. «Tempo e materiali» = tariffa oraria + ore stimate; la fatturazione reale è a consuntivo.';

  @override
  String get infoS1ProvisionHelp => 'La tua provvigione per ogni subappaltatore aggiudicato. Imposta percentuale o importo fisso e la relativa scadenza.';

  @override
  String get coordChipNoCoords => 'Nessuna coordinata';

  @override
  String get coordMissingLabel => 'Coordinate (lat/lng)';

  @override
  String get s0DetailsMissingLabel => 'Dettagli S0';

  @override
  String get s1DetailsMissingLabel => 'Dettagli S1';

  @override
  String get marketplaceTypeS0 => 'S0 – Girare incarico';

  @override
  String get marketplaceTypeS1 => 'S1 – Ricerca subappalto';

  @override
  String get filterTypeAll => 'Tutti i tipi';

  @override
  String get filterTypeS0 => 'Solo S0';

  @override
  String get filterTypeS1 => 'Solo S1';

  @override
  String get badgeAwardedToYou => 'Assegnato a te';

  @override
  String get badgeAwardedGiven => 'Assegnato';

  @override
  String get btnAssigned => 'Assegnato';

  @override
  String get marketplaceOwnDealPill => 'Il tuo incarico';
}
