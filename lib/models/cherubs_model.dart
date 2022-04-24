import 'package:cloud_firestore/cloud_firestore.dart';

class CherubModel {
  final List<String> cherubs;

  CherubModel({
    required this.cherubs,
  });

  factory CherubModel.fromSnapshot(DocumentSnapshot snapshot) {
    return CherubModel(cherubs: List.from(snapshot['cherubs']));
  }

  factory CherubModel.fromDocument(DocumentSnapshot _doc) {
    return CherubModel(
      cherubs: _doc["cherubs"],
    );
  }

  factory CherubModel.fromJSON(Map<String, dynamic> _json) {
    return CherubModel(
      cherubs: _json["cherubs"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cherubs": cherubs,
    };
  }
}
