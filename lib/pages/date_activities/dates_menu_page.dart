// create_date_page.dart - App page containing option to set up a new date

import 'package:cherub/pages/date_activities/date_setup_page.dart';
import 'package:cherub/pages/date_activities/view_dates_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/navigation_service.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/top_bar_widget.dart';

class DatesMenuPage extends StatefulWidget {
  const DatesMenuPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DatesMenuState();
}

class _DatesMenuState extends State<DatesMenuPage> {
  late final AuthProvider _auth =
      Provider.of<AuthProvider>(context, listen: false);
  late NavigationService _nav;
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("dates_menu_page.dart - build()");
    }
    _nav = GetIt.instance.get<NavigationService>();
    return _buildUI();
  }

  Widget _buildUI() {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Dates Menu',
              primaryAction: IconButton(
                icon: const Icon(
                  Icons.logout_sharp,
                  color: Color.fromARGB(255, 20, 133, 43),
                ),
                onPressed: () {
                  _auth.logout();
                },
              ),
            ),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _createADateButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            _viewFutureDatesButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            _viewPastDatesButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _createADateButton() {
    return Builder(builder: (context) {
      return CustomButton(
          name: "Create a Date",
          height: _deviceHeight * 0.065,
          width: _deviceWidth * 0.8,
          onPressed: () {
            _nav.goToPage(const DateSetupPage(dateID: "None"));
          });
    });
  }

  Widget _viewFutureDatesButton() {
    return Builder(builder: (context) {
      return CustomButton(
          name: "Upcoming Dates",
          height: _deviceHeight * 0.065,
          width: _deviceWidth * 0.8,
          onPressed: () {
            _nav.goToPage(const DisplayDatesPage(pastDates: false));
          });
    });
  }

  Widget _viewPastDatesButton() {
    return Builder(builder: (context) {
      return CustomButton(
          name: "Past Dates",
          height: _deviceHeight * 0.065,
          width: _deviceWidth * 0.8,
          onPressed: () {
            _nav.goToPage(const DisplayDatesPage(pastDates: true));
          });
    });
  }
}
