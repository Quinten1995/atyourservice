// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get registerAppBar => 'Registration';

  @override
  String get registerTitle => 'Sign Up';

  @override
  String get roleLabel => 'Select a role';

  @override
  String get roleKunde => 'Customer';

  @override
  String get roleDienstleister => 'Service Provider';

  @override
  String get categoryLabel => 'Category';

  @override
  String get categoryValidator => 'Please select a category';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailEmpty => 'Please enter an email';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordEmpty => 'Please enter a password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get registerButton => 'Register';

  @override
  String get registerSuccess => 'Registration successful! Please confirm your email.';

  @override
  String get registerExists => 'This email is already registered. Please log in or reset your password.';

  @override
  String get registerInvalidEmail => 'Please enter a valid email address.';

  @override
  String get registerPasswordShort => 'Password must be at least 6 characters.';

  @override
  String registerFailed(Object error) {
    return 'Registration failed: $error';
  }

  @override
  String registerUnknownError(Object error) {
    return 'Unknown error: $error';
  }

  @override
  String get profileAppBar => 'Service Provider Profile';

  @override
  String get profileAddressLabel => 'Home Address (e.g. Example Street 12, 12345 Example City)';

  @override
  String get profileAddressEmpty => 'Please enter address';

  @override
  String get profileSaveButton => 'Save profile';

  @override
  String get profileAddressSaved => 'Address saved!';

  @override
  String profileLoadError(Object error) {
    return 'Error loading: $error';
  }

  @override
  String profileSaveError(Object error) {
    return 'Error saving: $error';
  }

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get pleaseLogin => 'Please log in first';

  @override
  String get changeNotAllowedTitle => 'Change Not Allowed';

  @override
  String changeNotAllowedContent(Object date) {
    return 'As a free user, you can only change your category or address every 20 days.\nNext change allowed from: $date';
  }

  @override
  String get ok => 'OK';

  @override
  String get profileSaved => 'Profile saved successfully!';

  @override
  String get changeProfileImage => 'Change profile picture';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get noRatingsYet => 'No ratings yet';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameValidator => 'Please enter name';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get addressLabel => 'Address (e.g. street, zip code, city)';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get phoneValidator => 'Please enter a phone number';

  @override
  String get emailEmptyValidator => 'Please enter your email';

  @override
  String get emailInvalidValidator => 'Please enter a valid email';

  @override
  String errorPrefix(Object error) {
    return 'Error: $error';
  }

  @override
  String changeLimitHint(Object date) {
    return 'Category/address can only be changed from $date.';
  }

  @override
  String get addressNotFound => 'Address not found. Please check.';

  @override
  String ratingsCount(Object count) {
    return '($count ratings)';
  }

  @override
  String get premiumAppBar => 'Upgrade to Premium';

  @override
  String get premiumChoosePlan => 'Choose your Premium Plan';

  @override
  String get premiumCurrentPlan => 'Current Subscription:';

  @override
  String get premiumFreePrice => 'free';

  @override
  String get premiumSilverPrice => '€4.99 / month';

  @override
  String get premiumGoldPrice => '€9.99 / month';

  @override
  String get premiumFreeFeature1 => 'Accept 1 job per week';

  @override
  String get premiumFreeFeature2 => 'Jobs within a 5 km radius';

  @override
  String get premiumFreeFeature3 => 'Basic categories only';

  @override
  String get premiumFreeFeature4 => 'Category change only every 20 days';

  @override
  String get premiumSilverFeature1 => 'Unlimited job acceptance';

  @override
  String get premiumSilverFeature2 => 'Jobs within a 15 km radius';

  @override
  String get premiumSilverFeature3 => 'All categories available';

  @override
  String get premiumGoldFeature1 => 'Unlimited job acceptance';

  @override
  String get premiumGoldFeature2 => 'Jobs within a 40 km radius';

  @override
  String get premiumGoldFeature3 => 'All categories available';

  @override
  String get premiumGoldFeature4 => 'Premium user badge (visible to clients)';

  @override
  String premiumChooseButton(Object title) {
    return 'Choose $title';
  }

  @override
  String get premiumPaymentNote => 'Note: All payments are securely processed via Apple or Google. You can cancel or manage your subscription anytime in the store.';

  @override
  String get premiumSilverComingSoon => 'Silver coming soon!';

  @override
  String get premiumGoldComingSoon => 'Gold coming soon!';

  @override
  String get auftragHidden => 'Job hidden.';

  @override
  String auftragHideError(Object error) {
    return 'Error hiding job: $error';
  }

  @override
  String get meineAuftraegeAppBar => 'My Jobs';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get noAuftraegeFound => 'No jobs found.';

  @override
  String get geplanterAuftrag => 'Scheduled job';

  @override
  String get auftragAusblenden => 'Hide job';

  @override
  String get loginFailedDetails => 'Login failed. Please check your credentials or confirm your email.';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String loginFailedPrefix(Object error) {
    return 'Login failed: $error';
  }

  @override
  String loginUnknownError(Object error) {
    return 'Unknown error: $error';
  }

  @override
  String get emailValidatorEmpty => 'Please enter an email';

  @override
  String get emailValidatorInvalid => 'Please enter a valid email';

  @override
  String get passwordValidatorEmpty => 'Please enter a password';

  @override
  String get passwordValidatorShort => 'Password must be at least 6 characters';

  @override
  String get loginKundeAppBar => 'Customer Login';

  @override
  String get loginKundeHeadline => 'Sign In';

  @override
  String get loginButton => 'Login';

  @override
  String get noAccountYet => 'No account yet? Register now';

  @override
  String get loginFailedDetailsDL => 'Login failed. Please check your credentials or confirm your email.';

  @override
  String get wrongRoleDL => 'This account is not a service provider. Please use the customer login.';

  @override
  String get loginDLAppBar => 'Service Provider Login';

  @override
  String get loginDLHeadline => 'Sign In';

  @override
  String get kundenDashboardHeader => 'Your Dashboard';

  @override
  String get kundenDashboardAppBar => 'Customer Dashboard';

  @override
  String get laufendeAuftraege => 'Ongoing jobs';

  @override
  String statusPrefix(Object status) {
    return 'Status: $status';
  }

  @override
  String dienstleisterPrefix(Object dienstleister) {
    return 'Service provider: $dienstleister';
  }

  @override
  String get offeneAuftraege => 'Open jobs';

  @override
  String get noOffeneAuftraege => 'No open jobs found.';

  @override
  String get abgeschlosseneAuftraege => 'Completed jobs';

  @override
  String get abgeschlossenStatus => 'Completed';

  @override
  String get neuerAuftrag => 'New job';

  @override
  String get pleaseCreateProfile => 'Please create your profile first.';

  @override
  String get profilMissingCategory => 'Category missing in profile.';

  @override
  String get dienstleisterDashboardHeader => 'Your Dashboard';

  @override
  String get dienstleisterDashboardAppBar => 'Service Provider Dashboard';

  @override
  String get meineLaufendenAuftraege => 'My ongoing jobs';

  @override
  String kundePrefix(Object kunde) {
    return 'Customer: $kunde';
  }

  @override
  String get offenePassendeAuftraege => 'Open matching jobs';

  @override
  String get noPassendeAuftraege => 'No matching jobs found.';

  @override
  String entfernungSuffix(Object dist) {
    return '$dist km away';
  }

  @override
  String get auftragBereitsBewertet => 'You have already rated this job.';

  @override
  String get bewertungDialogTitle => 'Rate service provider';

  @override
  String get bewertungKommentarLabel => 'Comment (optional)';

  @override
  String get abbrechen => 'Cancel';

  @override
  String get abschicken => 'Submit';

  @override
  String get auftragErstellenTitle => 'Create new job';

  @override
  String get auftragEinstellenUeberschrift => 'Post a job now';

  @override
  String get titelLabel => 'Title';

  @override
  String get titelValidator => 'Please enter a title';

  @override
  String get beschreibungLabel => 'Description';

  @override
  String get kategorieLabel => 'Category';

  @override
  String get heimatadresseEinfuegen => 'Insert home address';

  @override
  String get adresseLabel => 'Address (e.g. Alter Markt 76, 50667 Cologne)';

  @override
  String get telefonnummerLabel => 'Phone number';

  @override
  String get telefonnummerValidator => 'Please enter a phone number';

  @override
  String get ausfuehrungszeitpunkt => 'Execution time';

  @override
  String get soSchnellWieMoeglich => 'As soon as possible';

  @override
  String get geplant => 'Planned';

  @override
  String get datumWaehlen => 'Choose date';

  @override
  String get zeitVon => 'Time from';

  @override
  String get zeitBis => 'Time to';

  @override
  String get wiederkehrendCheckbox => 'Recurring job?';

  @override
  String get intervallLabel => 'Interval';

  @override
  String get intervallValidator => 'Please select an interval';

  @override
  String get wochentagLabel => 'Weekday';

  @override
  String get wochentagValidator => 'Please select a weekday';

  @override
  String get anzahlWiederholungenLabel => 'Number of repetitions (optional)';

  @override
  String get wiederholenBisNichtGesetzt => 'Repeat until: not set';

  @override
  String wiederholenBisLabel(Object date) {
    return 'Repeat until: $date';
  }

  @override
  String get auftragAbschicken => 'Submit job';

  @override
  String get auftragGespeichert => 'Job saved!';

  @override
  String get bitteEinloggen => 'Please log in first';

  @override
  String get adresseNichtGefunden => 'Address not found.';

  @override
  String unbekannterFehler(Object error) {
    return 'Unknown error: $error';
  }

  @override
  String get auftragDetailTitle => 'Job details';

  @override
  String get nichtEingeloggt => 'Not logged in';

  @override
  String get rolleNichtErmittelt => 'Role could not be determined';

  @override
  String get auftragNichtGefunden => 'Job not found';

  @override
  String get bewertungDanke => 'Thank you for your rating!';

  @override
  String get limitErreicht => 'Limit reached';

  @override
  String get limitFree => 'As a freemium service provider, you can accept up to 2 jobs per week. Upgrade to Silver or Gold for more options!';

  @override
  String get limitSilver => 'As a Silver service provider, you can accept up to 5 jobs per week. Upgrade to Gold for unlimited jobs!';

  @override
  String get auftragAnnehmen => 'Accept job';

  @override
  String get auftragBeenden => 'Complete job';

  @override
  String get auftragEntfernenUebersicht => 'Remove job from overview';

  @override
  String get auftragEntfernen => 'Remove job';

  @override
  String get auftragEntfernenTitel => 'Remove job?';

  @override
  String get auftragEntfernenText => 'Do you want to remove this job from your overview?';

  @override
  String get entfernen => 'Remove';

  @override
  String get keineDatenVerfuegbar => 'No data available';

  @override
  String get beschreibung => 'Description:';

  @override
  String get kategorie => 'Category:';

  @override
  String get adresse => 'Address:';

  @override
  String get status => 'Status:';

  @override
  String jedenWochentag(Object wochentag) {
    return 'Every $wochentag';
  }

  @override
  String bisDatum(Object datum) {
    return 'until $datum';
  }

  @override
  String get malSuffix => 'times';

  @override
  String kontaktZuLabel(Object label) {
    return 'Contact $label:';
  }

  @override
  String get nummerKopiert => 'Number copied!';

  @override
  String get nummerKopieren => 'Copy number';

  @override
  String get anrufen => 'Call';

  @override
  String fehlerPrefix(Object error) {
    return 'Error: $error';
  }

  @override
  String get editProfileTooltip => 'Edit profile';

  @override
  String get appTitle => 'AtYourService';

  @override
  String get hello => 'Welcome!';

  @override
  String get kundeButton => 'I\'m looking for a service provider';

  @override
  String get dienstleisterButton => 'I am a service provider';

  @override
  String get category_babysitter => 'Babysitter / Child care';

  @override
  String get category_catering => 'Catering';

  @override
  String get category_dachdecker => 'Roofer';

  @override
  String get category_elektriker => 'Electrician';

  @override
  String get category_ernaehrungsberatung => 'Nutrition consulting';

  @override
  String get category_eventplanung => 'Event planning';

  @override
  String get category_fahrdienste => 'Transport services';

  @override
  String get category_fahrlehrer => 'Driving instructor';

  @override
  String get category_fensterputzer => 'Window cleaner';

  @override
  String get category_fliesenleger => 'Tiler';

  @override
  String get category_fotografie => 'Photography / Videography';

  @override
  String get category_friseur => 'Hairdresser';

  @override
  String get category_gartenpflege => 'Garden care / Lawn mowing';

  @override
  String get category_grafikdesign => 'Graphic design';

  @override
  String get category_handy_reparatur => 'Smartphone / Tablet repair';

  @override
  String get category_haushaltsreinigung => 'House cleaning';

  @override
  String get category_hausmeisterservice => 'Janitorial service';

  @override
  String get category_heizungsbauer => 'Heating installer';

  @override
  String get category_hundesitter => 'Dog sitting / Walking';

  @override
  String get category_it_support => 'IT support';

  @override
  String get category_klempner => 'Plumber';

  @override
  String get category_kosmetik => 'Beautician';

  @override
  String get category_kuenstler => 'Artist (e.g. musician for events)';

  @override
  String get category_kurierdienst => 'Courier service';

  @override
  String get category_maler => 'Painter';

  @override
  String get category_massagen => 'Massage';

  @override
  String get category_maurer => 'Bricklayer';

  @override
  String get category_moebelaufbau => 'Furniture assembly';

  @override
  String get category_musikunterricht => 'Music lessons';

  @override
  String get category_nachhilfe => 'Tutoring';

  @override
  String get category_nagelstudio => 'Nail studio';

  @override
  String get category_pc_reparatur => 'PC / Laptop repair';

  @override
  String get category_partyservice => 'Party service';

  @override
  String get category_personal_trainer => 'Personal trainer';

  @override
  String get category_rasenmaeher_service => 'Lawnmower service';

  @override
  String get category_rechtsberatung => 'Legal consulting';

  @override
  String get category_reparaturdienste => 'Repair services';

  @override
  String get category_seniorenbetreuung => 'Senior care';

  @override
  String get category_social_media => 'Social media management';

  @override
  String get category_sonstige => 'Other services';

  @override
  String get category_sprachunterricht => 'Language lessons';

  @override
  String get category_steuerberatung => 'Tax consulting';

  @override
  String get category_tischler => 'Carpenter';

  @override
  String get category_transport => 'Transport & Mobility';

  @override
  String get category_umzugstransporte => 'Moving transport';

  @override
  String get category_umzugshelfer => 'Moving helper';

  @override
  String get category_uebersetzungen => 'Translations';

  @override
  String get category_waescheservice => 'Laundry service';

  @override
  String get category_webdesign => 'Web design';

  @override
  String get category_einkaufsservice => 'Shopping service';

  @override
  String get category_haustierbetreuung => 'Pet care';

  @override
  String get premiumBadgeLabel => 'Premium';

  @override
  String get statusOffen => 'Open';

  @override
  String get statusInBearbeitung => 'In progress';

  @override
  String get statusAbgeschlossen => 'Completed';

  @override
String get privacyButton => 'Privacy & Legal Notice';

}
