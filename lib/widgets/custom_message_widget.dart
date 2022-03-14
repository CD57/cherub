import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as time_ago;
import '../models/date_message_model.dart';

class MessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final DateMessage message;
  final double height;
  final double width;

  const MessageBubble(
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
            const Color.fromARGB(255, 14, 161, 1),
            const Color.fromARGB(255, 42, 100, 0)
          ]
        : [
            const Color.fromRGBO(51, 49, 68, 1.0),
            const Color.fromRGBO(51, 49, 68, 1.0),
          ];
    return Container(
      height: height + (message.content.length / 20 * 6.0),
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17.5,
            ),
          ),
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

class MediaBubble extends StatelessWidget {
  final bool isOwnMessage;
  final DateMessage message;
  final double height;
  final double width;

  const MediaBubble(
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
            const Color.fromARGB(255, 42, 100, 0),
            const Color.fromARGB(255, 14, 161, 1),
          ]
        : [
            const Color.fromRGBO(51, 49, 68, 1.0),
            const Color.fromRGBO(51, 49, 68, 1.0),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: _image,
            ),
          ),
          SizedBox(height: height * 0.03),
          Text(
            time_ago.format(message.sentTime),
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}