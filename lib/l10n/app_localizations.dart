import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
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
  /// **'Password must be at least 6 characters'**
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
  /// **'Description'**
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
  /// **'Unlimited job acceptance'**
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
  /// **'Unlimited job acceptance'**
  String get premiumGoldFeature1;

  /// No description provided for @premiumGoldFeature2.
  ///
  /// In en, this message translates to:
  /// **'Jobs within a 40 km radius'**
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
  /// **'Lawnmower service'**
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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
