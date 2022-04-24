import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:cherub/models/date_details_model.dart';

import '../providers/auth_provider.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../widgets/date_details_widget.dart';
import '../widgets/top_bar_widget.dart';

DatabaseService _dbService = GetIt.instance.get<DatabaseService>();

class DisplayDatesPage extends StatefulWidget {
  final bool pastDates;
  const DisplayDatesPage({
    Key? key,
    required this.pastDates,
  }) : super(key: key);

  @override
  State<DisplayDatesPage> createState() => _DisplayDatesPageState();
}

class _DisplayDatesPageState extends State<DisplayDatesPage> {
  late CollectionReference dateDetailsRef;
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthProvider _auth;
  late NavigationService _nav;
  late String _uid;
  late bool _pastDates;

  @override
  void initState() {
    if (kDebugMode) {
      print("user_search_page.dart - initState()");
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (kDebugMode) {
      print("user_search_page.dart - didChangeDependencies()");
    }
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
    _nav = GetIt.instance.get<NavigationService>();

    setState(() {
      _uid = _auth.user.userId;
      _pastDates = widget.pastDates;
      dateDetailsRef = FirebaseFirestore.instance
          .collection('Dates')
          .doc(_uid)
          .collection("DateDetails");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("view_dates_page.dart - build");
    }
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(body: _buildDateDetailsList());
  }

  Widget _buildDateDetailsList() {
    return Material(child: Builder(
      builder: (BuildContext _context) {
        return Container(
          color: Theme.of(context).backgroundColor,
          padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Dates',
                primaryAction: IconButton(
                  icon: const Icon(
                    Icons.keyboard_return_rounded,
                    color: Color.fromARGB(255, 20, 133, 43),
                  ),
                  onPressed: () {
                    _nav.goBack();
                  },
                ),
                secondaryAction: IconButton(
                  icon: const Icon(
                    Icons.refresh_sharp,
                    color: Color.fromARGB(255, 20, 133, 43),
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ),
              _datesList(context),
            ],
          ),
        );
      },
    ));
  }

  _datesList(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: dateDetailsRef.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && snapshot.data == null) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<DateDetailsListWidget> dateDetailsList = [];

          for (var doc in (snapshot.data!).docs) {
            DateDetailsModel aDate = DateDetailsModel.fromDocument(doc);
            DateDetailsListWidget aDateDetailsWidget =
                DateDetailsListWidget(aDate, _dbService, _uid);

            if (_pastDates) {
              // If looking for past dates, only add current time is greater than date's time
              if (DateTime.now().millisecondsSinceEpoch >
                  aDate.checkInTime.millisecondsSinceEpoch) {
                dateDetailsList.add(aDateDetailsWidget);
              }
            } else {
              // If looking for future dates, only add current time is less than date's time
              if (DateTime.now().millisecondsSinceEpoch <
                  aDate.checkInTime.millisecondsSinceEpoch) {
                dateDetailsList.add(aDateDetailsWidget);
              }
            }
          }

          if (kDebugMode) {
            print("view_dates_page.dart - _datesList() - Returning List View");
          }

          if (dateDetailsList.isEmpty) {
            return Center(
              child: Text(
                "No Dates Available",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 45.0,
                ),
              ),
            );
          } else {
            return Flexible(
              child: ListView(
                children: dateDetailsList,
              ),
            );
          }
        }
        return Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(
                "Loading...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 40.0,
                ),
              ),
              const CircularProgressIndicator()
            ],
          ),
        );
      },
    );
  }
}
