// database_service.dart - Service to manage database connection and actions

import 'package:cherub/services/databases_options.dart/chat_database.dart';
import 'package:cherub/services/databases_options.dart/date_database.dart';
import 'package:cherub/services/databases_options.dart/friend_database.dart';
import 'package:cherub/services/databases_options.dart/session_database.dart';
import 'package:cherub/services/databases_options.dart/user_database.dart';

class DatabaseService {
  UserDatabase userDb = UserDatabase();
  ChatDatabase chatDb = ChatDatabase();
  FriendDatabase friendDb = FriendDatabase();
  DateDatabase dateDb = DateDatabase();
  SessionDatabase sessionDb = SessionDatabase();
}
