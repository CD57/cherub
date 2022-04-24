// custom_status_notification_widget.dart - Custom widget for status notifications, with indicators for showing active users

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as time_ago;
import '../models/date_message_model.dart';

class TextNotification extends StatelessWidget {
  final bool isOwnMessage;
  final DateMessage message;
  final double height;
  final double width;

  const TextNotification(
      {Key? key,
      required this.isOwnMessage,
      required this.message,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? [
            const Color.fromARGB(167, 0, 249, 12),
            const Color.fromARGB(174, 25, 218, 0)
          ]
        : [
            const Color.fromARGB(255, 43, 126, 69),
            const Color.fromARGB(255, 43, 126, 69),
          ];
    return Container(
      height: height + (message.content.length / 20 * 6.0),
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: const [0.30, 0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          Text(
            time_ago.format(message.sentTime),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageNotification extends StatelessWidget {
  final bool isOwnMessage;
  final DateMessage message;
  final double height;
  final double width;

  const ImageNotification(
      {Key? key,
      required this.isOwnMessage,
      required this.message,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? [
            const Color.fromARGB(167, 0, 249, 12),
            const Color.fromARGB(174, 25, 218, 0)
          ]
        : [
            const Color.fromARGB(255, 49, 68, 53),
            const Color.fromARGB(255, 49, 68, 55),
          ];
    DecorationImage _image = DecorationImage(
      image: NetworkImage(message.content),
      fit: BoxFit.cover,
    );
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: const [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: _image,
            ),
          ),
          SizedBox(height: height * 0.02),
          Text(
            time_ago.format(message.sentTime),
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
