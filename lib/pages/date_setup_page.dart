// date_setup_page.dart - App page containing forms for user to enter details of date

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/user_input_widget.dart';
import '../widgets/custom_button_widget.dart';
import '../providers/auth_provider.dart';
import '../services/database_service.dart';

class DateSetupPage extends StatefulWidget {
  const DateSetupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DateSetupPageState();
  }
}

class _DateSetupPageState extends State<DateSetupPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthProvider _auth;
  late DatabaseService _db;

  late String _dateUid;
  late String _datePlan;
  late String _dateType;
  late TimeOfDay? _dateTime;
  late TimeOfDay? _checkpointTime;
  late DateTime? _dateOfDate;
  late LatLng _dateGPS;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("date_setup_page.dart - build");
    }
    _auth = Provider.of<AuthProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _dateDetailsForm(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _confirmButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateDetailsForm() {
    return SizedBox(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserInputForm(
                onSaved: (_value) {
                  setState(() {
                    _datePlan = _value;
                  });
                },
                regex: r'.{10,}',
                hint: "Let your contacts know, what's the plan for this date?",
                hidden: false),
            CustomButton(
                name: "Select a Date",
                height: _deviceHeight * 0.065,
                width: _deviceWidth * 0.65,
                onPressed: () async {
                  _dateOfDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2032, 12),
                    helpText: 'Select a date',
                  );
                }),
            CustomButton(
                name: "Choose a Time",
                height: _deviceHeight * 0.065,
                width: _deviceWidth * 0.65,
                onPressed: () async {
                  _dateTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                }),
            CustomButton(
                name: "Choose a Check-in Time",
                height: _deviceHeight * 0.065,
                width: _deviceWidth * 0.65,
                onPressed: () async {
                  _checkpointTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                }),
            CustomButton(
                name: "Pick a Location",
                height: _deviceHeight * 0.065,
                width: _deviceWidth * 0.65,
                onPressed: () async {
                  // TO IMPLEMENT GOOGLE MAP PAGE
                }),
          ],
        ),
      ),
    );
  }

  Widget _confirmButton() {
    return CustomButton(
      name: "Confirm",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate()) {
          _registerFormKey.currentState!.save();
          if (kDebugMode) {
            print("Time of Date: " + _dateTime.toString());
          }

          // TO DO: IMPLEMENT SAVING OF DATE DETAILS TO DATABASE

        } else {
          if (kDebugMode) {
            print("date_setup_page.dart - _confirmutton - onPressed: Error");
          }
        }
      },
    );
  }
}
