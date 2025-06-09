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
  String get passwordTooShort => 'Le mot de passe doit comporter au moins 6 caractères';

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
  String get descriptionLabel => 'Description';

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
  String get premiumFreeFeature1 => 'Rayon d\'intervention : 10 km';

  @override
  String get premiumFreeFeature2 => 'Max. 2 missions/semaine';

  @override
  String get premiumFreeFeature3 => 'Changement rare de catégorie/adresse';

  @override
  String get premiumSilverPrice => '4,99 € / mois';

  @override
  String get premiumSilverFeature1 => 'Rayon d\'intervention : 30 km';

  @override
  String get premiumSilverFeature2 => 'Max. 5 missions/semaine';

  @override
  String get premiumSilverFeature3 => 'Changer catégorie/adresse à tout moment';

  @override
  String get premiumSilverFeature4 => 'Visibilité normale';

  @override
  String get premiumGoldPrice => '9,99 € / mois';

  @override
  String get premiumGoldFeature1 => 'Rayon d\'intervention : 70 km';

  @override
  String get premiumGoldFeature2 => 'Missions illimitées';

  @override
  String get premiumGoldFeature3 => 'Profil mis en avant';

  @override
  String get premiumGoldFeature4 => 'Support Premium';

  @override
  String get premiumGoldFeature5 => 'Changer catégorie/adresse à tout moment';

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
}
