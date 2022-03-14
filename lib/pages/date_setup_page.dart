// date_setup_page.dart - App page containing forms for user to enter details of date
import 'package:cherub/pages/contacts_page.dart';
import 'package:cherub/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/contacts_provider.dart';
import '../services/database_service.dart';
import '../widgets/custom_tile_list_widget.dart';
import '../widgets/top_bar_widget.dart';
import '../widgets/user_input_widget.dart';
import '../widgets/custom_button_widget.dart';

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
  late NavigationService _nav;
  late DatabaseService _dbService;
  late ContactsProvider _contactsProvider;
  final TextEditingController _searchController = TextEditingController();

  bool searchBool = false;

  String _datePlan = "None";
  String dayOfDateText = "None Selected";
  String dateTimeText = "None Selected";
  String checkInTimeText = "None Selected";
  late DateTime? _dayOfDate;
  late TimeOfDay? _dateTime;
  late TimeOfDay? _checkInTime;
  //late LatLng _dateGPS;

  final _dateDetailsFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("date_setup_page.dart - build");
    }
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _dbService = GetIt.instance.get<DatabaseService>();
    _nav = GetIt.instance.get<NavigationService>();
    _auth = Provider.of<AuthProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContactsProvider>(
          create: (_) => ContactsProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _contactsProvider = _context.watch<ContactsProvider>();
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
                  _dayOfDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2032, 12),
                    helpText: 'Select a day for your date',
                  );
                  setState(() {
                    _dayOfDate = _dayOfDate;
                    dayOfDateText = _dayOfDate!.day.toString() +
                        "/" +
                        _dayOfDate!.month.toString() +
                        "/" +
                        _dayOfDate!.year.toString();
                  });
                }),
            AutoSizeText(
              "Day of Date: " + dayOfDateText,
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
                  _dateTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  setState(() {
                    _dateTime = _dateTime;
                    dateTimeText = _dateTime!.hour.toString() +
                        ":" +
                        _dateTime!.minute.toString();
                  });
                }),
            AutoSizeText(
              "Date Time: " + dateTimeText.toString(),
              style: const TextStyle(fontSize: 15),
              maxLines: 2,
            ),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            CustomButton(
                name: "Choose a Check-in Time",
                height: _deviceHeight * 0.065,
                width: _deviceWidth * 0.7,
                onPressed: () async {
                  _checkInTime = await showTimePicker(
                    context: context,
                    helpText: "Check-In Time",
                    initialTime: TimeOfDay.now(),
                  );
                  setState(() {
                    _checkInTime = _checkInTime;
                    checkInTimeText = _checkInTime!.hour.toString() +
                        ":" +
                        _checkInTime!.minute.toString();
                  });
                }),
            AutoSizeText(
              "Date Time: " + checkInTimeText,
              style: const TextStyle(fontSize: 15),
              maxLines: 2,
            ),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            // CustomButton(
            //     name: "Pick a Location",
            //     height: _deviceHeight * 0.065,
            //     width: _deviceWidth * 0.65,
            //     onPressed: () async {
            //       // TO IMPLEMENT GOOGLE MAP PAGE
            //     }),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _nextButton() {
    return Builder(
      builder: (context) {
        return CustomButton(
          name: "Confirm and Select Contacts",
          height: _deviceHeight * 0.065,
          width: _deviceWidth * 0.8,
          onPressed: () async {
            _dateDetailsFormKey.currentState!.save();
            try {
              //Create Date Details
              await _dbService.createDateDetails({
                "hostID": _auth.user.uid,
                "datePlan": _datePlan,
                "dateDay": _dayOfDate,
                "dateTime": dateTimeText,
                "checkInTime": checkInTimeText,
                //"dateGPS": dateGPS,
              });
              if (kDebugMode) {
                print("date_setup_page.dart - createDate() - Date Details Created");
              }
              _nav.goToPage(const ContactsPage());
            } catch (e) {
              if (kDebugMode) {
                print("contacts_provider.dart - createDate() - Error");
                print(e);
              }
            }
          },
        );
      }
    );
  }
}
