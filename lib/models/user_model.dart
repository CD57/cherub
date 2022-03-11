// user_model.dart - Model class containing the details of a user, such as their name and phone number

class UserModel {
  final String uid;
  final String name;
  final String number;
  final String email;
  late String imageURL;
  late DateTime lastActive;

  UserModel({
    required this.uid,
    required this.name,
    required this.number,
    required this.email,
    required this.imageURL,
    required this.lastActive,
  });

  factory UserModel.fromJSON(Map<String, dynamic> _json) {
    return UserModel(
      uid: _json["uid"],
      name: _json["name"],
      number: _json["number"],
      email: _json["email"],
      imageURL: _json["imageURL"],
      lastActive: _json["lastActive"].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
}
