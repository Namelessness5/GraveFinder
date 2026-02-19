// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GraveFinder';

  @override
  String get addPersonTitle => 'Add New Person';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Enter the name of a relative or friend';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get addRelationship => 'Add New Relationship';

  @override
  String get selectTarget => 'Select Target Person';

  @override
  String get relationshipLabel => 'Relationship Name';

  @override
  String get saveAndConnect => 'Save and Connect';

  @override
  String detailTitle(String name) {
    return 'Details of $name';
  }

  @override
  String get addStepTitle => 'Add Guidance Step';

  @override
  String get stepDescHint => 'How to get to the destination?';

  @override
  String get tapToTakePhoto => 'Tap to take photo';

  @override
  String get add => 'Add';

  @override
  String routeToName(String name) {
    return 'Route to $name';
  }

  @override
  String get noRouteRecords =>
      'No routes recorded yet\nTap the bottom right to start';

  @override
  String get recordNewLandmark => 'Record New Landmark';

  @override
  String get upload_photo => 'Change Photo';

  @override
  String get nameinfo => 'Name';

  @override
  String get birthDateHint => 'Birth Date';

  @override
  String get deathDateHint => 'Date of Passing';

  @override
  String get biography => 'Biography';

  @override
  String get last_mile_navigation_description1 => 'Last-Mile Guidance';

  @override
  String get last_mile_navigation_description2 =>
      'Record photo and text landmarks to find the burial site';

  @override
  String get error_adding_connection_without_others =>
      'You need to add other people to the main map first to establish a relationship.';

  @override
  String get relationshipLabelHint => ' (e.g., Parent-Child, Teacher-Student)';

  @override
  String get input_select_target => 'Please select a target person';

  @override
  String get input_relationship_label => 'Please enter a relationship name';

  @override
  String get build_connection_success => 'Relationship added successfully';

  @override
  String get cameraLabel => 'Take the photo from camera';

  @override
  String get galleryLabel => 'Pick an image from gallery';

  @override
  String get imagePickerErrorMessage => 'Error in picking image';

  @override
  String get has_last_mile => 'Directions';

  @override
  String get copyrightNotice =>
      'All the data is stored locally and won\'t be uploaded without your permission. Please be careful with the data and make your own back-up.';

  @override
  String get softwareDescription => '———— For commemorating and passing on';

  @override
  String get contactDeveloperLabel => 'Contact info';

  @override
  String get developerEmail => 'passbyyyyy@gmail.com';

  @override
  String get storagePathLabel => 'Path to storage';

  @override
  String get versionLabel => 'version: 1.1.0';

  @override
  String get infoScreenTitle => 'About';

  @override
  String get copyToClipboardLabel => 'Successfully copied to clipboard';

  @override
  String get deleteNodeTooltip => 'Delete this person';

  @override
  String get deleteConfirmTitle => 'Are you sure to delete?';

  @override
  String get deleteConfirmContent =>
      'Deletion is irreversible; all information about this person will be deleted: ';

  @override
  String get confirmDelete => 'Delete';

  @override
  String get connection => 'connection';

  @override
  String get unknownPerson => 'Unknown Person';

  @override
  String get deleteConnectionTooltip => 'Delete current connection';

  @override
  String get connectionDeletedSuccessfully => 'Connection delete successfully';

  @override
  String get noConnectionsTip =>
      'There\'s no connection with others, please add some first.';
}
