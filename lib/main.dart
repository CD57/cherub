// main.dart - Cherub Application - C18465384

import 'package:cherub/pages/users_activities/account_options_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/login_and_registration/splash_page.dart';
import 'pages/login_and_registration/login_page.dart';
import 'pages/login_and_registration/registration_page.dart';
import 'providers/auth_provider.dart';
import 'services/navigation_service.dart';

void main() {
  notificationInit();
  runApp(
    SplashPage(
        key: UniqueKey(),
        onInitializationComplete: () {
          if (kDebugMode) {
            print("main.dart - SplashPage - onInitializationComplete");
          }
          runApp(
            const MainApp(),
          );
        }),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("main.dart - build");
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      if (kDebugMode) {
        print("main.dart - New Token Created - " + fcmToken.toString());
      }
    }).onError((err) {
      if (kDebugMode) {
        print("main.dart - Messaging Token Error - " + err.toString());
      }
    });
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    //Multiprovider allows access to providers to all widgets within MaterialApp
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (BuildContext _context) {
            return AuthProvider();
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cherub',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromARGB(255, 20, 133, 43),
              secondary: const Color.fromRGBO(163, 235, 177, 1.0)),
          primaryColor: Colors.green[900],
          backgroundColor: const Color.fromRGBO(163, 235, 177, 1.0),
          scaffoldBackgroundColor: const Color.fromRGBO(163, 235, 177, 1.0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 20, 133, 43),
          ),
        ),
        navigatorKey: NavigationService.navKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext _context) => const LoginPage(),
          '/registration': (BuildContext _context) => const RegistrationPage(),
          '/home': (BuildContext _context) => const HomePage(),
          '/accountOptions': (BuildContext _context) => const AccountOptionsPage(),
        },
      ),
    );
  }
}

void notificationInit() async {
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            channelShowBadge: true,
            importance: NotificationImportance.High,
            defaultColor: const Color.fromARGB(255, 20, 133, 43),
            ledColor: Colors.white),
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Notification channel for scheduled tests',
          channelShowBadge: true,
          defaultColor: const Color.fromARGB(255, 91, 189, 25),
          locked: true,
          importance: NotificationImportance.High,
        ),
      ],
      debug: true);
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(
        "main.dart - firebaseMessagingBackgroundHandler - Handling a background message");
  }
}
