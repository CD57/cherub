//Displays and holds user search results
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherub/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_button_widget.dart';

class UserSearchResult extends StatelessWidget {
  final UserModel user;
  const UserSearchResult(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => contactOptions(),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.imageURL),
              ),
              title: Text(
                user.username,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.email,
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

  contactOptions() {

  }
}
