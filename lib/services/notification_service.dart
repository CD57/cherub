import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';

class NotificationService {
  setToken(String uid) async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      if (kDebugMode) {
        print('token: $token');
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({'pushToken': token});
    }).catchError((err) {});
  }
}
