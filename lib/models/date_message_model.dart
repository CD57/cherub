// date_message_model.dart - Model class containing the details of a users message, which can be either text or media

import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageContentType {
  text,
  media,
  unknown,
}

class DateMessage {
  final String senderID;
  final MessageContentType type;
  final String content;
  final DateTime sentTime;

  DateMessage(
      {required this.content,
      required this.type,
      required this.senderID,
      required this.sentTime});

  factory DateMessage.fromJSON(Map<String, dynamic> _json) {
    MessageContentType _contentType;
    switch (_json["type"]) {
      case "text":
        _contentType = MessageContentType.text;
        break;
      case "media":
        _contentType = MessageContentType.media;
        break;
      default:
        _contentType = MessageContentType.unknown;
    }
    return DateMessage(
      content: _json["content"],
      type: _contentType,
      senderID: _json["senderId"],
      sentTime: _json["sentTime"].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    String _contentType;
    switch (type) {
      case MessageContentType.text:
        _contentType = "text";
        break;
      case MessageContentType.media:
        _contentType = "media";
        break;
      default:
        _contentType = "";
    }
    return {
      "content": content,
      "type": _contentType,
      "senderId": senderID,
      "sentTime": Timestamp.fromDate(sentTime),
    };
  }
}
