// main.dart - Cherub Application - C18465384

// ignore: unused_import
import 'package:cherub/pages/chat_activities/contacts_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/login_and_registration/splash_page.dart';
import 'pages/login_and_registration/login_page.dart';
import 'pages/login_and_registration/registration_page.dart';
import 'providers/auth_provider.dart';
import 'services/navigation_service.dart';

void main() {
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
    // Multiprovider allows access to providers to all widgets within MaterialApp
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
        },
      ),
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message");
  }
}
