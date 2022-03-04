import 'package:file_picker/file_picker.dart';

class MediaService {
  Future<PlatformFile?> getImage() async {
    FilePickerResult? _image =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (_image != null) {
      return _image.files[0];
    }
    return null;
  }

  MediaService();
}
