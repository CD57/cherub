// splash_page.dart - App page containing splash screen with initializing app services
import 'package:cherub/services/location_service.dart';
import 'package:cherub/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get_it/get_it.dart';
import '../../services/storage_service.dart';
import '../../services/database_service.dart';
import '../../services/media_service.dart';
import '../../services/navigation_service.dart';

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
}
