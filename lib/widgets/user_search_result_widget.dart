//Displays and holds user search results
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherub/models/user_model.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class UserSearchResultsWidget extends StatelessWidget {
  final UserModel aUser;
  final DatabaseService _dbService;
  final String _currentUserId;
  const UserSearchResultsWidget(this.aUser, this._dbService, this._currentUserId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => contactOptions(context, _dbService, _currentUserId, aUser.userId),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(aUser.imageURL),
              ),
              title: Text(
                aUser.username,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                aUser.email,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }

  void contactOptions(
      BuildContext context, DatabaseService _dbService, String _uid, String _requestedUsersId) {
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
                _dbService.createFriendRequest(_uid, {
                  "requestFrom": _uid,
                  "requestTo": _requestedUsersId
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
