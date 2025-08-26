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
  String get premiumSilverFeature1 => 'Accept 3 jobs per week';

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
  String get topBewertetBadgeDesc => 'Maintain an average rating of at least 4.5 stars from at least 2 reviews.';

  @override
  String badgeCertifiedProgress(Object count) {
    return 'Certified ($count/1)';
  }

  @override
  String get badgeCertifiedDesc => 'Complete your very first job.';

  @override
  String badgeExperiencedProgress(Object count) {
    return 'Experienced ($count/2)';
  }

  @override
  String get badgeExperiencedDesc => 'Complete a total of 2 jobs.';

  @override
  String badgeExpertProgress(Object count) {
    return 'Expert ($count/3)';
  }

  @override
  String get badgeExpertDesc => 'Complete a total of 3 jobs.';

  @override
  String badgeMasterProgress(Object count) {
    return 'Master ($count/4)';
  }

  @override
  String get badgeMasterDesc => 'Complete a total of 4 jobs.';

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
}
