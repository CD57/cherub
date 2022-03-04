import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const String users = "Users";
const String chats = "Chats";
const String messages = "Messages";
const String plans = "Plans";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(users).doc(_uid).get();
  }

  Future<void> updateLastActive(String _uid) async {
    try {
      await _db.collection(users).doc(_uid).update(
        {
          "lastActive": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> createUser(String _uid, String _name, String _number,
      String _email, String _imageURL) async {
    try {
      await _db.collection(users).doc(_uid).set(
        {
          "name": _name,
          "number": _number,
          "email": _email,
          "image": _imageURL,
          "last_active": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
