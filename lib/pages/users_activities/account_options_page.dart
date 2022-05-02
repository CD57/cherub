import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class AccountOptionsPage extends StatefulWidget {
  const AccountOptionsPage({Key? key}) : super(key: key);

  @override
  State<AccountOptionsPage> createState() => _AccountOptionsPageState();
}

class _AccountOptionsPageState extends State<AccountOptionsPage> {
  late AuthProvider _auth;
  late String currentNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    currentNumber = _auth.authUser.currentUser!.phoneNumber!;
    if (kDebugMode) {
      print("Current Number: " + currentNumber);
    }
    return const ProfileScreen(
      providerConfigs: [
        EmailProviderConfiguration(),
        PhoneProviderConfiguration()
      ],
      avatarSize: 120,
    );
  }

  @override
  void dispose() async {
    super.dispose();
    String? phoneNum = _auth.authUser.currentUser!.phoneNumber;
    if (phoneNum != null && phoneNum != currentNumber && phoneNum != "Not Set") {
      await _auth.updatePhoneNumber(phoneNum);
      if (kDebugMode) {
        print("Number Updated: " + phoneNum);
      }
    }
    else {
      if (kDebugMode) {
        print("No Phone Number Update Needed");
      }
    }
  }
}
