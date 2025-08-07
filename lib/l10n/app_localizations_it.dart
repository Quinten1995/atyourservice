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
  String get passwordTooShort => 'La password deve contenere almeno 6 caratteri';

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
  String get premiumSilverFeature1 => '3 incarichi a settimana';

  @override
  String get premiumSilverFeature2 => 'Incarichi nel raggio di 15 km';

  @override
  String get premiumSilverFeature3 => 'Tutte le categorie disponibili';

  @override
  String get premiumGoldFeature1 => 'Incarichi illimitati';

  @override
  String get premiumGoldFeature2 => 'Incarichi nel raggio di 40 km';

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
  String get category_rasenmaeher_service => 'Servizio taglio erba';

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
  String get invoiceGoldInfo => 'Queste informazioni appariranno sulla tua fattura PDF (funzione Gold).';

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
  String get topBewertetBadgeDesc => 'Ottieni una media di almeno 4,5 stelle da almeno 2 recensioni.';

  @override
  String badgeCertifiedProgress(Object count) {
    return 'Certificato ($count/1)';
  }

  @override
  String get badgeCertifiedDesc => 'Completa il tuo primo lavoro.';

  @override
  String badgeExperiencedProgress(Object count) {
    return 'Esperto ($count/2)';
  }

  @override
  String get badgeExperiencedDesc => 'Completa un totale di 2 lavori.';

  @override
  String badgeExpertProgress(Object count) {
    return 'Professionista ($count/3)';
  }

  @override
  String get badgeExpertDesc => 'Completa un totale di 3 lavori.';

  @override
  String badgeMasterProgress(Object count) {
    return 'Maestro ($count/4)';
  }

  @override
  String get badgeMasterDesc => 'Completa un totale di 4 lavori.';

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
}
