// home_page.dart - App page containing main menu of app, containing a scaffold of displaying other app pages

import 'package:cherub/pages/date_activities/dates_menu_page.dart';
import 'package:cherub/pages/users_activities/user_profile_page.dart';
import 'package:cherub/pages/users_activities/user_search_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import 'chat_activities/dates_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late AuthProvider _auth;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    if (kDebugMode) {
      print("home_page.dart - build");
    }
    return _buildUI();
  }

  Widget _buildUI() {
    UserModel currentUser = _auth.user;
    late final List<Widget> _pages = [
      const DatesMenuPage(),
      const DatesPage(),
      const UserSearchPage(),
      UserProfilePage(aUser: currentUser)
    ];
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorScheme.fromSwatch().onPrimary,
        currentIndex: _currentPage,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Create Date",
            icon: Icon(
              Icons.date_range,
            ),
          ),
          BottomNavigationBarItem(
            label: "Dates",
            icon: Icon(
              Icons.chat_bubble_sharp,
            ),
          ),
          BottomNavigationBarItem(
            label: "Contacts",
            icon: Icon(
              Icons.supervised_user_circle_sharp,
            ),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.account_circle_sharp),
          ),
        ],
      ),
    );
  }
}
