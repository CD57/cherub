// chat_database.dart - Service to manage chat database connections and actions

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models/date_message_model.dart';

const String users = "Users";
const String chats = "Chats";
const String messages = "Messages";

class ChatDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  ChatDatabase();

  // Create Date Chat
  Future<DocumentReference?> createDateChat(Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("chat_database.dart - createDateChat()");
    }
    try {
      DocumentReference _dateChat = await _db.collection(chats).add(_data);
      return _dateChat;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Get Date Chats
  Stream<QuerySnapshot> getDateChats(String _uid) {
    if (kDebugMode) {
      print("chat_database.dart - getDateChats()");
    }
    try {
      return _db
          .collection(chats)
          .where('contacts', arrayContains: _uid)
          .snapshots();
    } catch (e) {
      if (kDebugMode) {
        print("chat_database.dart - getDateChats() - FAILED: " + e.toString());
      }
      return _db
          .collection(chats)
          .where('contacts', arrayContains: _uid)
          .snapshots();
    }
  }

  // Update date chat
  Future<void> updateDateChat(
      String _dateID, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("chat_database.dart - updateChat()");
    }
    try {
      await _db.collection(chats).doc(_dateID).update(_data);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Delete Date Chat
  Future<void> deleteDateChat(String _dateID) async {
    if (kDebugMode) {
      print("chat_database.dart - deleteDateChat()");
    }
    try {
      await _db.collection(chats).doc(_dateID).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Get Last Active Time of Users
  Future<void> updateLastActiveTime(String _uid) async {
    if (kDebugMode) {
      print("chat_database.dart - updateLastActiveTime()");
    }
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

  // Get Last Message of Date Chat
  Future<QuerySnapshot> getLastMessage(String _dateID) {
    if (kDebugMode) {
      print("chat_database.dart - getLastMessage()");
    }
    return _db
        .collection(chats)
        .doc(_dateID)
        .collection(messages)
        .orderBy("sentTime", descending: true)
        .limit(1)
        .get();
  }

  // Add message to date chat
  Future<void> addMessage(String _dateID, DateMessage _message) async {
    if (kDebugMode) {
      print("chat_database.dart - addMessage()");
    }
    try {
      await _db.collection(chats).doc(_dateID).collection(messages).add(
            _message.toJson(),
          );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Listen to stream of select dates messages
  Stream<QuerySnapshot> streamMessages(String _dateID) {
    if (kDebugMode) {
      print("chat_database.dart - streamMessages()");
    }
    return _db
        .collection(chats)
        .doc(_dateID)
        .collection(messages)
        .orderBy("sentTime", descending: false)
        .snapshots();
  }
}
