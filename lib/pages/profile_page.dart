// profile_page.dart - App page containing users profile details, done through firebase auth account details

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("ProfilePage.dart - build()");
    }
    return const ProfileScreen(
      providerConfigs: [
        EmailProviderConfiguration(),
        PhoneProviderConfiguration(),
      ],
      avatarSize: 100,
    );
  }
}
