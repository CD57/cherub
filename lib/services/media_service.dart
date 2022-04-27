// media_service.dart - Service to manage uploading media files from phone

import 'package:image_picker/image_picker.dart';

class MediaService {
  MediaService();

  Future<XFile?> getImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<XFile?> getPhotoFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    return photo;
  }
}
