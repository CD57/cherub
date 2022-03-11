// create_date_page.dart - App page containing option to set up a new date

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/navigation_service.dart';

class NewDate extends StatefulWidget {
  const NewDate({Key? key}) : super(key: key);

  @override
  _NewDateState createState() {
    return _NewDateState();
  }
}

class _NewDateState extends State<NewDate> {
  late NavigationService _nav;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("new_date.dart - build()");
    }
    _nav = GetIt.instance.get<NavigationService>();
    return _buildUI();
    
  }

  Widget _buildUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              child: const Text(
                "Set up a date!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              onPressed: () => _nav.goToRoute('/datesetup'),
            ),
          ),
        ),
      ],
    );
  }
}
