import 'package:flutter/material.dart';

class ScheduledReminder {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  ScheduledReminder({
    required this.dayOfTheWeek,
    required this.timeOfDay,
  });
}