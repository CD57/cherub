// custom_tile_list_widget.dart - Custom widget for listview of tiles, with date or chat details

import 'package:cherub/widgets/custom_message_widget.dart';
import 'package:cherub/widgets/session_update_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/date_message_model.dart';
import '../models/location_data_model.dart';
import '../models/user_model.dart';
import 'profile_picture_widget.dart';

class CustomTileListView extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isSelected;
  final Function onTap;

  const CustomTileListView({
    Key? key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: isSelected
          ? const Icon(Icons.check, color: Color.fromARGB(255, 20, 221, 2))
          : null,
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      leading: ProfilePictureStatus(
        key: UniqueKey(),
        size: height / 2,
        image: imagePath,
        isActive: isActive,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.green.shade900,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.green.shade900,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class CustomTileListViewWithActivity extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isTyping;
  final Function onTap;

  const CustomTileListViewWithActivity({
    Key? key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isTyping,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      leading: ProfilePictureStatus(
        key: UniqueKey(),
        size: height / 2,
        image: imagePath,
        isActive: isActive,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.green.shade900,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: isTyping
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitThreeBounce(
                  color: Colors.green.shade900,
                  size: height * 0.10,
                ),
              ],
            )
          : Text(
              subtitle,
              style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
    );
  }
}

class CustomTileListViewChat extends StatelessWidget {
  final double deviceWidth;
  final double deviceHeight;
  final bool isOwnMessage;
  final DateMessage message;
  final UserModel sender;

  const CustomTileListViewChat({
    Key? key,
    required this.deviceWidth,
    required this.deviceHeight,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isOwnMessage
              ? ProfilePictureNetwork(
                  key: UniqueKey(),
                  image: sender.imageURL,
                  size: deviceWidth * 0.08)
              : Container(),
          SizedBox(
            width: deviceWidth * 0.05,
          ),
          message.type == MessageContentType.text
              ? MessageBubble(
                  isOwnMessage: isOwnMessage,
                  message: message,
                  height: deviceHeight * 0.06,
                  width: deviceWidth,
                )
              : message.type == MessageContentType.media 
              ? MediaBubble(
                  isOwnMessage: isOwnMessage,
                  media: message,
                  height: deviceHeight * 0.30,
                  width: deviceWidth * 0.55,
                )
              : UpdateBubble(
                  isOwnMessage: isOwnMessage,
                  update: message,
                  height: deviceHeight * 0.30,
                  width: deviceWidth * 0.55,
                )
        ],
      ),
    );
  }
}

class SessionListViewTileUpdates extends StatelessWidget {
  final double deviceWidth;
  final double deviceHeight;
  final LocationData locationUpdate;

  const SessionListViewTileUpdates({
    Key? key,
    required this.deviceWidth,
    required this.deviceHeight,
    required this.locationUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SessionUpdate(
            location: locationUpdate,
            height: deviceHeight * 0.06,
            width: deviceWidth,
          )
        ],
      ),
    );
  }
}

class SessionListViewTile extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final bool isActive;
  final Function onTap;

  const SessionListViewTile({
    Key? key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.green.shade900,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            color: Colors.green.shade900,
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
