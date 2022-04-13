import 'package:cherub/models/date_details_model.dart';
import 'package:cherub/widgets/top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/navigation_service.dart';

late double _deviceHeight;
late double _deviceWidth;

class DateDetailsPage extends StatelessWidget {
  final DateDetailsModel aDate;
  const DateDetailsPage({Key? key, required this.aDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late NavigationService _nav = GetIt.instance.get<NavigationService>();
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
              'Date Details',
              primaryAction: IconButton(
                icon: const Icon(
                  Icons.keyboard_return_rounded,
                  color: Color.fromARGB(255, 20, 133, 43),
                ),
                onPressed: () {
                  _nav.goBack();
                },
              ),
            ),
            Text(aDate.hostID),
            Text(aDate.datePlan),
            Text(aDate.dateGPS),
            Text(aDate.dayOfDate.toString()),
            Text(aDate.dateTime.toString()),
            Text(aDate.checkInTime.toString()),
          ],
        ),
      ),
    );
  }
}
