// date_chat_provider.dart - Provider for the date chats, sending and retrieving relevant message data 

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';
import '../providers/auth_provider.dart';
import '../models/date_message_model.dart';

class DateChatProvider extends ChangeNotifier {
  late DatabaseService _db;
  late StorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  final AuthProvider _auth;
  final ScrollController _messagesListViewController;

  final String _chatId;
  List<DateMessage>? messages;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  String? _message;

  String get message {
    // ignore: recursive_getters
    return message;
  }

  set message(String _value) {
    _message = _value;
  }

  DateChatProvider(this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<StorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.chatDb.streamMessages(_chatId).listen(
        (_snapshot) {
          List<DateMessage> _messages = _snapshot.docs.map(
            (_m) {
              Map<String, dynamic> _messageData =
                  _m.data() as Map<String, dynamic>;
              return DateMessage.fromJSON(_messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) {
              if (_messagesListViewController.hasClients) {
                _messagesListViewController.jumpTo(
                    _messagesListViewController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("date_chat_provider.dart - listenToMessages() - Error getting messages.");
        print(e);
      }
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen(
      (_event) {
        _db.chatDb.updateDateChat(_chatId, {"isTyping": _event});
      },
    );
    if (kDebugMode) {
      print("date_chat_provider.dart - listenToKeyboardChanges(): " +
          _keyboardVisibilityStream.toString());
    }
  }

  Future<void> sendTextMessage() async {
    if (_message != null) {
      DateMessage _messageToSend = DateMessage(
        content: _message!,
        type: MessageContentType.text,
        senderID: _auth.user.userId,
        sentTime: DateTime.now(),
      );
      await _db.chatDb.addMessage(_chatId, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      XFile? _file = await _media.getImageFromGallery();
      if (_file != null) {
        String? _downloadURL =
            await _storage.saveMedia(_chatId, _auth.user.userId, _file);
        DateMessage _messageToSend = DateMessage(
          content: _downloadURL!,
          type: MessageContentType.media,
          senderID: _auth.user.userId,
          sentTime: DateTime.now(),
        );
        _db.chatDb.addMessage(_chatId, _messageToSend);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error sending image message.");
        print(e);
      }
    }
  }

  void deleteChat() {
    goBack();
    _db.chatDb.deleteDateChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}
