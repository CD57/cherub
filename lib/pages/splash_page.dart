// splash_page.dart - App page containing splash screen with initializing app services
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cherub/services/location_service.dart';
import 'package:cherub/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get_it/get_it.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({
    required Key key,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then(
      (_) {
        _setup().then(
          (_) => widget.onInitializationComplete(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("splash_page.dart - build - begin");
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cherub',
      theme: ThemeData(
        backgroundColor: const Color.fromRGBO(163, 235, 177, 1.0),
        scaffoldBackgroundColor: const Color.fromRGBO(163, 235, 177, 1.0),
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/Cherub-PNG-NoBack.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterFireUIAuth.configureProviders([
      const EmailProviderConfiguration(),
      const PhoneProviderConfiguration(),
    ]);
    _registerServices();
    _initAwesomeNotifications();
    if (kDebugMode) {
      print("Service Set Up Complete");
    }
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationService>(
      NavigationService(),
    );
    if (kDebugMode) {
      print("NavigationService Ready");
    }
    GetIt.instance.registerSingleton<MediaService>(
      MediaService(),
    );
    if (kDebugMode) {
      print("MediaService Ready");
    }
    GetIt.instance.registerSingleton<StorageService>(
      StorageService(),
    );
    if (kDebugMode) {
      print("StorageService Ready");
    }
    GetIt.instance.registerSingleton<DatabaseService>(
      DatabaseService(),
    );
    if (kDebugMode) {
      print("DatabaseService Ready");
    }
    GetIt.instance.registerSingleton<LocationService>(
      LocationService(),
    );
    if (kDebugMode) {
      print("LocationService Ready");
    }
    GetIt.instance.registerSingleton<NotificationService>(
      NotificationService(),
    );
    if (kDebugMode) {
      print("NotificationService Ready");
    }
  }

  void _initAwesomeNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
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
          print("home_page.dart - notifications allowed");
        }
      }
    });

    AwesomeNotifications().createdStream.listen((notification) {});

    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }
    });
  }
}
