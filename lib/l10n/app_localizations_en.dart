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
  String get passwordTooShort => 'Password must be at least 8 characters.';

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
  String get descriptionLabel => 'Service description:';

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
  String get premiumSilverFeature1 => 'Accept 2 jobs per week';

  @override
  String get premiumSilverFeature2 => 'Jobs within a 15 km radius';

  @override
  String get premiumSilverFeature3 => 'All categories available';

  @override
  String get premiumGoldFeature1 => 'Accept 5 jobs per week';

  @override
  String get premiumGoldFeature2 => 'Jobs within a 30 km radius';

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
  String get category_rasenmaeher_service => 'Garden Care / Landscaping';

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
  String get privacyButton => 'Privacy';

  @override
  String get interval_weekly => 'Weekly';

  @override
  String get interval_biweekly => 'Every 2 weeks';

  @override
  String get interval_monthly => 'Monthly';

  @override
  String get weekday_monday => 'Monday';

  @override
  String get weekday_tuesday => 'Tuesday';

  @override
  String get weekday_wednesday => 'Wednesday';

  @override
  String get weekday_thursday => 'Thursday';

  @override
  String get weekday_friday => 'Friday';

  @override
  String get weekday_saturday => 'Saturday';

  @override
  String get weekday_sunday => 'Sunday';

  @override
  String get kundenInfoBanner => 'You are logged in as a customer. Please describe the service you need here. Service providers will then send you offers.';

  @override
  String get titelHint => 'e.g. Have my apartment cleaned';

  @override
  String get beschreibungHint => 'Describe what needs to be done – e.g. clean 3 rooms, kitchen, and bathroom ...';

  @override
  String get invoiceSectionTitle => 'Invoice data (Gold only)';

  @override
  String get invoiceNameLabel => 'Invoice name (e.g. company name)';

  @override
  String get invoiceAddressLabel => 'Invoice address:';

  @override
  String get invoiceTaxNumberLabel => 'Tax number (optional)';

  @override
  String get invoiceIbanLabel => 'IBAN (optional)';

  @override
  String get invoiceLogoUrlLabel => 'Logo URL (optional)';

  @override
  String get invoiceGoldInfo => 'Invoice data can be edited in the GOLD plan.';

  @override
  String get rechnungGenerierenButtonLabel => 'Generate Invoice';

  @override
  String get meineAbgeschlossenenAuftraege => 'My Completed Orders';

  @override
  String get verbergenButtonLabel => 'Hide';

  @override
  String get rechnungGenerierenAppBar => 'Generate Invoice';

  @override
  String get rechnungAlsPdfAnzeigenLabel => 'Show invoice as PDF';

  @override
  String get invoiceLabel => 'Invoice';

  @override
  String get fromLabel => 'From:';

  @override
  String get taxNumberLabel => 'Tax number:';

  @override
  String get ibanLabel => 'IBAN:';

  @override
  String get toLabel => 'To:';

  @override
  String get amountLabel => 'Amount:';

  @override
  String get dateLabel => 'Date:';

  @override
  String get generatedByText => 'This invoice was automatically generated via AtYourService.';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get amountRequired => 'Please enter a valid amount.';

  @override
  String get premiumGoldInvoiceFeature => 'Invoice generation as PDF';

  @override
  String get onlyForGoldTooltip => 'This feature is available only for Gold subscribers.';

  @override
  String get deleteJobTooltip => 'Remove job from the list';

  @override
  String get invoiceNumberLabel => 'Invoice Number';

  @override
  String get invoiceProfileHint => 'Please enter your invoice details in your profile. These will automatically be included in the PDF invoice.';

  @override
  String get auftragErneutPosten => 'Repost job';

  @override
  String get auftragErneutPostenTitle => 'Repost this job?';

  @override
  String get auftragErneutPostenText => 'The current provider will be removed. The job will become visible to others again. Do you want to continue?';

  @override
  String get auftragErneutGepostet => 'The job has been reposted.';

  @override
  String get premiumActivated => 'Subscription activated successfully!';

  @override
  String premiumPurchaseFailed(Object error) {
    return 'Purchase failed: $error';
  }

  @override
  String get premiumProductNotFound => 'Product not found!';

  @override
  String get premiumStoreNotLoaded => 'Store products could not be loaded.';

  @override
  String premiumYearlySuffix(Object price) {
    return 'Yearly: $price';
  }

  @override
  String premiumYearlyButton(Object plan) {
    return '$plan (Yearly)';
  }

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountWarning => 'Are you sure you want to permanently delete your account? All your data will be permanently removed.';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get accountDeleted => 'Your account has been deleted.';

  @override
  String get cancel => 'Cancel';

  @override
  String get premiumDeactivated => 'Premium deactivated.';

  @override
  String acceptedByLabel(Object name) {
    return 'Accepted by $name';
  }

  @override
  String get adresseValidator => 'Please enter an address.';

  @override
  String get abgeschlosseneAuftraegeHinweis => 'Here you can delete completed jobs and rate your service provider.';

  @override
  String get goldBadgeLabel => 'Gold Subscription';

  @override
  String get silverBadgeLabel => 'Silver Subscription';

  @override
  String get topBewertetBadgeLabel => 'Top Rated';

  @override
  String get badgeCertified => 'Certified';

  @override
  String get badgeExperienced => 'Experienced';

  @override
  String get badgeExpert => 'Expert';

  @override
  String get badgeMaster => 'Master';

  @override
  String badgeCertifiedCounter(Object count) {
    return '$count jobs completed';
  }

  @override
  String badgeExperiencedCounter(Object count) {
    return '$count jobs completed';
  }

  @override
  String badgeExpertCounter(Object count) {
    return '$count jobs completed';
  }

  @override
  String badgeMasterCounter(Object count) {
    return '$count jobs completed';
  }

  @override
  String get achievementTitle => 'Achievements & Badges';

  @override
  String get goldBadgeDesc => 'You have a Gold subscription and can accept unlimited jobs.';

  @override
  String get silverBadgeDesc => 'You have a Silver subscription and can accept 3 jobs per week.';

  @override
  String get topBewertetBadgeDesc => 'Maintain an average rating of at least 4.5 stars from at least 5 reviews.';

  @override
  String badgeCertifiedProgress(Object count) {
    return 'Certified ($count/1)';
  }

  @override
  String get badgeCertifiedDesc => 'Complete 3 jobs.';

  @override
  String badgeExperiencedProgress(Object count) {
    return 'Experienced ($count/2)';
  }

  @override
  String get badgeExperiencedDesc => 'Complete a total of 10 jobs.';

  @override
  String badgeExpertProgress(Object count) {
    return 'Expert ($count/3)';
  }

  @override
  String get badgeExpertDesc => 'Complete a total of 25 jobs.';

  @override
  String badgeMasterProgress(Object count) {
    return 'Master ($count/4)';
  }

  @override
  String get badgeMasterDesc => 'Complete a total of 50 jobs.';

  @override
  String get trafficScreenInfoText => 'Here you can see how many service providers are currently active in each category in your area. The more providers, the faster your request is usually accepted.';

  @override
  String get filterAbgeschlossen => 'Completed';

  @override
  String get auftraege => 'Jobs';

  @override
  String get profil => 'Profile';

  @override
  String get filterAlle => 'All';

  @override
  String get filterOffen => 'Open';

  @override
  String get filterLaufend => 'Ongoing';

  @override
  String get forgotPasswordButton => 'Forgot password?';

  @override
  String get forgotPasswordInfo => 'Enter your registered email address. You will receive a link to reset your password.';

  @override
  String get sendResetLinkButton => 'Send reset link';

  @override
  String get resetMailSent => 'Link has been sent. Please check your inbox!';

  @override
  String get keineDienstleisterInRegion => 'No service provider found in your area yet.';

  @override
  String get trafficScreenKeineAdresse => 'No address found in your profile.';

  @override
  String get trafficScreenAdresseFehler => 'Your address could not be converted to coordinates.';

  @override
  String get auftragWiederkehrendAppBar => 'Recurring Job';

  @override
  String get auftragWiederkehrendHeadline => 'Should this job be repeated regularly?';

  @override
  String get auftragWiederkehrendInfo => 'Choose whether and how often the job should be performed automatically.';

  @override
  String get auftragReviewAppBar => 'Review & Submit';

  @override
  String get auftragReviewHeadline => 'Everything correct?';

  @override
  String get auftragReviewInfo => 'Please review your entries before submitting the job.';

  @override
  String get absendenButton => 'Submit';

  @override
  String get ja => 'Yes';

  @override
  String get nein => 'No';

  @override
  String get wiederholenBisLabelPlain => 'Repeat until';

  @override
  String get auftragAdresseAppBar => 'Address & Contact';

  @override
  String get auftragAdresseHeadline => 'Where should the job be performed?';

  @override
  String get auftragAdresseInfo => 'Please enter the address and your phone number so the provider can contact you.';

  @override
  String get adresseHint => 'e.g. Main Street 12, 12345 Berlin';

  @override
  String get telefonnummerHint => 'e.g. 0176 12345678';

  @override
  String get zurueckButton => 'Back';

  @override
  String get weiterButton => 'Next';

  @override
  String get auftragKategorieAppBar => 'Select category';

  @override
  String get auftragKategorieHeadline => 'For which category do you need help?';

  @override
  String get auftragKategorieInfo => 'Choose the right service. You can specify more details later.';

  @override
  String get kategorieValidator => 'Please select a category.';

  @override
  String get auftragDetailsAppBar => 'Job details';

  @override
  String get auftragDetailsHeadline => 'Describe your job';

  @override
  String get auftragDetailsInfo => 'What needs to be done? The more details, the better!';

  @override
  String get auftragTerminAppBar => 'Date & Time';

  @override
  String get auftragTerminHeadline => 'When should the job be done?';

  @override
  String get auftragTerminInfo => 'Set the date and time or choose \'as soon as possible\'.';

  @override
  String get terminLabel => 'Date';

  @override
  String get preisLabel => 'Price (€) or \'negotiable\'';

  @override
  String get preisHint => 'e.g. 60 or \'negotiable\'';

  @override
  String get preisValidator => 'Please enter a valid price or \'negotiable\'.';

  @override
  String get preisHinweisLabel => 'Price note (optional)';

  @override
  String get preisHinweisHint => 'e.g. hourly rate, material costs, negotiable, etc.';

  @override
  String get preisTypLabel => 'Select price option';

  @override
  String get preisTypGesamt => 'Total price';

  @override
  String get preisTypStunden => 'Hourly rate';

  @override
  String get preisTypVerhandelbar => 'Negotiable / on request';

  @override
  String get preisLabelGesamt => 'Total price (€)';

  @override
  String get preisHintGesamt => 'e.g. 120';

  @override
  String get preisLabelStunden => 'Hourly rate (€ per hour)';

  @override
  String get preisHintStunden => 'e.g. 20';

  @override
  String get preisHinweisVerhandelbar => 'Price negotiable / offers welcome';

  @override
  String get preisTypGesamtDesc => 'You specify the total price for the job.';

  @override
  String get preisTypStundenDesc => 'You specify an hourly rate for the job.';

  @override
  String get preisTypVerhandelbarDesc => 'The price will be negotiated directly with the service provider.';

  @override
  String get heimatadresseButtonInfo => 'Tap here to auto-fill your saved home address. (Configurable in your profile)';

  @override
  String get verhandelbarLabel => 'Negotiable';

  @override
  String get terminValidierungFehler => 'Please select a date and both time slots.';

  @override
  String get wiederkehrendValidierungFehler => 'Please select interval, weekday, and number of repetitions for recurring tasks correctly.';

  @override
  String priceTotal(Object amount) {
    return '$amount €';
  }

  @override
  String pricePerHour(Object amount, Object hourShort) {
    return '$amount € / $hourShort';
  }

  @override
  String get priceNegotiable => 'Negotiable';

  @override
  String get hourShort => 'hr';

  @override
  String get setNewPasswordTitle => 'Set new password';

  @override
  String get setNewPasswordInfo => 'Enter your new password twice to confirm.';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmNewPasswordLabel => 'Confirm new password';

  @override
  String get saveNewPasswordButton => 'Save new password';

  @override
  String get passwordEmptyError => 'Password cannot be empty.';

  @override
  String get passwordsDontMatch => 'Passwords do not match.';

  @override
  String get passwordResetSuccess => 'Password reset successful. You can now log in.';

  @override
  String get premiumRestorePurchases => 'Restore purchases';

  @override
  String get premiumRetry => 'Try again';

  @override
  String get wrongRoleCustomer => 'This account is registered as a service provider and cannot be used to log in as a customer.';

  @override
  String get accountNotRegistered => 'No account found with this email. Please register first.';

  @override
  String get wrongCredentials => 'Incorrect email or password.';

  @override
  String get premiumPushDelayFree => 'Push notifications: 1h delay';

  @override
  String get premiumPushDelaySilver => 'Push notifications: 30 min delay';

  @override
  String get premiumPushDelayGold => 'Push notifications: instant on new jobs';

  @override
  String get companyNameOptional => 'Company name (optional)';

  @override
  String get vatIdOptional => 'VAT ID (optional)';

  @override
  String get bicOptional => 'BIC (optional)';

  @override
  String get smallBusinessLabel => 'Small business according to §19 UStG';

  @override
  String get defaultVatRateLabel => 'Standard VAT rate (%)';

  @override
  String get invalidVatRate => 'Invalid VAT rate';

  @override
  String get profileNameLabel => 'Full name';

  @override
  String get invoiceNoShort => 'No:';

  @override
  String get netAmountLabel => 'Net';

  @override
  String vatLabelWithPercent(Object percent) {
    return 'VAT ($percent%)';
  }

  @override
  String get totalLabel => 'Total';

  @override
  String get dueOnLabel => 'Due on:';

  @override
  String get vatIdLabel => 'VAT ID:';

  @override
  String get bicLabel => 'BIC:';

  @override
  String paymentTermsDefault(Object days) {
    return 'Payable within $days days without deduction.';
  }

  @override
  String get badgeInfoText => 'These badges can only be earned by service providers and appear when the provider accepts the job.';

  @override
  String get noAuftraegeKundeHint => 'Create your first job by tapping the plus (+) button.';

  @override
  String get upsellCardTitle => 'Job near you';

  @override
  String upsellCategoryLabel(String category) {
    return 'Category: $category';
  }

  @override
  String upsellUpgradeButton(String plan) {
    return 'Upgrade to $plan to view this job';
  }

  @override
  String get planFree => 'Free';

  @override
  String get planSilver => 'Silver';

  @override
  String get planGold => 'Gold';

  @override
  String get filterNeu => 'New';

  @override
  String onlyNewWindowInfo(int hours) {
    return 'Showing jobs from the last $hours hours.';
  }

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get editProfileCta => 'Complete profile';

  @override
  String get update_required_title => 'Update required';

  @override
  String get update_required_message => 'Please update the app to continue.';

  @override
  String get update_available_title => 'Update available';

  @override
  String get update_available_message => 'A new version is available. Update now?';

  @override
  String get update_action_update_now => 'Update now';

  @override
  String get update_action_later => 'Later';

  @override
  String get invoiceSectionSubtitle => 'Optional: company & tax details for automatic invoicing';

  @override
  String get marketplaceTitle => 'Trade jobs';

  @override
  String get marketplaceTabSell => 'Sell';

  @override
  String get marketplaceTabBuy => 'Buy';

  @override
  String get marketplaceOfferCreateCta => 'Pass on a job';

  @override
  String get marketplaceFilter => 'Filter';

  @override
  String get marketplaceSort => 'Sort';

  @override
  String get marketplaceBuyNow => 'Apply now';

  @override
  String get marketplaceSnackOpenForm => 'Opening offer form…';

  @override
  String get marketplaceSnackStartCheckout => 'Starting checkout…';

  @override
  String marketplaceOfferTitle(int index) {
    return 'Offer #$index';
  }

  @override
  String marketplaceOfferSubtitle(String category, String price, Object distanceKm) {
    return '$category • $distanceKm km';
  }

  @override
  String marketplaceBuyTitle(int index) {
    return 'Listing #$index · Minor repair';
  }

  @override
  String marketplaceBuySubtitle(String category, String price, String distance) {
    return 'Category: $category · $price/h · $distance km';
  }

  @override
  String get marketplaceEmptyList => 'No matching offers found.';

  @override
  String get marketplaceErrorLoading => 'Could not load the list.';

  @override
  String get marketplaceAppliedSuccess => 'Applied — the seller can see your request.';

  @override
  String get marketplaceAlreadyApplied => 'You have already applied.';

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
    return 'Target price: $price';
  }

  @override
  String marketplaceChipProvision(Object value) {
    return 'Commission: $value';
  }

  @override
  String get s0Title => 'Pass on job (S0)';

  @override
  String get sectionBasics => 'Basics';

  @override
  String get fieldTitle => 'Title';

  @override
  String get hintTitleExample => 'e.g., Roof renovation SFH, 120 m²';

  @override
  String get fieldDescription => 'Description';

  @override
  String get hintDescription => 'Short description, specifics, materials incl./excl.';

  @override
  String get fieldLocation => 'Location/Radius (text for now)';

  @override
  String get hintLocation => 'e.g., Cologne, 15 km';

  @override
  String get pickStartDate => 'Select start date';

  @override
  String get pickDeadline => 'Select deadline';

  @override
  String get labelStart => 'Start';

  @override
  String get labelDeadline => 'Deadline';

  @override
  String get sectionS0PriceProvision => 'S0 – Price & Commission';

  @override
  String get tooltipS0PriceProvision => 'Target price = Total price of the job.\nCommission = Fee for passing on the job.';

  @override
  String get fieldTargetPriceEur => 'Target price (EUR)';

  @override
  String get hintTargetPriceExample => 'e.g., 12,500';

  @override
  String get helpTargetPrice => 'Total contract value that the buyer takes over.';

  @override
  String get fieldProvisionType => 'Commission type';

  @override
  String get provisionTypePercent => 'Percent';

  @override
  String get provisionTypeFixed => 'Fixed';

  @override
  String get fieldProvisionValuePercent => 'Commission value (%)';

  @override
  String get fieldProvisionValueFixed => 'Commission value (€)';

  @override
  String get helpProvisionPercent => 'Typical: 5–12% (cap possible).';

  @override
  String get helpProvisionFixed => 'Fixed commission amount.';

  @override
  String get fieldProvisionDue => 'When is the commission due?';

  @override
  String get provisionDueAward => 'Upon award';

  @override
  String get provisionDueHandover => 'Upon handover';

  @override
  String get provisionDueFinalInvoice => 'Upon final invoice';

  @override
  String get provisionDueAwardHelp => 'Upon award: commission is due immediately after the award.';

  @override
  String get provisionDueHandoverHelp => 'Upon handover: due after customer OK & handover.';

  @override
  String get provisionDueFinalInvoiceHelp => 'Upon final invoice: when the buyer’s provider completes the job.';

  @override
  String get sectionEvidencePlaceholder => 'Evidence (placeholder)';

  @override
  String get btnUploadEvidence => 'Upload offer/customer approval';

  @override
  String get btnCreateDraft => 'Create as draft';

  @override
  String get btnSaving => 'Saving…';

  @override
  String get noteSupabaseActive => 'Note: Supabase storage active. Payment & uploads coming later.';

  @override
  String get formErrorRequired => 'Required field';

  @override
  String get formErrorInvalidAmount => 'Invalid amount';

  @override
  String get formErrorGreaterZero => 'Must be > 0';

  @override
  String get formErrorRealistic => 'Please keep it realistic';

  @override
  String get formErrorInvalidValue => 'Invalid value';

  @override
  String get formErrorPercentRange => 'Allowed range: 0–30%';

  @override
  String get errPickStartDate => 'Please choose a start date';

  @override
  String get errPickDeadline => 'Please choose an end date/deadline';

  @override
  String get draftSaved => 'S0 draft saved.';

  @override
  String get genericError => 'Something went wrong.';

  @override
  String get btnMyDeals => 'My deals';

  @override
  String get myDealsTitle => 'My deals';

  @override
  String get myDealsEmpty => 'No jobs yet.';

  @override
  String get myDealsErrorLoading => 'Your jobs could not be loaded.';

  @override
  String get filterAll => 'All';

  @override
  String get filterDraft => 'Drafts';

  @override
  String get filterLive => 'Live';

  @override
  String get filterAwarded => 'Awarded';

  @override
  String get manageTitle => 'Manage job';

  @override
  String get manageErrorLoading => 'Details could not be loaded.';

  @override
  String get btnPublish => 'Publish';

  @override
  String get publishSuccess => 'Job published.';

  @override
  String get applicationsTitle => 'Applications';

  @override
  String get applicationsEmpty => 'No applications yet.';

  @override
  String get applicationNote => 'Note';

  @override
  String get applicationStatusPending => 'Status: pending';

  @override
  String get applicationStatusAwarded => 'Status: awarded';

  @override
  String get btnAward => 'Award';

  @override
  String get btnManage => 'Manage';

  @override
  String get labelStatus => 'Status';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusLive => 'Live';

  @override
  String get statusAwarded => 'Awarded';

  @override
  String get awardSuccess => 'Application awarded successfully.';

  @override
  String get snackNewApplication => 'New application received';

  @override
  String applicationsCount(Object count) {
    return '$count applications';
  }

  @override
  String get btnApplied => 'Applied';

  @override
  String get s0EditTitle => 'Edit handover (S0)';

  @override
  String get publishNow => 'Publish after saving';

  @override
  String get publishNowHint => 'If enabled, the draft will be set to Live after saving.';

  @override
  String get btnSaveChanges => 'Save changes';

  @override
  String get saved => 'Saved';

  @override
  String get marketplaceLocationLoadedFromProfile => 'Location loaded from your profile — radius filter active.';

  @override
  String get marketplaceNoHomeAddressHint => 'No address in profile — showing all offers without distance filter.';

  @override
  String get fieldCategory => 'Category';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryRoofer => 'Roofer';

  @override
  String get categorySolar => 'PV / Solar';

  @override
  String get categoryHVAC => 'Heating / Plumbing / HVAC';

  @override
  String get categoryElectrical => 'Electrical';

  @override
  String get categoryDrywall => 'Drywall';

  @override
  String get categoryPainter => 'Painter';

  @override
  String get categoryTiling => 'Tiling';

  @override
  String get categoryFlooring => 'Flooring';

  @override
  String get categoryWindowsDoors => 'Windows & Doors';

  @override
  String get categoryInsulationFacade => 'Insulation & Façade';

  @override
  String get categoryMasonryConcrete => 'Masonry & Concrete';

  @override
  String get categoryCarpentryJoinery => 'Carpentry & Joinery';

  @override
  String get categoryLandscaping => 'Landscaping';

  @override
  String get categoryScaffolding => 'Scaffolding';

  @override
  String get categoryCleaningRestoration => 'Cleaning & Restoration';

  @override
  String get categoryMovingTransport => 'Moving & Transport';

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
  String get genericPleaseFix => 'Please fix the highlighted fields:';

  @override
  String get errAwardNeedsDoc => 'If due \"on award\", at least one document/offer is required.';

  @override
  String get errNotOwner => 'You are not the owner of this job.';

  @override
  String get errPublishOnlyFromDraft => 'Publishing is only possible from draft status.';

  @override
  String get publishRequirementsTitle => 'Requirements to publish';

  @override
  String get infoReqCustomerOk => 'At least one customer OK is attached.';

  @override
  String get infoReqDocForAward => 'For \"on award\": upload offer/order confirmation.';

  @override
  String get infoReqAttest => 'Confirmation in the form is checked.';

  @override
  String get draftChecklistTitle => 'Pre-publish checklist';

  @override
  String get chkTitle => 'Title filled in';

  @override
  String get chkDescription => 'Description filled in';

  @override
  String get chkLocation => 'Address/location set';

  @override
  String get chkTargetPrice => 'Target price set';

  @override
  String get chkCustomerOk => 'Customer OK present';

  @override
  String get chkDocIfAward => 'Document/offer present (recommended if due \"on award\")';

  @override
  String get chkAttestAtPublish => 'Tick the confirmation at publish';

  @override
  String get draftChecklistCta => 'Open management';

  @override
  String get uploadSuccess => 'Upload successful.';

  @override
  String get uploadInProgress => 'Uploading...';

  @override
  String get uploadFailed => 'Upload failed.';

  @override
  String get draftDefaultTitle => 'Draft';

  @override
  String get errGeocodingFailed => 'Address could not be geocoded.';

  @override
  String get provisionDueAwardLabel => 'Award';

  @override
  String get provisionDueHandoverLabel => 'Handover';

  @override
  String get provisionDueFinalInvoiceLabel => 'Final invoice';

  @override
  String get sectionPreviewPublic => 'Preview (public)';

  @override
  String get tooltipPreviewPublic => 'These files are visible to buyers before purchase. Upload only redacted/anonimized previews.';

  @override
  String get btnUploadPreview => 'Upload preview';

  @override
  String get previewRedactionNoticeTitle => 'Important preview notice';

  @override
  String get previewRedactionNoticeBody => 'Previews are visible to buyers before purchase. Redact sensitive data (e.g., names, addresses, phone numbers, contract/customer IDs, signatures, QR/barcodes). Do not upload documents containing unredacted personal data.';

  @override
  String get hintPhoneExample => '+44 7700 900123';

  @override
  String get createDealTitle => 'Create Deal';

  @override
  String get chooseDealTypeTitle => 'Choose deal type';

  @override
  String get dealTypeS0Title => 'S0 – Resell full job';

  @override
  String get dealTypeS0Subtitle => 'Sell the entire job to another provider.';

  @override
  String get dealTypeS1Title => 'S1 – Sub-scope/Subcontract (Milestones)';

  @override
  String get dealTypeS1Subtitle => 'Subcontract with milestones & evidence.';

  @override
  String get s1Title => 'Find subcontractors (S1)';

  @override
  String get sectionS1Pricing => 'Pricing';

  @override
  String get sectionS1Provision => 'Commission';

  @override
  String get sectionMilestones => 'Milestones';

  @override
  String get pricingModeFixed => 'Fixed price';

  @override
  String get pricingModeTm => 'Time & Material';

  @override
  String get basePriceLabel => 'Total budget (€)';

  @override
  String get hourlyRateLabel => 'Hourly rate (€)';

  @override
  String get expectedHoursLabel => 'Estimated hours';

  @override
  String get dueTypeAward => 'Award';

  @override
  String get dueTypeDate => 'Date';

  @override
  String get dueTypeHandover => 'Handover';

  @override
  String get dueTypeCustom => 'Custom';

  @override
  String get dueTypeCustomHelp => 'Custom due trigger (please provide a date/comment).';

  @override
  String get milestoneLabel => 'Milestone';

  @override
  String get milestoneTitle => 'Milestone title';

  @override
  String get milestoneDescription => 'Milestone description';

  @override
  String get milestoneAmount => 'Amount (€)';

  @override
  String get milestonePercent => 'Percent (%)';

  @override
  String get milestoneDue => 'Due';

  @override
  String get btnAddMilestonePercent => 'Add milestone (%)';

  @override
  String get btnAddMilestoneAmount => 'Add milestone (€)';

  @override
  String get milestoneEmptyHint => 'No milestones yet (optional).';

  @override
  String get milestoneBlocking => 'Blocking';

  @override
  String get milestoneBlockingHelp => 'Must be completed before the next step is unlocked.';

  @override
  String get validationMilestoneSum => 'Milestone totals don’t add up: use 100% for percent mode or match the total budget for fixed price.';

  @override
  String get btnReorder => 'Reorder';

  @override
  String get infoS1PricingHelp => 'How you price the subcontracted work. “Fixed price” = one total budget for the scope. “Time & materials” = hourly rate + estimated hours; billing is based on actual time spent.';

  @override
  String get infoS1ProvisionHelp => 'Your finder/management fee per awarded subcontractor. Set a percentage or fixed amount and when it becomes due.';

  @override
  String get coordChipNoCoords => 'No coordinates';

  @override
  String get coordMissingLabel => 'Coordinates (lat/lng)';

  @override
  String get s0DetailsMissingLabel => 'S0 details';

  @override
  String get s1DetailsMissingLabel => 'S1 details';

  @override
  String get marketplaceTypeS0 => 'S0 – Hand-off';

  @override
  String get marketplaceTypeS1 => 'S1 – Subcontractor search';

  @override
  String get filterTypeAll => 'All types';

  @override
  String get filterTypeS0 => 'S0 only';

  @override
  String get filterTypeS1 => 'S1 only';

  @override
  String get badgeAwardedToYou => 'Awarded to you';

  @override
  String get badgeAwardedGiven => 'Awarded';

  @override
  String get btnAssigned => 'Awarded';

  @override
  String get marketplaceOwnDealPill => 'Your deal';
}
