import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('nl'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('tr')
  ];

  /// No description provided for @registerAppBar.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registerAppBar;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get registerTitle;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Select a role'**
  String get roleLabel;

  /// No description provided for @roleKunde.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get roleKunde;

  /// No description provided for @roleDienstleister.
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get roleDienstleister;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @categoryValidator.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get categoryValidator;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get emailEmpty;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get passwordEmpty;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please confirm your email.'**
  String get registerSuccess;

  /// No description provided for @registerExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please log in or reset your password.'**
  String get registerExists;

  /// No description provided for @registerInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get registerInvalidEmail;

  /// No description provided for @registerPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get registerPasswordShort;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed: {error}'**
  String registerFailed(Object error);

  /// No description provided for @registerUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error: {error}'**
  String registerUnknownError(Object error);

  /// No description provided for @profileAppBar.
  ///
  /// In en, this message translates to:
  /// **'Service Provider Profile'**
  String get profileAppBar;

  /// No description provided for @profileAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Home Address (e.g. Example Street 12, 12345 Example City)'**
  String get profileAddressLabel;

  /// No description provided for @profileAddressEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get profileAddressEmpty;

  /// No description provided for @profileSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get profileSaveButton;

  /// No description provided for @profileAddressSaved.
  ///
  /// In en, this message translates to:
  /// **'Address saved!'**
  String get profileAddressSaved;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading: {error}'**
  String profileLoadError(Object error);

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String profileSaveError(Object error);

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please log in first'**
  String get pleaseLogin;

  /// No description provided for @changeNotAllowedTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Not Allowed'**
  String get changeNotAllowedTitle;

  /// No description provided for @changeNotAllowedContent.
  ///
  /// In en, this message translates to:
  /// **'As a free user, you can only change your category or address every 20 days.\nNext change allowed from: {date}'**
  String changeNotAllowedContent(Object date);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully!'**
  String get profileSaved;

  /// No description provided for @changeProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Change profile picture'**
  String get changeProfileImage;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @noRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatingsYet;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get nameValidator;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Service description:'**
  String get descriptionLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address (e.g. street, zip code, city)'**
  String get addressLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @phoneValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get phoneValidator;

  /// No description provided for @emailEmptyValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailEmptyValidator;

  /// No description provided for @emailInvalidValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalidValidator;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(Object error);

  /// No description provided for @changeLimitHint.
  ///
  /// In en, this message translates to:
  /// **'Category/address can only be changed from {date}.'**
  String changeLimitHint(Object date);

  /// No description provided for @addressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found. Please check.'**
  String get addressNotFound;

  /// No description provided for @ratingsCount.
  ///
  /// In en, this message translates to:
  /// **'({count} ratings)'**
  String ratingsCount(Object count);

  /// No description provided for @premiumAppBar.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get premiumAppBar;

  /// No description provided for @premiumChoosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose your Premium Plan'**
  String get premiumChoosePlan;

  /// No description provided for @premiumCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Subscription:'**
  String get premiumCurrentPlan;

  /// No description provided for @premiumFreePrice.
  ///
  /// In en, this message translates to:
  /// **'free'**
  String get premiumFreePrice;

  /// No description provided for @premiumSilverPrice.
  ///
  /// In en, this message translates to:
  /// **'€4.99 / month'**
  String get premiumSilverPrice;

  /// No description provided for @premiumGoldPrice.
  ///
  /// In en, this message translates to:
  /// **'€9.99 / month'**
  String get premiumGoldPrice;

  /// No description provided for @premiumFreeFeature1.
  ///
  /// In en, this message translates to:
  /// **'Accept 1 job per week'**
  String get premiumFreeFeature1;

  /// No description provided for @premiumFreeFeature2.
  ///
  /// In en, this message translates to:
  /// **'Jobs within a 5 km radius'**
  String get premiumFreeFeature2;

  /// No description provided for @premiumFreeFeature3.
  ///
  /// In en, this message translates to:
  /// **'Basic categories only'**
  String get premiumFreeFeature3;

  /// No description provided for @premiumFreeFeature4.
  ///
  /// In en, this message translates to:
  /// **'Category change only every 20 days'**
  String get premiumFreeFeature4;

  /// No description provided for @premiumSilverFeature1.
  ///
  /// In en, this message translates to:
  /// **'Accept 2 jobs per week'**
  String get premiumSilverFeature1;

  /// No description provided for @premiumSilverFeature2.
  ///
  /// In en, this message translates to:
  /// **'Jobs within a 15 km radius'**
  String get premiumSilverFeature2;

  /// No description provided for @premiumSilverFeature3.
  ///
  /// In en, this message translates to:
  /// **'All categories available'**
  String get premiumSilverFeature3;

  /// No description provided for @premiumGoldFeature1.
  ///
  /// In en, this message translates to:
  /// **'Accept 5 jobs per week'**
  String get premiumGoldFeature1;

  /// No description provided for @premiumGoldFeature2.
  ///
  /// In en, this message translates to:
  /// **'Jobs within a 30 km radius'**
  String get premiumGoldFeature2;

  /// No description provided for @premiumGoldFeature3.
  ///
  /// In en, this message translates to:
  /// **'All categories available'**
  String get premiumGoldFeature3;

  /// No description provided for @premiumGoldFeature4.
  ///
  /// In en, this message translates to:
  /// **'Premium user badge (visible to clients)'**
  String get premiumGoldFeature4;

  /// No description provided for @premiumChooseButton.
  ///
  /// In en, this message translates to:
  /// **'Choose {title}'**
  String premiumChooseButton(Object title);

  /// No description provided for @premiumPaymentNote.
  ///
  /// In en, this message translates to:
  /// **'Note: All payments are securely processed via Apple or Google. You can cancel or manage your subscription anytime in the store.'**
  String get premiumPaymentNote;

  /// No description provided for @premiumSilverComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Silver coming soon!'**
  String get premiumSilverComingSoon;

  /// No description provided for @premiumGoldComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Gold coming soon!'**
  String get premiumGoldComingSoon;

  /// No description provided for @auftragHidden.
  ///
  /// In en, this message translates to:
  /// **'Job hidden.'**
  String get auftragHidden;

  /// No description provided for @auftragHideError.
  ///
  /// In en, this message translates to:
  /// **'Error hiding job: {error}'**
  String auftragHideError(Object error);

  /// No description provided for @meineAuftraegeAppBar.
  ///
  /// In en, this message translates to:
  /// **'My Jobs'**
  String get meineAuftraegeAppBar;

  /// No description provided for @refreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshTooltip;

  /// No description provided for @noAuftraegeFound.
  ///
  /// In en, this message translates to:
  /// **'No jobs found.'**
  String get noAuftraegeFound;

  /// No description provided for @geplanterAuftrag.
  ///
  /// In en, this message translates to:
  /// **'Scheduled job'**
  String get geplanterAuftrag;

  /// No description provided for @auftragAusblenden.
  ///
  /// In en, this message translates to:
  /// **'Hide job'**
  String get auftragAusblenden;

  /// No description provided for @loginFailedDetails.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials or confirm your email.'**
  String get loginFailedDetails;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @loginFailedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {error}'**
  String loginFailedPrefix(Object error);

  /// No description provided for @loginUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error: {error}'**
  String loginUnknownError(Object error);

  /// No description provided for @emailValidatorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get emailValidatorEmpty;

  /// No description provided for @emailValidatorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailValidatorInvalid;

  /// No description provided for @passwordValidatorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get passwordValidatorEmpty;

  /// No description provided for @passwordValidatorShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordValidatorShort;

  /// No description provided for @loginKundeAppBar.
  ///
  /// In en, this message translates to:
  /// **'Customer Login'**
  String get loginKundeAppBar;

  /// No description provided for @loginKundeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginKundeHeadline;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Register now'**
  String get noAccountYet;

  /// No description provided for @loginFailedDetailsDL.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials or confirm your email.'**
  String get loginFailedDetailsDL;

  /// No description provided for @wrongRoleDL.
  ///
  /// In en, this message translates to:
  /// **'This account is not a service provider. Please use the customer login.'**
  String get wrongRoleDL;

  /// No description provided for @loginDLAppBar.
  ///
  /// In en, this message translates to:
  /// **'Service Provider Login'**
  String get loginDLAppBar;

  /// No description provided for @loginDLHeadline.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginDLHeadline;

  /// No description provided for @kundenDashboardHeader.
  ///
  /// In en, this message translates to:
  /// **'Your Dashboard'**
  String get kundenDashboardHeader;

  /// No description provided for @kundenDashboardAppBar.
  ///
  /// In en, this message translates to:
  /// **'Customer Dashboard'**
  String get kundenDashboardAppBar;

  /// No description provided for @laufendeAuftraege.
  ///
  /// In en, this message translates to:
  /// **'Ongoing jobs'**
  String get laufendeAuftraege;

  /// No description provided for @statusPrefix.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusPrefix(Object status);

  /// No description provided for @dienstleisterPrefix.
  ///
  /// In en, this message translates to:
  /// **'Service provider: {dienstleister}'**
  String dienstleisterPrefix(Object dienstleister);

  /// No description provided for @offeneAuftraege.
  ///
  /// In en, this message translates to:
  /// **'Open jobs'**
  String get offeneAuftraege;

  /// No description provided for @noOffeneAuftraege.
  ///
  /// In en, this message translates to:
  /// **'No open jobs found.'**
  String get noOffeneAuftraege;

  /// No description provided for @abgeschlosseneAuftraege.
  ///
  /// In en, this message translates to:
  /// **'Completed jobs'**
  String get abgeschlosseneAuftraege;

  /// No description provided for @abgeschlossenStatus.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get abgeschlossenStatus;

  /// No description provided for @neuerAuftrag.
  ///
  /// In en, this message translates to:
  /// **'New job'**
  String get neuerAuftrag;

  /// No description provided for @pleaseCreateProfile.
  ///
  /// In en, this message translates to:
  /// **'Please create your profile first.'**
  String get pleaseCreateProfile;

  /// No description provided for @profilMissingCategory.
  ///
  /// In en, this message translates to:
  /// **'Category missing in profile.'**
  String get profilMissingCategory;

  /// No description provided for @dienstleisterDashboardHeader.
  ///
  /// In en, this message translates to:
  /// **'Your Dashboard'**
  String get dienstleisterDashboardHeader;

  /// No description provided for @dienstleisterDashboardAppBar.
  ///
  /// In en, this message translates to:
  /// **'Service Provider Dashboard'**
  String get dienstleisterDashboardAppBar;

  /// No description provided for @meineLaufendenAuftraege.
  ///
  /// In en, this message translates to:
  /// **'My ongoing jobs'**
  String get meineLaufendenAuftraege;

  /// No description provided for @kundePrefix.
  ///
  /// In en, this message translates to:
  /// **'Customer: {kunde}'**
  String kundePrefix(Object kunde);

  /// No description provided for @offenePassendeAuftraege.
  ///
  /// In en, this message translates to:
  /// **'Open matching jobs'**
  String get offenePassendeAuftraege;

  /// No description provided for @noPassendeAuftraege.
  ///
  /// In en, this message translates to:
  /// **'No matching jobs found.'**
  String get noPassendeAuftraege;

  /// No description provided for @entfernungSuffix.
  ///
  /// In en, this message translates to:
  /// **'{dist} km away'**
  String entfernungSuffix(Object dist);

  /// No description provided for @auftragBereitsBewertet.
  ///
  /// In en, this message translates to:
  /// **'You have already rated this job.'**
  String get auftragBereitsBewertet;

  /// No description provided for @bewertungDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate service provider'**
  String get bewertungDialogTitle;

  /// No description provided for @bewertungKommentarLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get bewertungKommentarLabel;

  /// No description provided for @abbrechen.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get abbrechen;

  /// No description provided for @abschicken.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get abschicken;

  /// No description provided for @auftragErstellenTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new job'**
  String get auftragErstellenTitle;

  /// No description provided for @auftragEinstellenUeberschrift.
  ///
  /// In en, this message translates to:
  /// **'Post a job now'**
  String get auftragEinstellenUeberschrift;

  /// No description provided for @titelLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titelLabel;

  /// No description provided for @titelValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get titelValidator;

  /// No description provided for @beschreibungLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get beschreibungLabel;

  /// No description provided for @kategorieLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get kategorieLabel;

  /// No description provided for @heimatadresseEinfuegen.
  ///
  /// In en, this message translates to:
  /// **'Insert home address'**
  String get heimatadresseEinfuegen;

  /// No description provided for @adresseLabel.
  ///
  /// In en, this message translates to:
  /// **'Address (e.g. Alter Markt 76, 50667 Cologne)'**
  String get adresseLabel;

  /// No description provided for @telefonnummerLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get telefonnummerLabel;

  /// No description provided for @telefonnummerValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get telefonnummerValidator;

  /// No description provided for @ausfuehrungszeitpunkt.
  ///
  /// In en, this message translates to:
  /// **'Execution time'**
  String get ausfuehrungszeitpunkt;

  /// No description provided for @soSchnellWieMoeglich.
  ///
  /// In en, this message translates to:
  /// **'As soon as possible'**
  String get soSchnellWieMoeglich;

  /// No description provided for @geplant.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get geplant;

  /// No description provided for @datumWaehlen.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get datumWaehlen;

  /// No description provided for @zeitVon.
  ///
  /// In en, this message translates to:
  /// **'Time from'**
  String get zeitVon;

  /// No description provided for @zeitBis.
  ///
  /// In en, this message translates to:
  /// **'Time to'**
  String get zeitBis;

  /// No description provided for @wiederkehrendCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Recurring job?'**
  String get wiederkehrendCheckbox;

  /// No description provided for @intervallLabel.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get intervallLabel;

  /// No description provided for @intervallValidator.
  ///
  /// In en, this message translates to:
  /// **'Please select an interval'**
  String get intervallValidator;

  /// No description provided for @wochentagLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get wochentagLabel;

  /// No description provided for @wochentagValidator.
  ///
  /// In en, this message translates to:
  /// **'Please select a weekday'**
  String get wochentagValidator;

  /// No description provided for @anzahlWiederholungenLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of repetitions (optional)'**
  String get anzahlWiederholungenLabel;

  /// No description provided for @wiederholenBisNichtGesetzt.
  ///
  /// In en, this message translates to:
  /// **'Repeat until: not set'**
  String get wiederholenBisNichtGesetzt;

  /// No description provided for @wiederholenBisLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat until: {date}'**
  String wiederholenBisLabel(Object date);

  /// No description provided for @auftragAbschicken.
  ///
  /// In en, this message translates to:
  /// **'Submit job'**
  String get auftragAbschicken;

  /// No description provided for @auftragGespeichert.
  ///
  /// In en, this message translates to:
  /// **'Job saved!'**
  String get auftragGespeichert;

  /// No description provided for @bitteEinloggen.
  ///
  /// In en, this message translates to:
  /// **'Please log in first'**
  String get bitteEinloggen;

  /// No description provided for @adresseNichtGefunden.
  ///
  /// In en, this message translates to:
  /// **'Address not found.'**
  String get adresseNichtGefunden;

  /// No description provided for @unbekannterFehler.
  ///
  /// In en, this message translates to:
  /// **'Unknown error: {error}'**
  String unbekannterFehler(Object error);

  /// No description provided for @auftragDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Job details'**
  String get auftragDetailTitle;

  /// No description provided for @nichtEingeloggt.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get nichtEingeloggt;

  /// No description provided for @rolleNichtErmittelt.
  ///
  /// In en, this message translates to:
  /// **'Role could not be determined'**
  String get rolleNichtErmittelt;

  /// No description provided for @auftragNichtGefunden.
  ///
  /// In en, this message translates to:
  /// **'Job not found'**
  String get auftragNichtGefunden;

  /// No description provided for @bewertungDanke.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your rating!'**
  String get bewertungDanke;

  /// No description provided for @limitErreicht.
  ///
  /// In en, this message translates to:
  /// **'Limit reached'**
  String get limitErreicht;

  /// No description provided for @limitFree.
  ///
  /// In en, this message translates to:
  /// **'As a freemium service provider, you can accept up to 2 jobs per week. Upgrade to Silver or Gold for more options!'**
  String get limitFree;

  /// No description provided for @limitSilver.
  ///
  /// In en, this message translates to:
  /// **'As a Silver service provider, you can accept up to 5 jobs per week. Upgrade to Gold for unlimited jobs!'**
  String get limitSilver;

  /// No description provided for @auftragAnnehmen.
  ///
  /// In en, this message translates to:
  /// **'Accept job'**
  String get auftragAnnehmen;

  /// No description provided for @auftragBeenden.
  ///
  /// In en, this message translates to:
  /// **'Complete job'**
  String get auftragBeenden;

  /// No description provided for @auftragEntfernenUebersicht.
  ///
  /// In en, this message translates to:
  /// **'Remove job from overview'**
  String get auftragEntfernenUebersicht;

  /// No description provided for @auftragEntfernen.
  ///
  /// In en, this message translates to:
  /// **'Remove job'**
  String get auftragEntfernen;

  /// No description provided for @auftragEntfernenTitel.
  ///
  /// In en, this message translates to:
  /// **'Remove job?'**
  String get auftragEntfernenTitel;

  /// No description provided for @auftragEntfernenText.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this job from your overview?'**
  String get auftragEntfernenText;

  /// No description provided for @entfernen.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get entfernen;

  /// No description provided for @keineDatenVerfuegbar.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get keineDatenVerfuegbar;

  /// No description provided for @beschreibung.
  ///
  /// In en, this message translates to:
  /// **'Description:'**
  String get beschreibung;

  /// No description provided for @kategorie.
  ///
  /// In en, this message translates to:
  /// **'Category:'**
  String get kategorie;

  /// No description provided for @adresse.
  ///
  /// In en, this message translates to:
  /// **'Address:'**
  String get adresse;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get status;

  /// No description provided for @jedenWochentag.
  ///
  /// In en, this message translates to:
  /// **'Every {wochentag}'**
  String jedenWochentag(Object wochentag);

  /// No description provided for @bisDatum.
  ///
  /// In en, this message translates to:
  /// **'until {datum}'**
  String bisDatum(Object datum);

  /// No description provided for @malSuffix.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get malSuffix;

  /// No description provided for @kontaktZuLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact {label}:'**
  String kontaktZuLabel(Object label);

  /// No description provided for @nummerKopiert.
  ///
  /// In en, this message translates to:
  /// **'Number copied!'**
  String get nummerKopiert;

  /// No description provided for @nummerKopieren.
  ///
  /// In en, this message translates to:
  /// **'Copy number'**
  String get nummerKopieren;

  /// No description provided for @anrufen.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get anrufen;

  /// No description provided for @fehlerPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String fehlerPrefix(Object error);

  /// No description provided for @editProfileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTooltip;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AtYourService'**
  String get appTitle;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get hello;

  /// No description provided for @kundeButton.
  ///
  /// In en, this message translates to:
  /// **'I\'m looking for a service provider'**
  String get kundeButton;

  /// No description provided for @dienstleisterButton.
  ///
  /// In en, this message translates to:
  /// **'I am a service provider'**
  String get dienstleisterButton;

  /// No description provided for @category_babysitter.
  ///
  /// In en, this message translates to:
  /// **'Babysitter / Child care'**
  String get category_babysitter;

  /// No description provided for @category_catering.
  ///
  /// In en, this message translates to:
  /// **'Catering'**
  String get category_catering;

  /// No description provided for @category_dachdecker.
  ///
  /// In en, this message translates to:
  /// **'Roofer'**
  String get category_dachdecker;

  /// No description provided for @category_elektriker.
  ///
  /// In en, this message translates to:
  /// **'Electrician'**
  String get category_elektriker;

  /// No description provided for @category_ernaehrungsberatung.
  ///
  /// In en, this message translates to:
  /// **'Nutrition consulting'**
  String get category_ernaehrungsberatung;

  /// No description provided for @category_eventplanung.
  ///
  /// In en, this message translates to:
  /// **'Event planning'**
  String get category_eventplanung;

  /// No description provided for @category_fahrdienste.
  ///
  /// In en, this message translates to:
  /// **'Transport services'**
  String get category_fahrdienste;

  /// No description provided for @category_fahrlehrer.
  ///
  /// In en, this message translates to:
  /// **'Driving instructor'**
  String get category_fahrlehrer;

  /// No description provided for @category_fensterputzer.
  ///
  /// In en, this message translates to:
  /// **'Window cleaner'**
  String get category_fensterputzer;

  /// No description provided for @category_fliesenleger.
  ///
  /// In en, this message translates to:
  /// **'Tiler'**
  String get category_fliesenleger;

  /// No description provided for @category_fotografie.
  ///
  /// In en, this message translates to:
  /// **'Photography / Videography'**
  String get category_fotografie;

  /// No description provided for @category_friseur.
  ///
  /// In en, this message translates to:
  /// **'Hairdresser'**
  String get category_friseur;

  /// No description provided for @category_gartenpflege.
  ///
  /// In en, this message translates to:
  /// **'Garden care / Lawn mowing'**
  String get category_gartenpflege;

  /// No description provided for @category_grafikdesign.
  ///
  /// In en, this message translates to:
  /// **'Graphic design'**
  String get category_grafikdesign;

  /// No description provided for @category_handy_reparatur.
  ///
  /// In en, this message translates to:
  /// **'Smartphone / Tablet repair'**
  String get category_handy_reparatur;

  /// No description provided for @category_haushaltsreinigung.
  ///
  /// In en, this message translates to:
  /// **'House cleaning'**
  String get category_haushaltsreinigung;

  /// No description provided for @category_hausmeisterservice.
  ///
  /// In en, this message translates to:
  /// **'Janitorial service'**
  String get category_hausmeisterservice;

  /// No description provided for @category_heizungsbauer.
  ///
  /// In en, this message translates to:
  /// **'Heating installer'**
  String get category_heizungsbauer;

  /// No description provided for @category_hundesitter.
  ///
  /// In en, this message translates to:
  /// **'Dog sitting / Walking'**
  String get category_hundesitter;

  /// No description provided for @category_it_support.
  ///
  /// In en, this message translates to:
  /// **'IT support'**
  String get category_it_support;

  /// No description provided for @category_klempner.
  ///
  /// In en, this message translates to:
  /// **'Plumber'**
  String get category_klempner;

  /// No description provided for @category_kosmetik.
  ///
  /// In en, this message translates to:
  /// **'Beautician'**
  String get category_kosmetik;

  /// No description provided for @category_kuenstler.
  ///
  /// In en, this message translates to:
  /// **'Artist (e.g. musician for events)'**
  String get category_kuenstler;

  /// No description provided for @category_kurierdienst.
  ///
  /// In en, this message translates to:
  /// **'Courier service'**
  String get category_kurierdienst;

  /// No description provided for @category_maler.
  ///
  /// In en, this message translates to:
  /// **'Painter'**
  String get category_maler;

  /// No description provided for @category_massagen.
  ///
  /// In en, this message translates to:
  /// **'Massage'**
  String get category_massagen;

  /// No description provided for @category_maurer.
  ///
  /// In en, this message translates to:
  /// **'Bricklayer'**
  String get category_maurer;

  /// No description provided for @category_moebelaufbau.
  ///
  /// In en, this message translates to:
  /// **'Furniture assembly'**
  String get category_moebelaufbau;

  /// No description provided for @category_musikunterricht.
  ///
  /// In en, this message translates to:
  /// **'Music lessons'**
  String get category_musikunterricht;

  /// No description provided for @category_nachhilfe.
  ///
  /// In en, this message translates to:
  /// **'Tutoring'**
  String get category_nachhilfe;

  /// No description provided for @category_nagelstudio.
  ///
  /// In en, this message translates to:
  /// **'Nail studio'**
  String get category_nagelstudio;

  /// No description provided for @category_pc_reparatur.
  ///
  /// In en, this message translates to:
  /// **'PC / Laptop repair'**
  String get category_pc_reparatur;

  /// No description provided for @category_partyservice.
  ///
  /// In en, this message translates to:
  /// **'Party service'**
  String get category_partyservice;

  /// No description provided for @category_personal_trainer.
  ///
  /// In en, this message translates to:
  /// **'Personal trainer'**
  String get category_personal_trainer;

  /// No description provided for @category_rasenmaeher_service.
  ///
  /// In en, this message translates to:
  /// **'Garden Care / Landscaping'**
  String get category_rasenmaeher_service;

  /// No description provided for @category_rechtsberatung.
  ///
  /// In en, this message translates to:
  /// **'Legal consulting'**
  String get category_rechtsberatung;

  /// No description provided for @category_reparaturdienste.
  ///
  /// In en, this message translates to:
  /// **'Repair services'**
  String get category_reparaturdienste;

  /// No description provided for @category_seniorenbetreuung.
  ///
  /// In en, this message translates to:
  /// **'Senior care'**
  String get category_seniorenbetreuung;

  /// No description provided for @category_social_media.
  ///
  /// In en, this message translates to:
  /// **'Social media management'**
  String get category_social_media;

  /// No description provided for @category_sonstige.
  ///
  /// In en, this message translates to:
  /// **'Other services'**
  String get category_sonstige;

  /// No description provided for @category_sprachunterricht.
  ///
  /// In en, this message translates to:
  /// **'Language lessons'**
  String get category_sprachunterricht;

  /// No description provided for @category_steuerberatung.
  ///
  /// In en, this message translates to:
  /// **'Tax consulting'**
  String get category_steuerberatung;

  /// No description provided for @category_tischler.
  ///
  /// In en, this message translates to:
  /// **'Carpenter'**
  String get category_tischler;

  /// No description provided for @category_transport.
  ///
  /// In en, this message translates to:
  /// **'Transport & Mobility'**
  String get category_transport;

  /// No description provided for @category_umzugstransporte.
  ///
  /// In en, this message translates to:
  /// **'Moving transport'**
  String get category_umzugstransporte;

  /// No description provided for @category_umzugshelfer.
  ///
  /// In en, this message translates to:
  /// **'Moving helper'**
  String get category_umzugshelfer;

  /// No description provided for @category_uebersetzungen.
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get category_uebersetzungen;

  /// No description provided for @category_waescheservice.
  ///
  /// In en, this message translates to:
  /// **'Laundry service'**
  String get category_waescheservice;

  /// No description provided for @category_webdesign.
  ///
  /// In en, this message translates to:
  /// **'Web design'**
  String get category_webdesign;

  /// No description provided for @category_einkaufsservice.
  ///
  /// In en, this message translates to:
  /// **'Shopping service'**
  String get category_einkaufsservice;

  /// No description provided for @category_haustierbetreuung.
  ///
  /// In en, this message translates to:
  /// **'Pet care'**
  String get category_haustierbetreuung;

  /// No description provided for @premiumBadgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumBadgeLabel;

  /// No description provided for @statusOffen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOffen;

  /// No description provided for @statusInBearbeitung.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInBearbeitung;

  /// No description provided for @statusAbgeschlossen.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusAbgeschlossen;

  /// No description provided for @privacyButton.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyButton;

  /// No description provided for @interval_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get interval_weekly;

  /// No description provided for @interval_biweekly.
  ///
  /// In en, this message translates to:
  /// **'Every 2 weeks'**
  String get interval_biweekly;

  /// No description provided for @interval_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get interval_monthly;

  /// No description provided for @weekday_monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekday_monday;

  /// No description provided for @weekday_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekday_tuesday;

  /// No description provided for @weekday_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekday_wednesday;

  /// No description provided for @weekday_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekday_thursday;

  /// No description provided for @weekday_friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekday_friday;

  /// No description provided for @weekday_saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekday_saturday;

  /// No description provided for @weekday_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekday_sunday;

  /// No description provided for @kundenInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'You are logged in as a customer. Please describe the service you need here. Service providers will then send you offers.'**
  String get kundenInfoBanner;

  /// No description provided for @titelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Have my apartment cleaned'**
  String get titelHint;

  /// No description provided for @beschreibungHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what needs to be done – e.g. clean 3 rooms, kitchen, and bathroom ...'**
  String get beschreibungHint;

  /// No description provided for @invoiceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice data (Gold only)'**
  String get invoiceSectionTitle;

  /// No description provided for @invoiceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice name (e.g. company name)'**
  String get invoiceNameLabel;

  /// No description provided for @invoiceAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice address:'**
  String get invoiceAddressLabel;

  /// No description provided for @invoiceTaxNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax number (optional)'**
  String get invoiceTaxNumberLabel;

  /// No description provided for @invoiceIbanLabel.
  ///
  /// In en, this message translates to:
  /// **'IBAN (optional)'**
  String get invoiceIbanLabel;

  /// No description provided for @invoiceLogoUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Logo URL (optional)'**
  String get invoiceLogoUrlLabel;

  /// No description provided for @invoiceGoldInfo.
  ///
  /// In en, this message translates to:
  /// **'Invoice data can be edited in the GOLD plan.'**
  String get invoiceGoldInfo;

  /// No description provided for @rechnungGenerierenButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Generate Invoice'**
  String get rechnungGenerierenButtonLabel;

  /// No description provided for @meineAbgeschlossenenAuftraege.
  ///
  /// In en, this message translates to:
  /// **'My Completed Orders'**
  String get meineAbgeschlossenenAuftraege;

  /// No description provided for @verbergenButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get verbergenButtonLabel;

  /// No description provided for @rechnungGenerierenAppBar.
  ///
  /// In en, this message translates to:
  /// **'Generate Invoice'**
  String get rechnungGenerierenAppBar;

  /// No description provided for @rechnungAlsPdfAnzeigenLabel.
  ///
  /// In en, this message translates to:
  /// **'Show invoice as PDF'**
  String get rechnungAlsPdfAnzeigenLabel;

  /// No description provided for @invoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoiceLabel;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From:'**
  String get fromLabel;

  /// No description provided for @taxNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax number:'**
  String get taxNumberLabel;

  /// No description provided for @ibanLabel.
  ///
  /// In en, this message translates to:
  /// **'IBAN:'**
  String get ibanLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To:'**
  String get toLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount:'**
  String get amountLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get dateLabel;

  /// No description provided for @generatedByText.
  ///
  /// In en, this message translates to:
  /// **'This invoice was automatically generated via AtYourService.'**
  String get generatedByText;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount.'**
  String get amountRequired;

  /// No description provided for @premiumGoldInvoiceFeature.
  ///
  /// In en, this message translates to:
  /// **'Invoice generation as PDF'**
  String get premiumGoldInvoiceFeature;

  /// No description provided for @onlyForGoldTooltip.
  ///
  /// In en, this message translates to:
  /// **'This feature is available only for Gold subscribers.'**
  String get onlyForGoldTooltip;

  /// No description provided for @deleteJobTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove job from the list'**
  String get deleteJobTooltip;

  /// No description provided for @invoiceNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get invoiceNumberLabel;

  /// No description provided for @invoiceProfileHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your invoice details in your profile. These will automatically be included in the PDF invoice.'**
  String get invoiceProfileHint;

  /// No description provided for @auftragErneutPosten.
  ///
  /// In en, this message translates to:
  /// **'Repost job'**
  String get auftragErneutPosten;

  /// No description provided for @auftragErneutPostenTitle.
  ///
  /// In en, this message translates to:
  /// **'Repost this job?'**
  String get auftragErneutPostenTitle;

  /// No description provided for @auftragErneutPostenText.
  ///
  /// In en, this message translates to:
  /// **'The current provider will be removed. The job will become visible to others again. Do you want to continue?'**
  String get auftragErneutPostenText;

  /// No description provided for @auftragErneutGepostet.
  ///
  /// In en, this message translates to:
  /// **'The job has been reposted.'**
  String get auftragErneutGepostet;

  /// No description provided for @premiumActivated.
  ///
  /// In en, this message translates to:
  /// **'Subscription activated successfully!'**
  String get premiumActivated;

  /// No description provided for @premiumPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed: {error}'**
  String premiumPurchaseFailed(Object error);

  /// No description provided for @premiumProductNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found!'**
  String get premiumProductNotFound;

  /// No description provided for @premiumStoreNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Store products could not be loaded.'**
  String get premiumStoreNotLoaded;

  /// No description provided for @premiumYearlySuffix.
  ///
  /// In en, this message translates to:
  /// **'Yearly: {price}'**
  String premiumYearlySuffix(Object price);

  /// No description provided for @premiumYearlyButton.
  ///
  /// In en, this message translates to:
  /// **'{plan} (Yearly)'**
  String premiumYearlyButton(Object plan);

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? All your data will be permanently removed.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get accountDeleted;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @premiumDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Premium deactivated.'**
  String get premiumDeactivated;

  /// No description provided for @acceptedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Accepted by {name}'**
  String acceptedByLabel(Object name);

  /// No description provided for @adresseValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter an address.'**
  String get adresseValidator;

  /// No description provided for @abgeschlosseneAuftraegeHinweis.
  ///
  /// In en, this message translates to:
  /// **'Here you can delete completed jobs and rate your service provider.'**
  String get abgeschlosseneAuftraegeHinweis;

  /// No description provided for @goldBadgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Gold Subscription'**
  String get goldBadgeLabel;

  /// No description provided for @silverBadgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Silver Subscription'**
  String get silverBadgeLabel;

  /// No description provided for @topBewertetBadgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topBewertetBadgeLabel;

  /// No description provided for @badgeCertified.
  ///
  /// In en, this message translates to:
  /// **'Certified'**
  String get badgeCertified;

  /// No description provided for @badgeExperienced.
  ///
  /// In en, this message translates to:
  /// **'Experienced'**
  String get badgeExperienced;

  /// No description provided for @badgeExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get badgeExpert;

  /// No description provided for @badgeMaster.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get badgeMaster;

  /// No description provided for @badgeCertifiedCounter.
  ///
  /// In en, this message translates to:
  /// **'{count} jobs completed'**
  String badgeCertifiedCounter(Object count);

  /// No description provided for @badgeExperiencedCounter.
  ///
  /// In en, this message translates to:
  /// **'{count} jobs completed'**
  String badgeExperiencedCounter(Object count);

  /// No description provided for @badgeExpertCounter.
  ///
  /// In en, this message translates to:
  /// **'{count} jobs completed'**
  String badgeExpertCounter(Object count);

  /// No description provided for @badgeMasterCounter.
  ///
  /// In en, this message translates to:
  /// **'{count} jobs completed'**
  String badgeMasterCounter(Object count);

  /// No description provided for @achievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements & Badges'**
  String get achievementTitle;

  /// No description provided for @goldBadgeDesc.
  ///
  /// In en, this message translates to:
  /// **'You have a Gold subscription and can accept unlimited jobs.'**
  String get goldBadgeDesc;

  /// No description provided for @silverBadgeDesc.
  ///
  /// In en, this message translates to:
  /// **'You have a Silver subscription and can accept 3 jobs per week.'**
  String get silverBadgeDesc;

  /// No description provided for @topBewertetBadgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Maintain an average rating of at least 4.5 stars from at least 5 reviews.'**
  String get topBewertetBadgeDesc;

  /// No description provided for @badgeCertifiedProgress.
  ///
  /// In en, this message translates to:
  /// **'Certified ({count}/1)'**
  String badgeCertifiedProgress(Object count);

  /// No description provided for @badgeCertifiedDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 3 jobs.'**
  String get badgeCertifiedDesc;

  /// No description provided for @badgeExperiencedProgress.
  ///
  /// In en, this message translates to:
  /// **'Experienced ({count}/2)'**
  String badgeExperiencedProgress(Object count);

  /// No description provided for @badgeExperiencedDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete a total of 10 jobs.'**
  String get badgeExperiencedDesc;

  /// No description provided for @badgeExpertProgress.
  ///
  /// In en, this message translates to:
  /// **'Expert ({count}/3)'**
  String badgeExpertProgress(Object count);

  /// No description provided for @badgeExpertDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete a total of 25 jobs.'**
  String get badgeExpertDesc;

  /// No description provided for @badgeMasterProgress.
  ///
  /// In en, this message translates to:
  /// **'Master ({count}/4)'**
  String badgeMasterProgress(Object count);

  /// No description provided for @badgeMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete a total of 50 jobs.'**
  String get badgeMasterDesc;

  /// No description provided for @trafficScreenInfoText.
  ///
  /// In en, this message translates to:
  /// **'Here you can see how many service providers are currently active in each category in your area. The more providers, the faster your request is usually accepted.'**
  String get trafficScreenInfoText;

  /// No description provided for @filterAbgeschlossen.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get filterAbgeschlossen;

  /// No description provided for @auftraege.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get auftraege;

  /// No description provided for @profil.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profil;

  /// No description provided for @filterAlle.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAlle;

  /// No description provided for @filterOffen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get filterOffen;

  /// No description provided for @filterLaufend.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get filterLaufend;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordButton;

  /// No description provided for @forgotPasswordInfo.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address. You will receive a link to reset your password.'**
  String get forgotPasswordInfo;

  /// No description provided for @sendResetLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLinkButton;

  /// No description provided for @resetMailSent.
  ///
  /// In en, this message translates to:
  /// **'Link has been sent. Please check your inbox!'**
  String get resetMailSent;

  /// No description provided for @keineDienstleisterInRegion.
  ///
  /// In en, this message translates to:
  /// **'No service provider found in your area yet.'**
  String get keineDienstleisterInRegion;

  /// No description provided for @trafficScreenKeineAdresse.
  ///
  /// In en, this message translates to:
  /// **'No address found in your profile.'**
  String get trafficScreenKeineAdresse;

  /// No description provided for @trafficScreenAdresseFehler.
  ///
  /// In en, this message translates to:
  /// **'Your address could not be converted to coordinates.'**
  String get trafficScreenAdresseFehler;

  /// No description provided for @auftragWiederkehrendAppBar.
  ///
  /// In en, this message translates to:
  /// **'Recurring Job'**
  String get auftragWiederkehrendAppBar;

  /// No description provided for @auftragWiederkehrendHeadline.
  ///
  /// In en, this message translates to:
  /// **'Should this job be repeated regularly?'**
  String get auftragWiederkehrendHeadline;

  /// No description provided for @auftragWiederkehrendInfo.
  ///
  /// In en, this message translates to:
  /// **'Choose whether and how often the job should be performed automatically.'**
  String get auftragWiederkehrendInfo;

  /// No description provided for @auftragReviewAppBar.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get auftragReviewAppBar;

  /// No description provided for @auftragReviewHeadline.
  ///
  /// In en, this message translates to:
  /// **'Everything correct?'**
  String get auftragReviewHeadline;

  /// No description provided for @auftragReviewInfo.
  ///
  /// In en, this message translates to:
  /// **'Please review your entries before submitting the job.'**
  String get auftragReviewInfo;

  /// No description provided for @absendenButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get absendenButton;

  /// No description provided for @ja.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get ja;

  /// No description provided for @nein.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get nein;

  /// No description provided for @wiederholenBisLabelPlain.
  ///
  /// In en, this message translates to:
  /// **'Repeat until'**
  String get wiederholenBisLabelPlain;

  /// No description provided for @auftragAdresseAppBar.
  ///
  /// In en, this message translates to:
  /// **'Address & Contact'**
  String get auftragAdresseAppBar;

  /// No description provided for @auftragAdresseHeadline.
  ///
  /// In en, this message translates to:
  /// **'Where should the job be performed?'**
  String get auftragAdresseHeadline;

  /// No description provided for @auftragAdresseInfo.
  ///
  /// In en, this message translates to:
  /// **'Please enter the address and your phone number so the provider can contact you.'**
  String get auftragAdresseInfo;

  /// No description provided for @adresseHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Main Street 12, 12345 Berlin'**
  String get adresseHint;

  /// No description provided for @telefonnummerHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 0176 12345678'**
  String get telefonnummerHint;

  /// No description provided for @zurueckButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get zurueckButton;

  /// No description provided for @weiterButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get weiterButton;

  /// No description provided for @auftragKategorieAppBar.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get auftragKategorieAppBar;

  /// No description provided for @auftragKategorieHeadline.
  ///
  /// In en, this message translates to:
  /// **'For which category do you need help?'**
  String get auftragKategorieHeadline;

  /// No description provided for @auftragKategorieInfo.
  ///
  /// In en, this message translates to:
  /// **'Choose the right service. You can specify more details later.'**
  String get auftragKategorieInfo;

  /// No description provided for @kategorieValidator.
  ///
  /// In en, this message translates to:
  /// **'Please select a category.'**
  String get kategorieValidator;

  /// No description provided for @auftragDetailsAppBar.
  ///
  /// In en, this message translates to:
  /// **'Job details'**
  String get auftragDetailsAppBar;

  /// No description provided for @auftragDetailsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Describe your job'**
  String get auftragDetailsHeadline;

  /// No description provided for @auftragDetailsInfo.
  ///
  /// In en, this message translates to:
  /// **'What needs to be done? The more details, the better!'**
  String get auftragDetailsInfo;

  /// No description provided for @auftragTerminAppBar.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get auftragTerminAppBar;

  /// No description provided for @auftragTerminHeadline.
  ///
  /// In en, this message translates to:
  /// **'When should the job be done?'**
  String get auftragTerminHeadline;

  /// No description provided for @auftragTerminInfo.
  ///
  /// In en, this message translates to:
  /// **'Set the date and time or choose \'as soon as possible\'.'**
  String get auftragTerminInfo;

  /// No description provided for @terminLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get terminLabel;

  /// No description provided for @preisLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (€) or \'negotiable\''**
  String get preisLabel;

  /// No description provided for @preisHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 60 or \'negotiable\''**
  String get preisHint;

  /// No description provided for @preisValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price or \'negotiable\'.'**
  String get preisValidator;

  /// No description provided for @preisHinweisLabel.
  ///
  /// In en, this message translates to:
  /// **'Price note (optional)'**
  String get preisHinweisLabel;

  /// No description provided for @preisHinweisHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. hourly rate, material costs, negotiable, etc.'**
  String get preisHinweisHint;

  /// No description provided for @preisTypLabel.
  ///
  /// In en, this message translates to:
  /// **'Select price option'**
  String get preisTypLabel;

  /// No description provided for @preisTypGesamt.
  ///
  /// In en, this message translates to:
  /// **'Total price'**
  String get preisTypGesamt;

  /// No description provided for @preisTypStunden.
  ///
  /// In en, this message translates to:
  /// **'Hourly rate'**
  String get preisTypStunden;

  /// No description provided for @preisTypVerhandelbar.
  ///
  /// In en, this message translates to:
  /// **'Negotiable / on request'**
  String get preisTypVerhandelbar;

  /// No description provided for @preisLabelGesamt.
  ///
  /// In en, this message translates to:
  /// **'Total price (€)'**
  String get preisLabelGesamt;

  /// No description provided for @preisHintGesamt.
  ///
  /// In en, this message translates to:
  /// **'e.g. 120'**
  String get preisHintGesamt;

  /// No description provided for @preisLabelStunden.
  ///
  /// In en, this message translates to:
  /// **'Hourly rate (€ per hour)'**
  String get preisLabelStunden;

  /// No description provided for @preisHintStunden.
  ///
  /// In en, this message translates to:
  /// **'e.g. 20'**
  String get preisHintStunden;

  /// No description provided for @preisHinweisVerhandelbar.
  ///
  /// In en, this message translates to:
  /// **'Price negotiable / offers welcome'**
  String get preisHinweisVerhandelbar;

  /// No description provided for @preisTypGesamtDesc.
  ///
  /// In en, this message translates to:
  /// **'You specify the total price for the job.'**
  String get preisTypGesamtDesc;

  /// No description provided for @preisTypStundenDesc.
  ///
  /// In en, this message translates to:
  /// **'You specify an hourly rate for the job.'**
  String get preisTypStundenDesc;

  /// No description provided for @preisTypVerhandelbarDesc.
  ///
  /// In en, this message translates to:
  /// **'The price will be negotiated directly with the service provider.'**
  String get preisTypVerhandelbarDesc;

  /// No description provided for @heimatadresseButtonInfo.
  ///
  /// In en, this message translates to:
  /// **'Tap here to auto-fill your saved home address. (Configurable in your profile)'**
  String get heimatadresseButtonInfo;

  /// No description provided for @verhandelbarLabel.
  ///
  /// In en, this message translates to:
  /// **'Negotiable'**
  String get verhandelbarLabel;

  /// No description provided for @terminValidierungFehler.
  ///
  /// In en, this message translates to:
  /// **'Please select a date and both time slots.'**
  String get terminValidierungFehler;

  /// No description provided for @wiederkehrendValidierungFehler.
  ///
  /// In en, this message translates to:
  /// **'Please select interval, weekday, and number of repetitions for recurring tasks correctly.'**
  String get wiederkehrendValidierungFehler;

  /// No description provided for @priceTotal.
  ///
  /// In en, this message translates to:
  /// **'{amount} €'**
  String priceTotal(Object amount);

  /// No description provided for @pricePerHour.
  ///
  /// In en, this message translates to:
  /// **'{amount} € / {hourShort}'**
  String pricePerHour(Object amount, Object hourShort);

  /// No description provided for @priceNegotiable.
  ///
  /// In en, this message translates to:
  /// **'Negotiable'**
  String get priceNegotiable;

  /// No description provided for @hourShort.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get hourShort;

  /// No description provided for @setNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get setNewPasswordTitle;

  /// No description provided for @setNewPasswordInfo.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password twice to confirm.'**
  String get setNewPasswordInfo;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPasswordLabel;

  /// No description provided for @saveNewPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Save new password'**
  String get saveNewPasswordButton;

  /// No description provided for @passwordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty.'**
  String get passwordEmptyError;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDontMatch;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful. You can now log in.'**
  String get passwordResetSuccess;

  /// No description provided for @premiumRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get premiumRestorePurchases;

  /// No description provided for @premiumRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get premiumRetry;

  /// No description provided for @wrongRoleCustomer.
  ///
  /// In en, this message translates to:
  /// **'This account is registered as a service provider and cannot be used to log in as a customer.'**
  String get wrongRoleCustomer;

  /// No description provided for @accountNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email. Please register first.'**
  String get accountNotRegistered;

  /// No description provided for @wrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get wrongCredentials;

  /// No description provided for @premiumPushDelayFree.
  ///
  /// In en, this message translates to:
  /// **'Push notifications: 1h delay'**
  String get premiumPushDelayFree;

  /// No description provided for @premiumPushDelaySilver.
  ///
  /// In en, this message translates to:
  /// **'Push notifications: 30 min delay'**
  String get premiumPushDelaySilver;

  /// No description provided for @premiumPushDelayGold.
  ///
  /// In en, this message translates to:
  /// **'Push notifications: instant on new jobs'**
  String get premiumPushDelayGold;

  /// No description provided for @companyNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Company name (optional)'**
  String get companyNameOptional;

  /// No description provided for @vatIdOptional.
  ///
  /// In en, this message translates to:
  /// **'VAT ID (optional)'**
  String get vatIdOptional;

  /// No description provided for @bicOptional.
  ///
  /// In en, this message translates to:
  /// **'BIC (optional)'**
  String get bicOptional;

  /// No description provided for @smallBusinessLabel.
  ///
  /// In en, this message translates to:
  /// **'Small business according to §19 UStG'**
  String get smallBusinessLabel;

  /// No description provided for @defaultVatRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Standard VAT rate (%)'**
  String get defaultVatRateLabel;

  /// No description provided for @invalidVatRate.
  ///
  /// In en, this message translates to:
  /// **'Invalid VAT rate'**
  String get invalidVatRate;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileNameLabel;

  /// No description provided for @invoiceNoShort.
  ///
  /// In en, this message translates to:
  /// **'No:'**
  String get invoiceNoShort;

  /// No description provided for @netAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get netAmountLabel;

  /// No description provided for @vatLabelWithPercent.
  ///
  /// In en, this message translates to:
  /// **'VAT ({percent}%)'**
  String vatLabelWithPercent(Object percent);

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @dueOnLabel.
  ///
  /// In en, this message translates to:
  /// **'Due on:'**
  String get dueOnLabel;

  /// No description provided for @vatIdLabel.
  ///
  /// In en, this message translates to:
  /// **'VAT ID:'**
  String get vatIdLabel;

  /// No description provided for @bicLabel.
  ///
  /// In en, this message translates to:
  /// **'BIC:'**
  String get bicLabel;

  /// No description provided for @paymentTermsDefault.
  ///
  /// In en, this message translates to:
  /// **'Payable within {days} days without deduction.'**
  String paymentTermsDefault(Object days);

  /// No description provided for @badgeInfoText.
  ///
  /// In en, this message translates to:
  /// **'These badges can only be earned by service providers and appear when the provider accepts the job.'**
  String get badgeInfoText;

  /// No description provided for @noAuftraegeKundeHint.
  ///
  /// In en, this message translates to:
  /// **'Create your first job by tapping the plus (+) button.'**
  String get noAuftraegeKundeHint;

  /// No description provided for @upsellCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Job near you'**
  String get upsellCardTitle;

  /// No description provided for @upsellCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String upsellCategoryLabel(String category);

  /// No description provided for @upsellUpgradeButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to {plan} to view this job'**
  String upsellUpgradeButton(String plan);

  /// No description provided for @planFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get planFree;

  /// No description provided for @planSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get planSilver;

  /// No description provided for @planGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get planGold;

  /// No description provided for @filterNeu.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get filterNeu;

  /// No description provided for @onlyNewWindowInfo.
  ///
  /// In en, this message translates to:
  /// **'Showing jobs from the last {hours} hours.'**
  String onlyNewWindowInfo(int hours);

  /// Generic cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// CTA to open provider profile screen
  ///
  /// In en, this message translates to:
  /// **'Complete profile'**
  String get editProfileCta;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['nl', 'de', 'en', 'es', 'fr', 'it', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'nl': return AppLocalizationsNl();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
