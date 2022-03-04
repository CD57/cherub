import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  String? getRoute() {
    return ModalRoute.of(navKey.currentState!.context)?.settings.name!;
  }

  void goToPage(Widget _page) {
    navKey.currentState?.push(
      MaterialPageRoute(
        builder: (BuildContext _context) {
          return _page;
        },
      ),
    );
  }

  void goToRoute(String _route) {
    navKey.currentState?.pushNamed(_route);
  }

  void removeAndGoToRoute(String _route) {
    navKey.currentState?.popAndPushNamed(_route);
  }

  void goBack() {
    navKey.currentState?.pop();
  }
}
