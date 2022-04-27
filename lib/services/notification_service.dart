import 'package:cherub/models/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  getPermission(context) async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      } else {
        if (kDebugMode) {
          print("notification_service.dart - notifications allowed");
        }
      }
    });
  }

  setToken(String uid) async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      if (kDebugMode) {
        print('token: $token');
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({'pushToken': token});
    }).catchError((err) {});
  }

  Future<void> createScheduledReminder(DateTime aDate, String _text) async {
    try {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: createUniqueId(),
            channelKey: 'scheduled_channel',
            title: 'Date Reminder ${Emojis.activites_reminder_ribbon}',
            body: _text,
            notificationLayout: NotificationLayout.Default,
            wakeUpScreen: true,
            category: NotificationCategory.Reminder,
            autoDismissible: false,
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'MARK_DONE',
              label: 'Mark Done',
            ),
          ],
          schedule: NotificationCalendar.fromDate(date: aDate));
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Notification Service - Error: " + e.toString());
      }
    }
  }

  Future<void> createBeginNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'Date Started',
        body: 'Youre has started',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  Future<ScheduledReminder?> pickSchedule(
    BuildContext context,
  ) async {
    List<String> days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    TimeOfDay? timeOfDay;
    DateTime now = DateTime.now();
    int? selectedDay;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'I want to be reminded every:',
              textAlign: TextAlign.center,
            ),
            content: Wrap(
              alignment: WrapAlignment.center,
              spacing: 3,
              children: [
                for (int index = 0; index < days.length; index++)
                  ElevatedButton(
                    onPressed: () {
                      selectedDay = index + 1;
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.green.shade900,
                      ),
                    ),
                    child: Text(days[index]),
                  ),
              ],
            ),
          );
        });

    if (selectedDay != null) {
      timeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(
            now.add(
              const Duration(minutes: 1),
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData(
                colorScheme: ColorScheme.light(
                  primary: Colors.green.shade900,
                ),
              ),
              child: child!,
            );
          });

      if (timeOfDay != null) {
        return ScheduledReminder(
            dayOfTheWeek: selectedDay!, timeOfDay: timeOfDay);
      }
    }
    return null;
  }
}
