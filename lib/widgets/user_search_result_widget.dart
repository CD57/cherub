//Displays and holds user search results
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherub/models/user_model.dart';
import 'package:cherub/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class UserSearchResultsWidget extends StatelessWidget {
  final UserModel aUser;
  final DatabaseService _dbService;
  final String _currentUserId;
  const UserSearchResultsWidget(
      this.aUser, this._dbService, this._currentUserId,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => contactOptions(
                context, _dbService, _currentUserId, aUser.userId),
            child: userDetailsWidget(aUser.email, aUser),
          ),
          const Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }

  void contactOptions(BuildContext context, DatabaseService _dbService,
      String _uid, String _requestedUsersId) {
    if (kDebugMode) {
      print("user_search_result_widget.dart - contactOptions");
    }
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add User?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (kDebugMode) {
                  print(
                      "contactOptions - Request from $_uid to $_requestedUsersId");
                }
                _dbService.createFriendRequest({
                  "From": _uid.toString(),
                  "To": _requestedUsersId.toString()
                });
                Navigator.pop(context);
              },
              child: const Text('Send Request'),
            ),
          ],
        );
      },
    );
  }
}

class FriendRequestListWidget extends StatelessWidget {
  final UserModel aUser;
  final DatabaseService _dbService;
  final String _currentUserId;
  const FriendRequestListWidget(
      this.aUser, this._dbService, this._currentUserId,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => requestOptions(context, _dbService, _currentUserId),
            child: userDetailsWidget("New Friend Request", aUser),
          ),
          const Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }

  void requestOptions(
      BuildContext context, DatabaseService dbService, String currentUserId) {
    if (kDebugMode) {
      print("user_search_result_widget.dart - contactOptions");
    }
    AuthProvider _auth = Provider.of<AuthProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Accept Friend Request?'),
          actions: [
            TextButton(
              onPressed: () {
                _dbService.deleteFriendRequest(currentUserId, aUser.userId);
                Navigator.pop(context);
              },
              child: const Text('Dismiss Request'),
            ),
            TextButton(
              onPressed: () {
                _dbService.acceptFriendRequest(currentUserId,
                    _auth.user.username, aUser.userId, aUser.username);
                Navigator.pop(context);
              },
              child: const Text('Accept Request'),
            ),
          ],
        );
      },
    );
  }
}

ListTile userDetailsWidget(String subtitle, UserModel aUser) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: Colors.grey,
      backgroundImage: CachedNetworkImageProvider(aUser.imageURL),
    ),
    title: Text(
      aUser.username,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
