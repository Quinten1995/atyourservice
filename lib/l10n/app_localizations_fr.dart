// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get registerAppBar => 'Inscription';

  @override
  String get registerTitle => 'S\'inscrire';

  @override
  String get roleLabel => 'Sélectionner un rôle';

  @override
  String get roleKunde => 'Client';

  @override
  String get roleDienstleister => 'Prestataire';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get categoryValidator => 'Veuillez sélectionner une catégorie';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailEmpty => 'Veuillez saisir un e-mail';

  @override
  String get emailInvalid => 'Veuillez saisir un e-mail valide';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordEmpty => 'Veuillez saisir un mot de passe';

  @override
  String get passwordTooShort => 'Le mot de passe doit contenir au moins 8 caractères.';

  @override
  String get registerButton => 'S\'inscrire';

  @override
  String get registerSuccess => 'Inscription réussie ! Veuillez confirmer votre e-mail.';

  @override
  String get registerExists => 'Cet e-mail est déjà enregistré. Veuillez vous connecter ou réinitialiser votre mot de passe.';

  @override
  String get registerInvalidEmail => 'Veuillez saisir une adresse e-mail valide.';

  @override
  String get registerPasswordShort => 'Le mot de passe doit comporter au moins 6 caractères.';

  @override
  String registerFailed(Object error) {
    return 'Échec de l\'inscription : $error';
  }

  @override
  String registerUnknownError(Object error) {
    return 'Erreur inconnue : $error';
  }

  @override
  String get profileAppBar => 'Profil du prestataire';

  @override
  String get profileAddressLabel => 'Adresse du domicile (ex. : Rue Exemple 12, 12345 Ville Exemple)';

  @override
  String get profileAddressEmpty => 'Entrer l\'adresse';

  @override
  String get profileSaveButton => 'Enregistrer le profil';

  @override
  String get profileAddressSaved => 'Adresse enregistrée !';

  @override
  String profileLoadError(Object error) {
    return 'Erreur lors du chargement : $error';
  }

  @override
  String profileSaveError(Object error) {
    return 'Erreur lors de l\'enregistrement : $error';
  }

  @override
  String get notLoggedIn => 'Non connecté.';

  @override
  String get pleaseLogin => 'Veuillez d\'abord vous connecter';

  @override
  String get changeNotAllowedTitle => 'Modification impossible';

  @override
  String changeNotAllowedContent(Object date) {
    return 'En tant qu\'utilisateur gratuit, vous ne pouvez changer votre catégorie ou adresse que tous les 20 jours.\nProchain changement possible à partir du : $date';
  }

  @override
  String get ok => 'OK';

  @override
  String get profileSaved => 'Profil enregistré avec succès !';

  @override
  String get changeProfileImage => 'Changer la photo de profil';

  @override
  String get upgradeToPremium => 'Passer à Premium';

  @override
  String get noRatingsYet => 'Aucun avis pour le moment';

  @override
  String get nameLabel => 'Nom';

  @override
  String get nameValidator => 'Veuillez saisir le nom';

  @override
  String get descriptionLabel => 'Description du service :';

  @override
  String get addressLabel => 'Adresse (ex : rue, code postal, ville)';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get phoneValidator => 'Veuillez saisir un numéro de téléphone';

  @override
  String get emailEmptyValidator => 'Veuillez saisir votre e-mail';

  @override
  String get emailInvalidValidator => 'Veuillez saisir une adresse e-mail valide';

  @override
  String errorPrefix(Object error) {
    return 'Erreur : $error';
  }

  @override
  String changeLimitHint(Object date) {
    return 'La catégorie/adresse ne pourra être modifiée qu\'à partir du $date.';
  }

  @override
  String get addressNotFound => 'Adresse introuvable. Veuillez vérifier.';

  @override
  String ratingsCount(Object count) {
    return '($count avis)';
  }

  @override
  String get premiumAppBar => 'Passer à Premium';

  @override
  String get premiumChoosePlan => 'Choisissez votre plan Premium';

  @override
  String get premiumCurrentPlan => 'Abonnement actuel :';

  @override
  String get premiumFreePrice => 'gratuit';

  @override
  String get premiumSilverPrice => '€4.99 / month';

  @override
  String get premiumGoldPrice => '9,99 € / mois';

  @override
  String get premiumFreeFeature1 => 'Accepter 1 mission par semaine';

  @override
  String get premiumFreeFeature2 => 'Missions dans un rayon de 5 km';

  @override
  String get premiumFreeFeature3 => 'Catégories de base uniquement';

  @override
  String get premiumFreeFeature4 => 'Changement de catégorie seulement tous les 20 jours';

  @override
  String get premiumSilverFeature1 => 'Accepter 2 missions par semaine';

  @override
  String get premiumSilverFeature2 => 'Missions dans un rayon de 15 km';

  @override
  String get premiumSilverFeature3 => 'Toutes les catégories disponibles';

  @override
  String get premiumGoldFeature1 => 'Accepter 5 missions par semaine';

  @override
  String get premiumGoldFeature2 => 'Missions dans un rayon de 30 km';

  @override
  String get premiumGoldFeature3 => 'Toutes les catégories disponibles';

  @override
  String get premiumGoldFeature4 => 'Badge utilisateur premium (visible pour les clients)';

  @override
  String premiumChooseButton(Object title) {
    return 'Choisir $title';
  }

  @override
  String get premiumPaymentNote => 'Note : Tous les paiements sont sécurisés via Apple ou Google. Vous pouvez annuler ou gérer votre abonnement à tout moment dans la boutique.';

  @override
  String get premiumSilverComingSoon => 'Achat Silver bientôt disponible !';

  @override
  String get premiumGoldComingSoon => 'Achat Gold bientôt disponible !';

  @override
  String get auftragHidden => 'Mission masquée.';

  @override
  String auftragHideError(Object error) {
    return 'Erreur lors du masquage : $error';
  }

  @override
  String get meineAuftraegeAppBar => 'Mes missions';

  @override
  String get refreshTooltip => 'Recharger';

  @override
  String get noAuftraegeFound => 'Aucune mission trouvée.';

  @override
  String get geplanterAuftrag => 'Mission programmée';

  @override
  String get auftragAusblenden => 'Masquer la mission';

  @override
  String get loginFailedDetails => 'Échec de la connexion. Veuillez vérifier vos informations ou confirmer votre e-mail.';

  @override
  String get loginSuccess => 'Connexion réussie !';

  @override
  String loginFailedPrefix(Object error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String loginUnknownError(Object error) {
    return 'Erreur inconnue : $error';
  }

  @override
  String get emailValidatorEmpty => 'Veuillez saisir un e-mail';

  @override
  String get emailValidatorInvalid => 'Veuillez saisir un e-mail valide';

  @override
  String get passwordValidatorEmpty => 'Veuillez saisir un mot de passe';

  @override
  String get passwordValidatorShort => 'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get loginKundeAppBar => 'Connexion client';

  @override
  String get loginKundeHeadline => 'Se connecter';

  @override
  String get loginButton => 'Connexion';

  @override
  String get noAccountYet => 'Pas encore de compte ? Inscrivez-vous maintenant';

  @override
  String get loginFailedDetailsDL => 'Échec de la connexion. Veuillez vérifier vos informations ou confirmer votre e-mail.';

  @override
  String get wrongRoleDL => 'Ce compte n\'est pas un prestataire de services. Veuillez utiliser la connexion client.';

  @override
  String get loginDLAppBar => 'Connexion prestataire';

  @override
  String get loginDLHeadline => 'Se connecter';

  @override
  String get kundenDashboardHeader => 'Votre tableau de bord';

  @override
  String get kundenDashboardAppBar => 'Tableau de bord client';

  @override
  String get laufendeAuftraege => 'Missions en cours';

  @override
  String statusPrefix(Object status) {
    return 'Statut : $status';
  }

  @override
  String dienstleisterPrefix(Object dienstleister) {
    return 'Prestataire : $dienstleister';
  }

  @override
  String get offeneAuftraege => 'Missions ouvertes';

  @override
  String get noOffeneAuftraege => 'Aucune mission ouverte trouvée.';

  @override
  String get abgeschlosseneAuftraege => 'Missions terminées';

  @override
  String get abgeschlossenStatus => 'Terminé';

  @override
  String get neuerAuftrag => 'Nouvelle mission';

  @override
  String get pleaseCreateProfile => 'Veuillez d\'abord créer votre profil.';

  @override
  String get profilMissingCategory => 'Catégorie manquante dans le profil.';

  @override
  String get dienstleisterDashboardHeader => 'Votre tableau de bord';

  @override
  String get dienstleisterDashboardAppBar => 'Tableau de bord prestataire';

  @override
  String get meineLaufendenAuftraege => 'Mes missions en cours';

  @override
  String kundePrefix(Object kunde) {
    return 'Client : $kunde';
  }

  @override
  String get offenePassendeAuftraege => 'Missions ouvertes correspondantes';

  @override
  String get noPassendeAuftraege => 'Aucune mission correspondante trouvée.';

  @override
  String entfernungSuffix(Object dist) {
    return 'à $dist km';
  }

  @override
  String get auftragBereitsBewertet => 'Vous avez déjà évalué cette mission.';

  @override
  String get bewertungDialogTitle => 'Évaluer le prestataire';

  @override
  String get bewertungKommentarLabel => 'Commentaire (optionnel)';

  @override
  String get abbrechen => 'Annuler';

  @override
  String get abschicken => 'Envoyer';

  @override
  String get auftragErstellenTitle => 'Créer une nouvelle mission';

  @override
  String get auftragEinstellenUeberschrift => 'Publier une mission maintenant';

  @override
  String get titelLabel => 'Titre';

  @override
  String get titelValidator => 'Veuillez saisir un titre';

  @override
  String get beschreibungLabel => 'Description';

  @override
  String get kategorieLabel => 'Catégorie';

  @override
  String get heimatadresseEinfuegen => 'Insérer l\'adresse du domicile';

  @override
  String get adresseLabel => 'Adresse (ex. Alter Markt 76, 50667 Cologne)';

  @override
  String get telefonnummerLabel => 'Numéro de téléphone';

  @override
  String get telefonnummerValidator => 'Veuillez saisir un numéro de téléphone';

  @override
  String get ausfuehrungszeitpunkt => 'Heure d\'exécution';

  @override
  String get soSchnellWieMoeglich => 'Dès que possible';

  @override
  String get geplant => 'Planifié';

  @override
  String get datumWaehlen => 'Choisir la date';

  @override
  String get zeitVon => 'Heure de début';

  @override
  String get zeitBis => 'Heure de fin';

  @override
  String get wiederkehrendCheckbox => 'Mission récurrente ?';

  @override
  String get intervallLabel => 'Intervalle';

  @override
  String get intervallValidator => 'Veuillez sélectionner un intervalle';

  @override
  String get wochentagLabel => 'Jour de la semaine';

  @override
  String get wochentagValidator => 'Veuillez sélectionner un jour de la semaine';

  @override
  String get anzahlWiederholungenLabel => 'Nombre de répétitions (optionnel)';

  @override
  String get wiederholenBisNichtGesetzt => 'Répéter jusqu\'à : non défini';

  @override
  String wiederholenBisLabel(Object date) {
    return 'Répéter jusqu\'à : $date';
  }

  @override
  String get auftragAbschicken => 'Envoyer la mission';

  @override
  String get auftragGespeichert => 'Mission enregistrée !';

  @override
  String get bitteEinloggen => 'Veuillez vous connecter d\'abord';

  @override
  String get adresseNichtGefunden => 'Adresse non trouvée.';

  @override
  String unbekannterFehler(Object error) {
    return 'Erreur inconnue : $error';
  }

  @override
  String get auftragDetailTitle => 'Détails de la mission';

  @override
  String get nichtEingeloggt => 'Non connecté';

  @override
  String get rolleNichtErmittelt => 'Rôle non déterminé';

  @override
  String get auftragNichtGefunden => 'Mission non trouvée';

  @override
  String get bewertungDanke => 'Merci pour votre évaluation !';

  @override
  String get limitErreicht => 'Limite atteinte';

  @override
  String get limitFree => 'En tant que prestataire freemium, vous pouvez accepter jusqu\'à 2 missions par semaine. Passez à Silver ou Gold pour plus d\'options !';

  @override
  String get limitSilver => 'En tant que prestataire Silver, vous pouvez accepter jusqu\'à 5 missions par semaine. Passez à Gold pour des missions illimitées !';

  @override
  String get auftragAnnehmen => 'Accepter la mission';

  @override
  String get auftragBeenden => 'Terminer la mission';

  @override
  String get auftragEntfernenUebersicht => 'Retirer la mission de la vue d\'ensemble';

  @override
  String get auftragEntfernen => 'Retirer la mission';

  @override
  String get auftragEntfernenTitel => 'Retirer la mission ?';

  @override
  String get auftragEntfernenText => 'Voulez-vous retirer cette mission de votre vue d\'ensemble ?';

  @override
  String get entfernen => 'Retirer';

  @override
  String get keineDatenVerfuegbar => 'Pas de données disponibles';

  @override
  String get beschreibung => 'Description :';

  @override
  String get kategorie => 'Catégorie :';

  @override
  String get adresse => 'Adresse :';

  @override
  String get status => 'Statut :';

  @override
  String jedenWochentag(Object wochentag) {
    return 'Chaque $wochentag';
  }

  @override
  String bisDatum(Object datum) {
    return 'jusqu\'au $datum';
  }

  @override
  String get malSuffix => 'fois';

  @override
  String kontaktZuLabel(Object label) {
    return 'Contact $label :';
  }

  @override
  String get nummerKopiert => 'Numéro copié !';

  @override
  String get nummerKopieren => 'Copier le numéro';

  @override
  String get anrufen => 'Appeler';

  @override
  String fehlerPrefix(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get editProfileTooltip => 'Modifier le profil';

  @override
  String get appTitle => 'AtYourService';

  @override
  String get hello => 'Bienvenue!';

  @override
  String get kundeButton => 'Je cherche un prestataire';

  @override
  String get dienstleisterButton => 'Je suis un prestataire';

  @override
  String get category_babysitter => 'Baby-sitter / Garde d\'enfants';

  @override
  String get category_catering => 'Traiteur';

  @override
  String get category_dachdecker => 'Couvreur';

  @override
  String get category_elektriker => 'Électricien';

  @override
  String get category_ernaehrungsberatung => 'Conseil en nutrition';

  @override
  String get category_eventplanung => 'Organisation d\'événements';

  @override
  String get category_fahrdienste => 'Services de transport';

  @override
  String get category_fahrlehrer => 'Moniteur d\'auto-école';

  @override
  String get category_fensterputzer => 'Laveur de vitres';

  @override
  String get category_fliesenleger => 'Carreleur';

  @override
  String get category_fotografie => 'Photographie / Vidéographie';

  @override
  String get category_friseur => 'Coiffeur/euse';

  @override
  String get category_gartenpflege => 'Entretien de jardin / Tonte de pelouse';

  @override
  String get category_grafikdesign => 'Graphisme';

  @override
  String get category_handy_reparatur => 'Réparation smartphone/tablette';

  @override
  String get category_haushaltsreinigung => 'Ménage à domicile';

  @override
  String get category_hausmeisterservice => 'Service de conciergerie';

  @override
  String get category_heizungsbauer => 'Installateur de chauffage';

  @override
  String get category_hundesitter => 'Promenade de chiens / Garde de chiens';

  @override
  String get category_it_support => 'Support informatique';

  @override
  String get category_klempner => 'Plombier';

  @override
  String get category_kosmetik => 'Esthéticien/ne';

  @override
  String get category_kuenstler => 'Artiste (ex : musicien pour événements)';

  @override
  String get category_kurierdienst => 'Service de messagerie';

  @override
  String get category_maler => 'Peintre';

  @override
  String get category_massagen => 'Massages';

  @override
  String get category_maurer => 'Maçon';

  @override
  String get category_moebelaufbau => 'Montage de meubles';

  @override
  String get category_musikunterricht => 'Cours de musique';

  @override
  String get category_nachhilfe => 'Cours particuliers';

  @override
  String get category_nagelstudio => 'Institut de manucure';

  @override
  String get category_pc_reparatur => 'Réparation PC / ordinateur portable';

  @override
  String get category_partyservice => 'Service pour fêtes';

  @override
  String get category_personal_trainer => 'Coach personnel';

  @override
  String get category_rasenmaeher_service => 'Entretien de jardin / Aménagement paysager';

  @override
  String get category_rechtsberatung => 'Conseil juridique';

  @override
  String get category_reparaturdienste => 'Services de réparation';

  @override
  String get category_seniorenbetreuung => 'Aide aux personnes âgées';

  @override
  String get category_social_media => 'Gestion des réseaux sociaux';

  @override
  String get category_sonstige => 'Autres services';

  @override
  String get category_sprachunterricht => 'Cours de langues';

  @override
  String get category_steuerberatung => 'Conseil fiscal';

  @override
  String get category_tischler => 'Menuisier';

  @override
  String get category_transport => 'Transport & Mobilité';

  @override
  String get category_umzugstransporte => 'Transport de déménagement';

  @override
  String get category_umzugshelfer => 'Aide au déménagement';

  @override
  String get category_uebersetzungen => 'Traductions';

  @override
  String get category_waescheservice => 'Service de blanchisserie';

  @override
  String get category_webdesign => 'Webdesign';

  @override
  String get category_einkaufsservice => 'Service de courses';

  @override
  String get category_haustierbetreuung => 'Garde d\'animaux';

  @override
  String get premiumBadgeLabel => 'Premium';

  @override
  String get statusOffen => 'Ouvert';

  @override
  String get statusInBearbeitung => 'En cours';

  @override
  String get statusAbgeschlossen => 'Terminé';

  @override
  String get privacyButton => 'Confidentialité';

  @override
  String get interval_weekly => 'Hebdomadaire';

  @override
  String get interval_biweekly => 'Toutes les 2 semaines';

  @override
  String get interval_monthly => 'Mensuel';

  @override
  String get weekday_monday => 'Lundi';

  @override
  String get weekday_tuesday => 'Mardi';

  @override
  String get weekday_wednesday => 'Mercredi';

  @override
  String get weekday_thursday => 'Jeudi';

  @override
  String get weekday_friday => 'Vendredi';

  @override
  String get weekday_saturday => 'Samedi';

  @override
  String get weekday_sunday => 'Dimanche';

  @override
  String get kundenInfoBanner => 'Vous êtes connecté en tant que client. Veuillez décrire ici le service dont vous avez besoin. Les prestataires de services vous feront ensuite des offres.';

  @override
  String get titelHint => 'par ex. faire nettoyer mon appartement';

  @override
  String get beschreibungHint => 'Décrivez ce qui doit être fait – par ex. nettoyer 3 pièces, cuisine, salle de bain ...';

  @override
  String get invoiceSectionTitle => 'Données de facturation (réservé aux membres Gold)';

  @override
  String get invoiceNameLabel => 'Nom de la facture (ex : nom de l\'entreprise)';

  @override
  String get invoiceAddressLabel => 'Adresse de facturation :';

  @override
  String get invoiceTaxNumberLabel => 'Numéro fiscal (optionnel)';

  @override
  String get invoiceIbanLabel => 'IBAN (optionnel)';

  @override
  String get invoiceLogoUrlLabel => 'URL du logo (optionnel)';

  @override
  String get invoiceGoldInfo => 'Les données de facturation sont modifiables avec l’abonnement GOLD.';

  @override
  String get rechnungGenerierenButtonLabel => 'Générer la facture';

  @override
  String get meineAbgeschlossenenAuftraege => 'Mes commandes terminées';

  @override
  String get verbergenButtonLabel => 'Masquer';

  @override
  String get rechnungGenerierenAppBar => 'Générer la facture';

  @override
  String get rechnungAlsPdfAnzeigenLabel => 'Afficher la facture au format PDF';

  @override
  String get invoiceLabel => 'Facture';

  @override
  String get fromLabel => 'De :';

  @override
  String get taxNumberLabel => 'Numéro fiscal :';

  @override
  String get ibanLabel => 'IBAN :';

  @override
  String get toLabel => 'À :';

  @override
  String get amountLabel => 'Montant :';

  @override
  String get dateLabel => 'Date :';

  @override
  String get generatedByText => 'Cette facture a été générée automatiquement via AtYourService.';

  @override
  String get currencyLabel => 'Devise';

  @override
  String get amountRequired => 'Veuillez saisir un montant valide.';

  @override
  String get premiumGoldInvoiceFeature => 'Invoice generation as PDF';

  @override
  String get onlyForGoldTooltip => 'Cette fonctionnalité est disponible uniquement pour les abonnés Gold.';

  @override
  String get deleteJobTooltip => 'Supprimer la mission de la liste';

  @override
  String get invoiceNumberLabel => 'Numéro de facture';

  @override
  String get invoiceProfileHint => 'Veuillez saisir vos coordonnées de facturation dans votre profil. Elles seront automatiquement reprises sur la facture PDF.';

  @override
  String get auftragErneutPosten => 'Republier la mission';

  @override
  String get auftragErneutPostenTitle => 'Republier cette mission ?';

  @override
  String get auftragErneutPostenText => 'Le prestataire actuel sera retiré. La mission sera à nouveau visible pour d’autres. Voulez-vous continuer ?';

  @override
  String get auftragErneutGepostet => 'La mission a été republiée.';

  @override
  String get premiumActivated => 'Abonnement activé avec succès !';

  @override
  String premiumPurchaseFailed(Object error) {
    return 'Échec de l\'achat : $error';
  }

  @override
  String get premiumProductNotFound => 'Produit introuvable !';

  @override
  String get premiumStoreNotLoaded => 'Les produits du store n\'ont pas pu être chargés.';

  @override
  String premiumYearlySuffix(Object price) {
    return 'Annuel : $price';
  }

  @override
  String premiumYearlyButton(Object plan) {
    return '$plan (Annuel)';
  }

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get deleteAccountWarning => 'Voulez-vous vraiment supprimer définitivement votre compte ? Toutes vos données seront supprimées de façon irréversible.';

  @override
  String get deleteAccountButton => 'Supprimer le compte';

  @override
  String get accountDeleted => 'Votre compte a été supprimé.';

  @override
  String get cancel => 'Annuler';

  @override
  String get premiumDeactivated => 'Premium désactivé.';

  @override
  String acceptedByLabel(Object name) {
    return 'Accepté par $name';
  }

  @override
  String get adresseValidator => 'Veuillez saisir une adresse.';

  @override
  String get abgeschlosseneAuftraegeHinweis => 'Ici, tu peux supprimer des missions terminées et évaluer ton prestataire.';

  @override
  String get goldBadgeLabel => 'Abonnement Gold';

  @override
  String get silverBadgeLabel => 'Abonnement Silver';

  @override
  String get topBewertetBadgeLabel => 'Top évalué';

  @override
  String get badgeCertified => 'Certifié';

  @override
  String get badgeExperienced => 'Expérimenté';

  @override
  String get badgeExpert => 'Expert';

  @override
  String get badgeMaster => 'Maître';

  @override
  String badgeCertifiedCounter(Object count) {
    return '$count missions terminées';
  }

  @override
  String badgeExperiencedCounter(Object count) {
    return '$count missions terminées';
  }

  @override
  String badgeExpertCounter(Object count) {
    return '$count missions terminées';
  }

  @override
  String badgeMasterCounter(Object count) {
    return '$count missions terminées';
  }

  @override
  String get achievementTitle => 'Succès & Badges';

  @override
  String get goldBadgeDesc => 'Vous avez un abonnement Gold et pouvez accepter un nombre illimité de missions.';

  @override
  String get silverBadgeDesc => 'Vous avez un abonnement Silver et pouvez accepter 3 missions par semaine.';

  @override
  String get topBewertetBadgeDesc => 'Obtenez une moyenne d\'au moins 4,5 étoiles sur au moins 5 évaluations.';

  @override
  String badgeCertifiedProgress(Object count) {
    return 'Certifié ($count/1)';
  }

  @override
  String get badgeCertifiedDesc => 'Terminez 3 missions.';

  @override
  String badgeExperiencedProgress(Object count) {
    return 'Expérimenté ($count/2)';
  }

  @override
  String get badgeExperiencedDesc => 'Terminez un total de 10 missions.';

  @override
  String badgeExpertProgress(Object count) {
    return 'Expert ($count/3)';
  }

  @override
  String get badgeExpertDesc => 'Terminez un total de 25 missions.';

  @override
  String badgeMasterProgress(Object count) {
    return 'Maître ($count/4)';
  }

  @override
  String get badgeMasterDesc => 'Terminez un total de 50 missions.';

  @override
  String get trafficScreenInfoText => 'Ici, vous voyez combien de prestataires de services sont actuellement actifs par catégorie dans votre région. Plus il y a de prestataires, plus votre demande sera généralement acceptée rapidement.';

  @override
  String get filterAbgeschlossen => 'Terminé';

  @override
  String get auftraege => 'Travaux';

  @override
  String get profil => 'Profil';

  @override
  String get filterAlle => 'Tous';

  @override
  String get filterOffen => 'Ouvert';

  @override
  String get filterLaufend => 'En cours';

  @override
  String get forgotPasswordButton => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordInfo => 'Saisissez votre adresse e-mail enregistrée. Vous recevrez un lien pour réinitialiser votre mot de passe.';

  @override
  String get sendResetLinkButton => 'Envoyer le lien de réinitialisation';

  @override
  String get resetMailSent => 'Le lien a été envoyé. Vérifiez votre boîte de réception !';

  @override
  String get keineDienstleisterInRegion => 'Aucun prestataire de services trouvé dans votre région.';

  @override
  String get trafficScreenKeineAdresse => 'Aucune adresse trouvée dans votre profil.';

  @override
  String get trafficScreenAdresseFehler => 'Votre adresse n’a pas pu être convertie en coordonnées.';

  @override
  String get auftragWiederkehrendAppBar => 'Mission récurrente';

  @override
  String get auftragWiederkehrendHeadline => 'Cette mission doit-elle être répétée régulièrement ?';

  @override
  String get auftragWiederkehrendInfo => 'Choisissez si et à quelle fréquence la mission doit être effectuée automatiquement.';

  @override
  String get auftragReviewAppBar => 'Vérifier et envoyer';

  @override
  String get auftragReviewHeadline => 'Tout est correct ?';

  @override
  String get auftragReviewInfo => 'Veuillez vérifier vos informations avant d\'envoyer la mission.';

  @override
  String get absendenButton => 'Envoyer';

  @override
  String get ja => 'Oui';

  @override
  String get nein => 'Non';

  @override
  String get wiederholenBisLabelPlain => 'Répéter jusqu\'au';

  @override
  String get auftragAdresseAppBar => 'Adresse & Contact';

  @override
  String get auftragAdresseHeadline => 'Où la mission doit-elle être réalisée ?';

  @override
  String get auftragAdresseInfo => 'Veuillez saisir l\'adresse et votre numéro de téléphone pour que le prestataire puisse vous contacter.';

  @override
  String get adresseHint => 'ex. 12 rue Exemple, 12345 Paris';

  @override
  String get telefonnummerHint => 'ex. 06 12 34 56 78';

  @override
  String get zurueckButton => 'Retour';

  @override
  String get weiterButton => 'Suivant';

  @override
  String get auftragKategorieAppBar => 'Choisir une catégorie';

  @override
  String get auftragKategorieHeadline => 'Pour quelle catégorie cherchez-vous de l\'aide ?';

  @override
  String get auftragKategorieInfo => 'Choisissez le service approprié. Vous pourrez donner plus de détails ensuite.';

  @override
  String get kategorieValidator => 'Veuillez choisir une catégorie.';

  @override
  String get auftragDetailsAppBar => 'Détails de la mission';

  @override
  String get auftragDetailsHeadline => 'Décrivez votre mission';

  @override
  String get auftragDetailsInfo => 'Que doit-on faire ? Plus c\'est précis, mieux c\'est !';

  @override
  String get auftragTerminAppBar => 'Date et heure';

  @override
  String get auftragTerminHeadline => 'Quand la mission doit-elle être effectuée ?';

  @override
  String get auftragTerminInfo => 'Définissez la date et l\'heure ou choisissez \'dès que possible\'.';

  @override
  String get terminLabel => 'Date';

  @override
  String get preisLabel => 'Prix (€) ou \'négociable\'';

  @override
  String get preisHint => 'ex: 60 ou \'négociable\'';

  @override
  String get preisValidator => 'Veuillez entrer un prix valide ou \'négociable\'.';

  @override
  String get preisHinweisLabel => 'Note sur le prix (optionnel)';

  @override
  String get preisHinweisHint => 'ex: taux horaire, frais de matériel, négociable, etc.';

  @override
  String get preisTypLabel => 'Choisir l’option de prix';

  @override
  String get preisTypGesamt => 'Prix total';

  @override
  String get preisTypStunden => 'Tarif horaire';

  @override
  String get preisTypVerhandelbar => 'À convenir / négociable';

  @override
  String get preisLabelGesamt => 'Prix total (€)';

  @override
  String get preisHintGesamt => 'p.ex. 120';

  @override
  String get preisLabelStunden => 'Tarif horaire (€ par heure)';

  @override
  String get preisHintStunden => 'p.ex. 20';

  @override
  String get preisHinweisVerhandelbar => 'Prix à convenir / offres bienvenues';

  @override
  String get preisTypGesamtDesc => 'Vous indiquez le prix total pour la mission.';

  @override
  String get preisTypStundenDesc => 'Vous indiquez un tarif horaire pour la mission.';

  @override
  String get preisTypVerhandelbarDesc => 'Le prix sera négocié directement avec le prestataire.';

  @override
  String get heimatadresseButtonInfo => 'Clique ici pour remplir automatiquement ton adresse principale enregistrée.';

  @override
  String get verhandelbarLabel => 'Négociable';

  @override
  String get terminValidierungFehler => 'Veuillez sélectionner une date et les deux heures.';

  @override
  String get wiederkehrendValidierungFehler => 'Veuillez sélectionner correctement l’intervalle, le jour de la semaine et le nombre de répétitions pour les tâches récurrentes.';

  @override
  String priceTotal(Object amount) {
    return '$amount €';
  }

  @override
  String pricePerHour(Object amount, Object hourShort) {
    return '$amount € / $hourShort';
  }

  @override
  String get priceNegotiable => 'Négociable';

  @override
  String get hourShort => 'h';

  @override
  String get setNewPasswordTitle => 'Définir un nouveau mot de passe';

  @override
  String get setNewPasswordInfo => 'Saisissez votre nouveau mot de passe deux fois pour confirmer.';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get confirmNewPasswordLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get saveNewPasswordButton => 'Enregistrer le nouveau mot de passe';

  @override
  String get passwordEmptyError => 'Le mot de passe ne peut pas être vide.';

  @override
  String get passwordsDontMatch => 'Les mots de passe ne correspondent pas.';

  @override
  String get passwordResetSuccess => 'Mot de passe réinitialisé avec succès. Vous pouvez maintenant vous connecter.';

  @override
  String get premiumRestorePurchases => 'Restaurer les achats';

  @override
  String get premiumRetry => 'Réessayer';

  @override
  String get wrongRoleCustomer => 'Ce compte est enregistré comme prestataire de services et ne peut pas être utilisé pour la connexion client.';

  @override
  String get accountNotRegistered => 'Aucun compte trouvé avec cet e-mail. Veuillez vous inscrire d\'abord.';

  @override
  String get wrongCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get premiumPushDelayFree => 'Notifications push : délai de 1 h';

  @override
  String get premiumPushDelaySilver => 'Notifications push : délai de 30 min';

  @override
  String get premiumPushDelayGold => 'Notifications push : immédiates pour les nouvelles missions';

  @override
  String get companyNameOptional => 'Nom de l’entreprise (optionnel)';

  @override
  String get vatIdOptional => 'N° TVA (optionnel)';

  @override
  String get bicOptional => 'BIC (optionnel)';

  @override
  String get smallBusinessLabel => 'Petit entrepreneur selon §19 UStG';

  @override
  String get defaultVatRateLabel => 'Taux de TVA standard (%)';

  @override
  String get invalidVatRate => 'Taux de TVA invalide';

  @override
  String get profileNameLabel => 'Nom complet';

  @override
  String get invoiceNoShort => 'N° :';

  @override
  String get netAmountLabel => 'Net';

  @override
  String vatLabelWithPercent(Object percent) {
    return 'TVA ($percent%)';
  }

  @override
  String get totalLabel => 'Total';

  @override
  String get dueOnLabel => 'Échéance :';

  @override
  String get vatIdLabel => 'N° TVA :';

  @override
  String get bicLabel => 'BIC :';

  @override
  String paymentTermsDefault(Object days) {
    return 'Payable sous $days jours sans déduction.';
  }

  @override
  String get badgeInfoText => 'Ces badges ne peuvent être obtenus que par les prestataires et s\'affichent lorsque le prestataire accepte la mission.';

  @override
  String get noAuftraegeKundeHint => 'Créez votre première demande en appuyant sur le bouton plus (+).';

  @override
  String get upsellCardTitle => 'Mission près de chez vous';

  @override
  String upsellCategoryLabel(String category) {
    return 'Catégorie : $category';
  }

  @override
  String upsellUpgradeButton(String plan) {
    return 'Passez à $plan pour voir cette mission';
  }

  @override
  String get planFree => 'Gratuit';

  @override
  String get planSilver => 'Argent';

  @override
  String get planGold => 'Or';

  @override
  String get filterNeu => 'Nouveau';

  @override
  String onlyNewWindowInfo(int hours) {
    return 'Affiche les missions des $hours dernières heures.';
  }

  @override
  String get cancelLabel => 'Annuler';

  @override
  String get editProfileCta => 'Compléter le profil';

  @override
  String get update_required_title => 'Mise à jour requise';

  @override
  String get update_required_message => 'Veuillez mettre à jour l’app pour continuer.';

  @override
  String get update_available_title => 'Mise à jour disponible';

  @override
  String get update_available_message => 'Une nouvelle version est disponible. Mettre à jour maintenant ?';

  @override
  String get update_action_update_now => 'Mettre à jour';

  @override
  String get update_action_later => 'Plus tard';

  @override
  String get invoiceSectionSubtitle => 'Facultatif : informations d’entreprise et fiscales pour la facturation automatique';

  @override
  String get marketplaceTitle => 'Échanger des missions';

  @override
  String get marketplaceTabSell => 'Vendre';

  @override
  String get marketplaceTabBuy => 'Acheter';

  @override
  String get marketplaceOfferCreateCta => 'Transférer une mission';

  @override
  String get marketplaceFilter => 'Filtrer';

  @override
  String get marketplaceSort => 'Trier';

  @override
  String get marketplaceBuyNow => 'Postuler';

  @override
  String get marketplaceSnackOpenForm => 'Ouverture du formulaire d’offre…';

  @override
  String get marketplaceSnackStartCheckout => 'Démarrage du paiement…';

  @override
  String marketplaceOfferTitle(int index) {
    return 'Offre n°$index';
  }

  @override
  String marketplaceOfferSubtitle(String category, String price, Object distanceKm) {
    return '$category • $distanceKm km';
  }

  @override
  String marketplaceBuyTitle(int index) {
    return 'Annonce n°$index · Petite réparation';
  }

  @override
  String marketplaceBuySubtitle(String category, String price, String distance) {
    return 'Catégorie : $category · $price/h · $distance km';
  }

  @override
  String get marketplaceEmptyList => 'Aucune offre correspondante.';

  @override
  String get marketplaceErrorLoading => 'Impossible de charger la liste.';

  @override
  String get marketplaceAppliedSuccess => 'Candidature envoyée — le vendeur peut la voir.';

  @override
  String get marketplaceAlreadyApplied => 'Vous avez déjà candidaté.';

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
    return 'Prix cible : $price';
  }

  @override
  String marketplaceChipProvision(Object value) {
    return 'Commission : $value';
  }

  @override
  String get s0Title => 'Transmettre la mission (S0)';

  @override
  String get sectionBasics => 'Informations de base';

  @override
  String get fieldTitle => 'Titre';

  @override
  String get hintTitleExample => 'ex. Rénovation de toit, 120 m²';

  @override
  String get fieldDescription => 'Description';

  @override
  String get hintDescription => 'Brève description, particularités, matériaux inclus/exclus.';

  @override
  String get fieldLocation => 'Lieu/rayon (pour l’instant texte)';

  @override
  String get hintLocation => 'ex. Cologne, 15 km';

  @override
  String get pickStartDate => 'Choisir la date de début';

  @override
  String get pickDeadline => 'Choisir la date limite';

  @override
  String get labelStart => 'Début';

  @override
  String get labelDeadline => 'Date limite';

  @override
  String get sectionS0PriceProvision => 'S0 – Prix & Commission';

  @override
  String get tooltipS0PriceProvision => 'Prix cible = prix total de la mission.\nCommission = rémunération pour la transmission.';

  @override
  String get fieldTargetPriceEur => 'Prix cible (EUR)';

  @override
  String get hintTargetPriceExample => 'ex. 12 500';

  @override
  String get helpTargetPrice => 'Valeur totale reprise par l’acheteur.';

  @override
  String get fieldProvisionType => 'Type de commission';

  @override
  String get provisionTypePercent => 'Pourcentage';

  @override
  String get provisionTypeFixed => 'Fixe';

  @override
  String get fieldProvisionValuePercent => 'Commission (%)';

  @override
  String get fieldProvisionValueFixed => 'Commission (€)';

  @override
  String get helpProvisionPercent => 'Usuel : 5–12 % (plafond possible).';

  @override
  String get helpProvisionFixed => 'Montant fixe de commission.';

  @override
  String get fieldProvisionDue => 'Quand la commission est-elle due ?';

  @override
  String get provisionDueAward => 'lors de l’attribution';

  @override
  String get provisionDueHandover => 'à la remise';

  @override
  String get provisionDueFinalInvoice => 'à la facture finale';

  @override
  String get provisionDueAwardHelp => 'Lors de l’attribution : la commission est due immédiatement après l’attribution.';

  @override
  String get provisionDueHandoverHelp => 'À la remise : après l’accord client et la remise.';

  @override
  String get provisionDueFinalInvoiceHelp => 'À la facture finale : quand l’acheteur termine la mission.';

  @override
  String get sectionEvidencePlaceholder => 'Justificatifs (placeholder)';

  @override
  String get btnUploadEvidence => 'Téléverser offre/accord client';

  @override
  String get btnCreateDraft => 'Créer un brouillon';

  @override
  String get btnSaving => 'Enregistrement…';

  @override
  String get noteSupabaseActive => 'Remarque : stockage Supabase actif. Paiements & envois plus tard.';

  @override
  String get formErrorRequired => 'Obligatoire';

  @override
  String get formErrorInvalidAmount => 'Montant invalide';

  @override
  String get formErrorGreaterZero => 'Doit être > 0';

  @override
  String get formErrorRealistic => 'Restez réaliste';

  @override
  String get formErrorInvalidValue => 'Valeur invalide';

  @override
  String get formErrorPercentRange => 'Plage autorisée : 0–30 %';

  @override
  String get errPickStartDate => 'Veuillez choisir une date de début';

  @override
  String get errPickDeadline => 'Veuillez choisir une date limite';

  @override
  String get draftSaved => 'Brouillon S0 enregistré.';

  @override
  String get genericError => 'Une erreur s’est produite.';

  @override
  String get btnMyDeals => 'Mes offres';

  @override
  String get myDealsTitle => 'Mes offres';

  @override
  String get myDealsEmpty => 'Aucune mission pour l’instant.';

  @override
  String get myDealsErrorLoading => 'Vos missions n’ont pas pu être chargées.';

  @override
  String get filterAll => 'Toutes';

  @override
  String get filterDraft => 'Brouillons';

  @override
  String get filterLive => 'En ligne';

  @override
  String get filterAwarded => 'Attribuées';

  @override
  String get manageTitle => 'Gérer la mission';

  @override
  String get manageErrorLoading => 'Impossible de charger les détails.';

  @override
  String get btnPublish => 'Publier';

  @override
  String get publishSuccess => 'Mission publiée.';

  @override
  String get applicationsTitle => 'Candidatures';

  @override
  String get applicationsEmpty => 'Aucune candidature pour le moment.';

  @override
  String get applicationNote => 'Note';

  @override
  String get applicationStatusPending => 'Statut : en attente';

  @override
  String get applicationStatusAwarded => 'Statut : attribuée';

  @override
  String get btnAward => 'Attribuer';

  @override
  String get btnManage => 'Gérer';

  @override
  String get labelStatus => 'Statut';

  @override
  String get statusDraft => 'Brouillon';

  @override
  String get statusLive => 'En ligne';

  @override
  String get statusAwarded => 'Attribuée';

  @override
  String get awardSuccess => 'Candidature attribuée avec succès.';

  @override
  String get snackNewApplication => 'Nouvelle candidature reçue';

  @override
  String applicationsCount(Object count) {
    return '$count candidatures';
  }

  @override
  String get btnApplied => 'Candidaté';

  @override
  String get s0EditTitle => 'Modifier S0';

  @override
  String get publishNow => 'Publier après enregistrement';

  @override
  String get publishNowHint => 'Si activé, le brouillon passera en « En ligne » après l’enregistrement.';

  @override
  String get btnSaveChanges => 'Enregistrer les modifications';

  @override
  String get saved => 'Enregistré';

  @override
  String get marketplaceLocationLoadedFromProfile => 'Position chargée depuis votre profil — filtre de rayon actif.';

  @override
  String get marketplaceNoHomeAddressHint => 'Aucune adresse dans le profil — affichage de toutes les offres sans filtre de distance.';

  @override
  String get fieldCategory => 'Catégorie';

  @override
  String get categoryAll => 'Tous';

  @override
  String get categoryRoofer => 'Couvreur';

  @override
  String get categorySolar => 'PV / Solaire';

  @override
  String get categoryHVAC => 'Chauffage / Plomberie / CVC';

  @override
  String get categoryElectrical => 'Électricité';

  @override
  String get categoryDrywall => 'Cloisons sèches';

  @override
  String get categoryPainter => 'Peintre';

  @override
  String get categoryTiling => 'Carrelage';

  @override
  String get categoryFlooring => 'Revêtements de sol';

  @override
  String get categoryWindowsDoors => 'Fenêtres & Portes';

  @override
  String get categoryInsulationFacade => 'Isolation & Façade';

  @override
  String get categoryMasonryConcrete => 'Maçonnerie & Béton';

  @override
  String get categoryCarpentryJoinery => 'Charpente & Menuiserie';

  @override
  String get categoryLandscaping => 'Aménagement paysager';

  @override
  String get categoryScaffolding => 'Échafaudage';

  @override
  String get categoryCleaningRestoration => 'Nettoyage & Restauration';

  @override
  String get categoryMovingTransport => 'Déménagement & Transport';

  @override
  String get sectionCustomerOk => 'Accord du client';

  @override
  String get helpCustomerOk => 'Preuve que le client accepte le transfert (ex. devis signé, e-mail/SMS en PDF/photo).';

  @override
  String get btnUploadCustomerOk => 'Téléverser l’accord client';

  @override
  String get customerNameOptional => 'Nom du client (optionnel)';

  @override
  String get customerPhoneOptional => 'Téléphone (optionnel)';

  @override
  String get sectionOffer => 'Devis / Confirmation de commande';

  @override
  String get helpOfferOptional => 'Votre devis ou confirmation. Optionnel mais utile pour les acheteurs.';

  @override
  String get btnUploadOffer => 'Téléverser le devis';

  @override
  String get errCustomerOkRequired => 'Au moins un document d’accord client est requis pour publier.';

  @override
  String get warnMissingDocsBody => 'Info : sans accord/devis, vous ne pourrez pas publier plus tard. Vous pouvez ajouter les documents à tout moment.';

  @override
  String get attestLabel => 'Je confirme sincèrement que le client a donné son accord et que toutes les informations sont exactes.';

  @override
  String get attestConsequences => 'En cas de fausses déclarations, nous pouvons suspendre le compte, retenir les paiements et engager des actions civiles et, le cas échéant, pénales.';

  @override
  String get errAttestRequired => 'Vous devez cocher la confirmation pour publier.';

  @override
  String get genericPleaseFix => 'Veuillez corriger les champs indiqués :';

  @override
  String get errAwardNeedsDoc => 'Si l’échéance est « à l’attribution », un document/devis est requis.';

  @override
  String get errNotOwner => 'Vous n’êtes pas le propriétaire de cette mission.';

  @override
  String get errPublishOnlyFromDraft => 'La publication n’est possible qu’à partir du statut brouillon.';

  @override
  String get publishRequirementsTitle => 'Conditions de publication';

  @override
  String get infoReqCustomerOk => 'Au moins un accord client est joint.';

  @override
  String get infoReqDocForAward => 'Pour « à l’attribution » : téléchargez le devis/bon de commande.';

  @override
  String get infoReqAttest => 'La confirmation dans le formulaire est cochée.';

  @override
  String get draftChecklistTitle => 'Checklist avant publication';

  @override
  String get chkTitle => 'Titre renseigné';

  @override
  String get chkDescription => 'Description renseignée';

  @override
  String get chkLocation => 'Adresse/lieu défini';

  @override
  String get chkTargetPrice => 'Prix cible défini';

  @override
  String get chkCustomerOk => 'Accord client présent';

  @override
  String get chkDocIfAward => 'Document/devis présent (recommandé si « à l’attribution »)';

  @override
  String get chkAttestAtPublish => 'Cocher la confirmation lors de la publication';

  @override
  String get draftChecklistCta => 'Ouvrir la gestion';

  @override
  String get uploadSuccess => 'Upload successful.';

  @override
  String get uploadInProgress => 'Uploading...';

  @override
  String get uploadFailed => 'Upload failed.';

  @override
  String get draftDefaultTitle => 'Brouillon';

  @override
  String get errGeocodingFailed => 'L’adresse n’a pas pu être géocodée.';

  @override
  String get provisionDueAwardLabel => 'Attribution';

  @override
  String get provisionDueHandoverLabel => 'Remise';

  @override
  String get provisionDueFinalInvoiceLabel => 'Facture finale';

  @override
  String get sectionPreviewPublic => 'Aperçu (public)';

  @override
  String get tooltipPreviewPublic => 'Ces fichiers sont visibles avant l’achat. Téléchargez uniquement des aperçus anonymisés/expurgés.';

  @override
  String get btnUploadPreview => 'Téléverser un aperçu';

  @override
  String get previewRedactionNoticeTitle => 'Avis important concernant l’aperçu';

  @override
  String get previewRedactionNoticeBody => 'Les aperçus sont visibles par les acheteurs avant l’achat. Masquez les données sensibles (noms, adresses, numéros de téléphone, n° de contrat/client, signatures, codes QR/barres). Ne téléversez pas de documents contenant des données personnelles non masquées.';

  @override
  String get hintPhoneExample => '+33 6 12 34 56 78';

  @override
  String get createDealTitle => 'Créer une offre';

  @override
  String get chooseDealTypeTitle => 'Choisir le type d’offre';

  @override
  String get dealTypeS0Title => 'S0 – Revente du chantier';

  @override
  String get dealTypeS0Subtitle => 'Céder l’intégralité du chantier à un autre prestataire.';

  @override
  String get dealTypeS1Title => 'S1 – Sous-lot/Sous-traitance (jalons)';

  @override
  String get dealTypeS1Subtitle => 'Sous-traitance avec jalons et justificatifs.';

  @override
  String get s1Title => 'Rechercher des sous-traitants (S1)';

  @override
  String get sectionS1Pricing => 'Tarification';

  @override
  String get sectionS1Provision => 'Commission';

  @override
  String get sectionMilestones => 'Jalons';

  @override
  String get pricingModeFixed => 'Prix fixe';

  @override
  String get pricingModeTm => 'Temps & Matériel';

  @override
  String get basePriceLabel => 'Budget total (€)';

  @override
  String get hourlyRateLabel => 'Taux horaire (€)';

  @override
  String get expectedHoursLabel => 'Heures estimées';

  @override
  String get dueTypeAward => 'Attribution';

  @override
  String get dueTypeDate => 'Date';

  @override
  String get dueTypeHandover => 'Remise';

  @override
  String get dueTypeCustom => 'Personnalisé';

  @override
  String get dueTypeCustomHelp => 'Déclencheur d’échéance personnalisé (indiquer une date/un commentaire).';

  @override
  String get milestoneLabel => 'Jalon';

  @override
  String get milestoneTitle => 'Titre du jalon';

  @override
  String get milestoneDescription => 'Description du jalon';

  @override
  String get milestoneAmount => 'Montant (€)';

  @override
  String get milestonePercent => 'Pourcentage (%)';

  @override
  String get milestoneDue => 'Échéance';

  @override
  String get btnAddMilestonePercent => 'Ajouter un jalon (%)';

  @override
  String get btnAddMilestoneAmount => 'Ajouter un jalon (€)';

  @override
  String get milestoneEmptyHint => 'Aucun jalon pour l’instant (optionnel).';

  @override
  String get milestoneBlocking => 'Bloquant';

  @override
  String get milestoneBlockingHelp => 'Doit être terminé avant de débloquer l’étape suivante.';

  @override
  String get validationMilestoneSum => 'Les totaux des jalons ne correspondent pas : 100 % requis en mode pourcentage, ou égal au budget total en prix fixe.';

  @override
  String get btnReorder => 'Réorganiser';

  @override
  String get infoS1PricingHelp => 'Comment vous tarifez le travail sous-traité. « Forfait » = un budget total pour le lot. « Temps & matériel » = taux horaire + heures estimées ; la facturation réelle se fait au temps passé.';

  @override
  String get infoS1ProvisionHelp => 'Votre commission par sous-traitant attribué. Définissez un pourcentage ou un montant fixe et son exigibilité.';

  @override
  String get coordChipNoCoords => 'Pas de coordonnées';

  @override
  String get coordMissingLabel => 'Coordonnées (lat/lng)';

  @override
  String get s0DetailsMissingLabel => 'Détails S0';

  @override
  String get s1DetailsMissingLabel => 'Détails S1';

  @override
  String get marketplaceTypeS0 => 'S0 – Transmission de mission';

  @override
  String get marketplaceTypeS1 => 'S1 – Recherche de sous-traitant';

  @override
  String get filterTypeAll => 'Tous les types';

  @override
  String get filterTypeS0 => 'S0 uniquement';

  @override
  String get filterTypeS1 => 'S1 uniquement';

  @override
  String get badgeAwardedToYou => 'Attribué (pour vous)';

  @override
  String get badgeAwardedGiven => 'Attribution effectuée';

  @override
  String get btnAssigned => 'Attribué';

  @override
  String get marketplaceOwnDealPill => 'Votre mission';
}
