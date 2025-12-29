import 'dart:io';

import 'package:image_picker/image_picker.dart';
enum ImageSourceType { camera, gallery }

class ImagePickerHelper {
  ImagePickerHelper._();

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickAvatar(ImageSourceType sourceType) async {
    XFile? imageFile;
    if (sourceType == ImageSourceType.camera) {
      imageFile = await _picker.pickImage(source: ImageSource.camera);
    } else if (sourceType == ImageSourceType.gallery) {
      imageFile = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (imageFile != null) {
      return File(imageFile.path);
    }

    return null;
  }
}
