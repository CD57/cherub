// storage_service.dart - Service to manage firebase cloud storage, such as for profile pictures and media content

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

const String users = "Users";

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  StorageService();

  Future<String?> saveProfilePicture(String _uid, XFile _file) async {
    try {
      Reference _ref = _storage.ref().child('images/users/$_uid/profile');
      UploadTask _task = _ref.putFile(File(_file.path));
      Future<String?> downloadURL = _task.then((res) {
        return res.ref.getDownloadURL();
      });
      return downloadURL;
    } catch (e) {
      if (kDebugMode) {
        print("storage_service.dart - Error - " + e.toString());
      }
      return null;
    }
  }

  Future<String?> saveMedia(String _chatID, String _userID, XFile _file) async {
    try {
      Reference _ref = _storage
          .ref()
          .child('images/chats/$_chatID/${_userID}_${DateTime.now()}');
      UploadTask _task = _ref.putFile(
        File(_file.path),
      );
      return await _task.then(
        (_result) => _result.ref.getDownloadURL(),
      );
    } catch (e) {
      if (kDebugMode) {
        print("storage_service.dart - Error - " + e.toString());
      }
      return null;
    }
  }
}
