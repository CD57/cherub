// dates_page_provider.dart - Provider for the date page, retrieving relevant data to display each chat page instance details

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';
import '../providers/auth_provider.dart';
import '../models/date_chat_model.dart';
import '../models/date_message_model.dart';
import '../models/user_model.dart';

class DatesPageProvider extends ChangeNotifier {
  final AuthProvider _auth;
  late DatabaseService _db;

  List<DateChat>? dates;
  late StreamSubscription _dateChatsStream;

  DatesPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getDateChats();
  }

  @override
  void dispose() {
    _dateChatsStream.cancel();
    super.dispose();
  }

  void getDateChats() async {
    try {
      _dateChatsStream =
          _db.getDateChats(_auth.user.uid).listen((_snapshot) async {
        dates = await Future.wait(
          _snapshot.docs.map(
            (_d) async {
              Map<String, dynamic> _chatData =
                  _d.data() as Map<String, dynamic>;
              //Get Users In Chat
              List<UserModel> _contacts = [];
              for (var _uid in _chatData["contacts"]) {
                DocumentSnapshot _userSnapshot = await _db.getUserByID(_uid);
                Map<String, dynamic> _userData =
                    _userSnapshot.data() as Map<String, dynamic>;
                _userData["uid"] = _userSnapshot.id;
                _contacts.add(
                  UserModel.fromJSON(_userData),
                );
              }
              //Get Last Message For Chat
              List<DateMessage> _messages = [];
              QuerySnapshot _chatMessage = await _db.getLastMessage(_d.id);
              if (_chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> _messageData =
                    _chatMessage.docs.first.data()! as Map<String, dynamic>;
                DateMessage _message = DateMessage.fromJSON(_messageData);
                _messages.add(_message);
              }
              //Return Chat Instance
              return DateChat(
                uid: _d.id,
                userId: _auth.user.uid,
                contacts: _contacts,
                messages: _messages,
                isTyping: _chatData["isTyping"],
                isGroup: _chatData["isGroup"],
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error getting data.");
        print(e);
      }
    }
  }
}
