// user_model.dart - Model class containing the details of a user, such as their name and phone number
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String username;
  final String name;
  final String number;
  final String email;
  late String imageURL;
  late DateTime lastActive;

  UserModel({
    required this.userId,
    required this. username,
    required this.name,
    required this.number,
    required this.email,
    required this.imageURL,
    required this.lastActive,
  });

  factory UserModel.fromJSON(Map<String, dynamic> _json) {
    return UserModel(
      userId: _json["userId"],
      username: _json["username"],
      name: _json["name"],
      number: _json["number"],
      email: _json["email"],
      imageURL: _json["imageURL"],
      lastActive: _json["lastActive"].toDate(),
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot _doc) {
    return UserModel(
      userId: _doc["userId"],
      username: _doc["username"],
      name: _doc["name"],
      number: _doc["number"],
      email: _doc["email"],
      imageURL: _doc["imageURL"],
      lastActive: _doc["lastActive"].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "username": username,
      "name": name,
      "number": number,
      "email": email,
      "image": imageURL,
      "lastActive": lastActive,
    };
  }

  String lastDayActive() {
    return "${lastActive.day}/${lastActive.month}/${lastActive.year}";
  }

  String lastSeenActive() {
    return "${lastActive.hour}/${lastActive.minute}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inMinutes < 15;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.userId == userId &&
      other.username == username &&
      other.name == name &&
      other.number == number &&
      other.email == email &&
      other.imageURL == imageURL &&
      other.lastActive == lastActive;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      username.hashCode ^
      name.hashCode ^
      number.hashCode ^
      email.hashCode ^
      imageURL.hashCode ^
      lastActive.hashCode;
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, username: $username, name: $name, number: $number, email: $email, imageURL: $imageURL, lastActive: $lastActive)';
  }
}
