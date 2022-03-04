import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

const String users = "Users";

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  StorageService();

  Future<String?> saveProfilePicture(String _uid, PlatformFile _file) async {
    try {
      Reference _ref =
          _storage.ref().child('images/users/$_uid/profile.${_file.extension}');
      UploadTask _task = _ref.putFile(
        File(_file.path!),
      );
      return await _task.then(
        (_result) => _result.ref.getDownloadURL(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
