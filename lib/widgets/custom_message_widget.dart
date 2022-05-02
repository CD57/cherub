//custom_message_widget.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            const Color.fromARGB(255, 32, 75, 34),
            const Color.fromARGB(255, 69, 192, 75),
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
  final DateMessage media;
  final double height;
  final double width;

  const MediaBubble(
      {Key? key,
      required this.isOwnMessage,
      required this.media,
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
            const Color.fromARGB(255, 32, 75, 34),
            const Color.fromARGB(255, 69, 192, 75),
          ];
    DecorationImage _image = DecorationImage(
      image: NetworkImage(media.content),
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
            time_ago.format(media.sentTime),
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

class UpdateBubble extends StatelessWidget {
  final bool isOwnMessage;
  final DateMessage update;
  final double height;
  final double width;

  const UpdateBubble(
      {Key? key,
      required this.isOwnMessage,
      required this.update,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> latLng = update.content.split(",");
    double latitude = double.parse(latLng[0]);
    double longitude = double.parse(latLng[1]);
    LatLng _location = LatLng(latitude, longitude);

    List<Color> _colorScheme = isOwnMessage
        ? [
            const Color.fromARGB(255, 14, 161, 1),
            const Color.fromARGB(255, 42, 100, 0)
          ]
        : [
            const Color.fromARGB(255, 32, 75, 34),
            const Color.fromARGB(255, 69, 192, 75),
          ];

    late Map<String, Marker> _markers = {};
    final marker = Marker(
      markerId: MarkerId(update.content),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: "Date Location",
        snippet: update.content,
      ),
    );
    _markers[update.content] = marker;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
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
          SizedBox(
            width: 300.0,
            height: 300.0,
            child: GoogleMap(
              scrollGesturesEnabled: false,
              zoomControlsEnabled: true,
              //onMapCreated: _onMapCreated,
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: _location,
                zoom: 25.0,
              ),
              markers: _markers.values.toSet(),
            ),
          ),
          SizedBox(height: height * 0.03),
          Text(
            time_ago.format(update.sentTime),
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
