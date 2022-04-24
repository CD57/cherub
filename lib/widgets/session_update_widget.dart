//csession_update_widget.dart

import 'package:cherub/models/location_data_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as time_ago;

class SessionUpdate extends StatelessWidget {
  final LocationData location;
  final double height;
  final double width;

  const SessionUpdate(
      {Key? key,
      required this.location,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = [
      const Color.fromARGB(255, 14, 161, 1),
      const Color.fromARGB(255, 42, 100, 0)
    ];

    return Container(
      height: height + (location.gpsLocation.length / 20 * 6.0),
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
            location.gpsLocation,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17.5,
            ),
          ),
          Text(
            time_ago.format(location.timeOfUpdate),
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}