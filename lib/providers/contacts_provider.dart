// contacts_provider.dart - Provider for the apps contacts managment

import 'package:cherub/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import '../models/date_chat_model.dart';
import '../pages/chat_activities/date_chat_page.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import 'auth_provider.dart';

class ContactsProvider extends ChangeNotifier {
  final AuthProvider _auth;
  late DatabaseService _database;
  late NavigationService _navigation;

  UserModel? user;
  List<UserModel>? users;
  late UserModel _selectedUser;
  late List<UserModel> _selectedUsers;
  late String recentDateId;

  List<UserModel> get selectedUsers {
    return _selectedUsers;
  }

  ContactsProvider(this._auth) {
    _selectedUsers = [];
    _database = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  void createAndGoToChat() async {
    if (kDebugMode) {
      print("contacts_provider.dart - createAndGoToChat()");
    }
    try {
      //Create Chat
      List<String> _contactsIds =
          _selectedUsers.map((_user) => _user.userId).toList();
      _contactsIds.add(_auth.user.userId);
      bool _isGroup = _selectedUsers.length > 1;
      DocumentReference? _doc = await _database.chatDb.createDateChat(
        {
          "hostId": _auth.user.userId,
          "dateId": recentDateId,
          "isGroup": _isGroup,
          "isTyping": false,
          "contacts": _contactsIds,
        },
      );
      //Navigate To Chat Page
      List<UserModel> _contacts = [];
      for (var _uid in _contactsIds) {
        DocumentSnapshot _userSnapshot =
            await _database.userDb.getUserByID(_uid);
        Map<String, dynamic> _userData =
            _userSnapshot.data() as Map<String, dynamic>;
        _userData["userId"] = _userSnapshot.id;
        _contacts.add(
          UserModel.fromJSON(
            _userData,
          ),
        );
      }
      DateChatPage _dateChatPage = DateChatPage(
        dateChat: DateChat(
            uid: _doc!.id,
            dateId: recentDateId,
            hostId: _auth.user.userId,
            currrentUserId: _auth.user.userId,
            contacts: _contacts,
            messages: [],
            isTyping: false,
            isGroup: _isGroup),
      );
      _selectedUsers = [];
      recentDateId = "";
      notifyListeners();
      _navigation.removeAndGoToPage(_dateChatPage);
    } catch (e) {
      if (kDebugMode) {
        print("contacts_provider.dart - createChat() - Error");
        print(e);
      }
    }
  }


  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      _database.userDb.getAllUsers(name: name).then(
        (_snapshot) {
          users = _snapshot.docs.map(
            (_doc) {
              Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
              _data["userId"] = _doc.id;
              return UserModel.fromJSON(_data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("contacts_provider.dart - getUsers() - Error");
        print(e);
      }
    }
  }

  void getUser({String? uid}) async {
    try {
      _database.userDb.getUserByID(uid!).then(
        (_snapshot) {
          if (_snapshot.data() != null) {
            Map<String, dynamic> _userData =
                _snapshot.data()! as Map<String, dynamic>;
            user = UserModel.fromJSON(
              {
                "userId": _userData["userId"],
                "name": _userData["name"],
                "number": _userData["number"],
                "email": _userData["email"],
                "lastActive": _userData["lastActive"],
                "imageURL": _userData["imageURL"],
              },
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("contacts_provider.dart - getUsers() - Error");
        print(e);
      }
    }
  }

  void updateSelectedUser(UserModel _user) {
    if (!(_selectedUser == _user)) {
      _selectedUser = _user;
    }
    notifyListeners();
  }

  void updateSelectedUsers(UserModel _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }

  
  void createChatWithId(String contactId) async {
    if (kDebugMode) {
      print("contacts_provider.dart - createChat()");
    }
    try {
      //Create Chat
      List<String> _contactsIds = [];
      _contactsIds.add(contactId);
      _contactsIds.add(_auth.user.userId);
      bool _isGroup = false;
      await _database.chatDb.createDateChat(
        {
          "isGroup": _isGroup,
          "isTyping": false,
          "contacts": _contactsIds,
        },
      );
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("contacts_provider.dart - createChat() - Error");
        print(e);
      }
    }
  }

  bool _mounted = true;
  bool get mounted => _mounted;

  @override
  void dispose() {
    super.dispose();
    _mounted = false;
  }
}
