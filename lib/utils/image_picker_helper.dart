import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import 'storage_helper.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<void> showPicker(
    BuildContext context, 
    Function(String) onImageFileNamePicked,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(l10n.cameraLabel),
                onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(l10n.galleryLabel),
                onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      try {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          final fileName = await AppStorage.saveImageToAppDir(image.path);
          onImageFileNamePicked(fileName); 
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${l10n.imagePickerErrorMessage}: $e")));
        }
      }
    }
  }
}