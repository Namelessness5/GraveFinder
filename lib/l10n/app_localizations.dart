import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GraveFinder'**
  String get appTitle;

  /// No description provided for @addPersonTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Person'**
  String get addPersonTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the name of a relative or friend'**
  String get nameHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @addRelationship.
  ///
  /// In en, this message translates to:
  /// **'Add New Relationship'**
  String get addRelationship;

  /// No description provided for @selectTarget.
  ///
  /// In en, this message translates to:
  /// **'Select Target Person'**
  String get selectTarget;

  /// No description provided for @relationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship Name'**
  String get relationshipLabel;

  /// No description provided for @saveAndConnect.
  ///
  /// In en, this message translates to:
  /// **'Save and Connect'**
  String get saveAndConnect;

  /// Title for the person detail screen
  ///
  /// In en, this message translates to:
  /// **'Details of {name}'**
  String detailTitle(String name);

  /// No description provided for @addStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Guidance Step'**
  String get addStepTitle;

  /// No description provided for @stepDescHint.
  ///
  /// In en, this message translates to:
  /// **'How to get to the destination?'**
  String get stepDescHint;

  /// No description provided for @tapToTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to take photo'**
  String get tapToTakePhoto;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Title for the navigation route
  ///
  /// In en, this message translates to:
  /// **'Route to {name}'**
  String routeToName(String name);

  /// No description provided for @noRouteRecords.
  ///
  /// In en, this message translates to:
  /// **'No routes recorded yet\nTap the bottom right to start'**
  String get noRouteRecords;

  /// No description provided for @recordNewLandmark.
  ///
  /// In en, this message translates to:
  /// **'Record New Landmark'**
  String get recordNewLandmark;

  /// No description provided for @upload_photo.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get upload_photo;

  /// No description provided for @nameinfo.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameinfo;

  /// No description provided for @birthDateHint.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDateHint;

  /// No description provided for @deathDateHint.
  ///
  /// In en, this message translates to:
  /// **'Date of Passing'**
  String get deathDateHint;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @last_mile_navigation_description1.
  ///
  /// In en, this message translates to:
  /// **'Last-Mile Guidance'**
  String get last_mile_navigation_description1;

  /// No description provided for @last_mile_navigation_description2.
  ///
  /// In en, this message translates to:
  /// **'Record photo and text landmarks to find the burial site'**
  String get last_mile_navigation_description2;

  /// No description provided for @error_adding_connection_without_others.
  ///
  /// In en, this message translates to:
  /// **'You need to add other people to the main map first to establish a relationship.'**
  String get error_adding_connection_without_others;

  /// No description provided for @relationshipLabelHint.
  ///
  /// In en, this message translates to:
  /// **' (e.g., Parent-Child, Teacher-Student)'**
  String get relationshipLabelHint;

  /// No description provided for @input_select_target.
  ///
  /// In en, this message translates to:
  /// **'Please select a target person'**
  String get input_select_target;

  /// No description provided for @input_relationship_label.
  ///
  /// In en, this message translates to:
  /// **'Please enter a relationship name'**
  String get input_relationship_label;

  /// No description provided for @build_connection_success.
  ///
  /// In en, this message translates to:
  /// **'Relationship added successfully'**
  String get build_connection_success;

  /// No description provided for @cameraLabel.
  ///
  /// In en, this message translates to:
  /// **'Take the photo from camera'**
  String get cameraLabel;

  /// No description provided for @galleryLabel.
  ///
  /// In en, this message translates to:
  /// **'Pick an image from gallery'**
  String get galleryLabel;

  /// No description provided for @imagePickerErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error in picking image'**
  String get imagePickerErrorMessage;

  /// No description provided for @has_last_mile.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get has_last_mile;

  /// No description provided for @copyrightNotice.
  ///
  /// In en, this message translates to:
  /// **'All the data is stored locally and won\'t be uploaded without your permission. Please be careful with the data and make your own back-up.'**
  String get copyrightNotice;

  /// No description provided for @softwareDescription.
  ///
  /// In en, this message translates to:
  /// **'———— For memory and inheritance'**
  String get softwareDescription;

  /// No description provided for @contactDeveloperLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get contactDeveloperLabel;

  /// No description provided for @developerEmail.
  ///
  /// In en, this message translates to:
  /// **'passbyyyyy@gmail.com'**
  String get developerEmail;

  /// No description provided for @storagePathLabel.
  ///
  /// In en, this message translates to:
  /// **'Path to storage'**
  String get storagePathLabel;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'version: 1.1.0'**
  String get versionLabel;

  /// No description provided for @infoScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get infoScreenTitle;

  /// No description provided for @copyToClipboardLabel.
  ///
  /// In en, this message translates to:
  /// **'Successfully copied to clipboard'**
  String get copyToClipboardLabel;

  /// No description provided for @deleteNodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete this person'**
  String get deleteNodeTooltip;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Deletion is irreversible; all information about this person will be deleted: '**
  String get deleteConfirmContent;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get confirmDelete;

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'connection'**
  String get connection;

  /// No description provided for @unknownPerson.
  ///
  /// In en, this message translates to:
  /// **'Unknown Person'**
  String get unknownPerson;

  /// No description provided for @deleteConnectionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete current connection'**
  String get deleteConnectionTooltip;

  /// No description provided for @connectionDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Connection delete successfully'**
  String get connectionDeletedSuccessfully;

  /// No description provided for @noConnectionsTip.
  ///
  /// In en, this message translates to:
  /// **'There\'s no connection with others, please add some first.'**
  String get noConnectionsTip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
