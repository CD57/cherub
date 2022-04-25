// date_setup_page.dart - App page containing forms for user to enter details of date
import 'dart:math';

import 'package:cherub/pages/chat_activities/contacts_page.dart';
import 'package:cherub/pages/date_activities/date_map_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cherub/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get_it/get_it.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../services/location_service.dart';
import '../../widgets/top_bar_widget.dart';
import '../../widgets/user_input_widget.dart';
import '../../widgets/custom_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateSetupPage extends StatefulWidget {
  const DateSetupPage({Key? key, required this.dateID}) : super(key: key);
  final String dateID;
  @override
  State<StatefulWidget> createState() {
    return _DateSetupPageState();
  }
}

class _DateSetupPageState extends State<DateSetupPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthProvider _auth;
  late NavigationService _nav;
  late DatabaseService _dbService;
  late LocationService _locationService;

  final String _randomUid = Random().nextInt(1000).toString();
  String _datePlan = "None";
  String _dayOfDateText = "None Selected";
  String _dateTimeText = "None Selected";
  String _checkInTimeText = "None Selected";
  Timestamp _dayOfDateTS = Timestamp.fromDate(DateTime.now());
  Timestamp _dateTimeTS = Timestamp.fromDate(DateTime.now());
  Timestamp _checkinTimeTS = Timestamp.fromDate(DateTime.now());
  DateTime? _dayOfDateDT;
  late String _pickedLocation;
  late LatLng _currentLocation;
  final _dateDetailsFormKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    _dbService = GetIt.instance.get<DatabaseService>();
    _nav = GetIt.instance.get<NavigationService>();
    _locationService = GetIt.instance.get<LocationService>();
    super.didChangeDependencies();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("date_setup_page.dart - build");
    }
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthProvider>(context);
    return _buildUI();
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
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
                'Your Date Details',
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
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              _dateDetailsForm(),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              _nextButton(),
              SizedBox(
                height: _deviceHeight * 0.02,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _dateDetailsForm() {
    if (kDebugMode) {
      print("date_setup_page.dart - _dateDetailsForm");
    }
    return SizedBox(
      height: _deviceHeight * 0.60,
      child: Form(
        key: _dateDetailsFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AutoSizeText(
              "Let your contacts know what your plan is for the date:",
              style: TextStyle(fontSize: 20),
              maxLines: 2,
            ),
            CustomInputForm(
                onSaved: (_value) {
                  setState(() {
                    _datePlan = _value;
                  });
                },
                regex: r'.{10,}',
                hint: "What's the plan?",
                hidden: false),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            CustomButton(
                name: "Select a Date",
                height: _deviceHeight * 0.065,
                width: _deviceWidth * 0.65,
                onPressed: () async {
                  _dayOfDateDT = (await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2032, 12),
                    helpText: 'Select a day for your date',
                  ));
                  setState(() {
                    if (_dayOfDateDT != null) {
                      _dayOfDateText = _dayOfDateDT.toString();
                      _dayOfDateTS = Timestamp.fromDate(_dayOfDateDT!);
                    }
                  });
                }),
            AutoSizeText(
              "Day of Date: " + _dayOfDateText,
              style: const TextStyle(fontSize: 15),
              maxLines: 2,
            ),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            CustomButton(
                name: "Choose a Time",
                height: _deviceHeight * 0.065,
                width: _deviceWidth * 0.65,
                onPressed: () async {
                  TimeOfDay? dateTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  setState(() {
                    if (dateTime != null && _dayOfDateDT != null) {
                      _dateTimeTS = Timestamp.fromDate(DateTime(
                          _dayOfDateDT!.year,
                          _dayOfDateDT!.month,
                          _dayOfDateDT!.day,
                          dateTime.hour,
                          dateTime.minute));
                      _dateTimeText = dateTime.hour.toString() +
                          ":" +
                          dateTime.minute.toString();
                    }
                  });
                }),
            AutoSizeText(
              "Date Time: " + _dateTimeText.toString(),
              style: const TextStyle(fontSize: 15),
              maxLines: 2,
            ),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            CustomButton(
                name: "Choose a Check-In Time",
                height: _deviceHeight * 0.065,
                width: _deviceWidth * 0.7,
                onPressed: () async {
                  TimeOfDay? checkInTime = await showTimePicker(
                    context: context,
                    helpText: "Check-In Time",
                    initialTime: TimeOfDay.now(),
                  );
                  setState(() {
                    if (checkInTime != null && _dayOfDateDT != null) {
                      _checkinTimeTS = Timestamp.fromDate(DateTime(
                          _dayOfDateDT!.year,
                          _dayOfDateDT!.month,
                          _dayOfDateDT!.day,
                          checkInTime.hour,
                          checkInTime.minute));
                      _checkInTimeText = checkInTime.hour.toString() +
                          ":" +
                          checkInTime.minute.toString();
                    }
                  });
                }),
            AutoSizeText(
              "Check-In Time: " + _checkInTimeText,
              style: const TextStyle(fontSize: 15),
              maxLines: 2,
            ),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextButton() {
    return Builder(builder: (context) {
      return CustomButton(
        name: "Confirm and Select Location",
        height: _deviceHeight * 0.065,
        width: _deviceWidth * 0.8,
        onPressed: () async {
          _dateDetailsFormKey.currentState!.save();
          _pickedLocation = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DateMap(currentPosition: _currentLocation)),
          );
          try {
            //Create Date Details
            await _dbService.dateDb
                .createDateDetails(_auth.user.userId, _randomUid, {
              "uid": _randomUid,
              "hostUid": _auth.user.userId,
              "dateUid": widget.dateID,
              "datePlan": _datePlan,
              "dayOfDate": _dayOfDateTS,
              "dateTime": _dateTimeTS,
              "checkInTime": _checkinTimeTS,
              "dateGPS": _pickedLocation,
            });
            if (kDebugMode) {
              print(
                  "date_setup_page.dart - createDate() - Date Details Created");
            }
            _nav.removeAndGoToPage(ContactsPage(dateUid: _randomUid));
          } catch (e) {
            if (kDebugMode) {
              print("contacts_provider.dart - createDate() - Error");
              print(e);
            }
          }
        },
      );
    });
  }

  void getLocation() async {
    LatLng location = await _locationService.getCurrentLocationLatLng();
    setState(() {
      _currentLocation = location;
    });
  }
}
