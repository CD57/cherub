// date_chat_model.dart - Model class containing the details of a users chat, either with their date or with their contacts

import '/models/user_model.dart';
import 'date_message_model.dart';

class DateChat {
  final String uid;
  final String dateId;
  final String hostId;
  final String currrentUserId;
  final bool isTyping;
  final bool isGroup;
  final List<UserModel> contacts;
  List<DateMessage> messages;

  late final List<UserModel> _received;

  DateChat({
    required this.uid,
    required this.dateId,
    required this.hostId,
    required this.currrentUserId,
    required this.contacts,
    required this.messages,
    required this.isTyping,
    required this.isGroup,
  }) {
    _received = contacts.where((_i) => _i.userId != currrentUserId).toList();
  }

  List<UserModel> received() {
    return _received;
  }

  String title() {
    return !isGroup
        ? _received.first.name
        : _received.map((_user) => _user.name).join(", ");
  }

  String imageURL() {
    return !isGroup
        ? _received.first.imageURL
        : "https://firebasestorage.googleapis.com/v0/b/cherub-app.appspot.com/o/images%2Fdefault%2Ficons%2FGroup-Chat-PNG.png?alt=media&token=07dcb141-08d6-41ca-9d44-cc9cdd7f142a";
  }

  @override
  String toString() {
    return 'DateChat(uid: $uid, dateId: $dateId, currrentUserId: $currrentUserId, isTyping: $isTyping, isGroup: $isGroup, contacts: $contacts, messages: $messages, _received: $_received)';
  }
}

class UserLocation {
  late double latitude;
  late double longitude;

  UserLocation({required this.latitude, required this.longitude});
}
