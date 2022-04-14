import 'package:cherub/models/date_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../providers/auth_provider.dart';
import '../services/navigation_service.dart';
import '../widgets/date_details_widget.dart';
import '../widgets/top_bar_widget.dart';
import 'package:get_it/get_it.dart';

DatabaseService _dbService = GetIt.instance.get<DatabaseService>();

class DisplayDatesPage extends StatefulWidget {
  const DisplayDatesPage({Key? key}) : super(key: key);

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
  late bool datesFound;

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
      dateDetailsRef = FirebaseFirestore.instance
          .collection('Dates')
          .doc(_uid)
          .collection("DateDetails");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("contacts_page.dart - build");
    }
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(body: _buildSearchResults());
  }

  Widget _buildSearchResults() {
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
              ),
              _datesList(context),
            ],
          ),
        );
      },
    ));
  }

  // Display image and text while no users displayed
  Center buildNoContent() {
    if (kDebugMode) {
      print("view_dates_page.dart - buildNoContent()");
    }
    return Center(
      child: Column(
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
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(
                "No Dates Available",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 60.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _datesList(BuildContext context) {
    if (kDebugMode) {
      print("view_dates_page.dart - _datesList()");
    }

    return FutureBuilder<QuerySnapshot>(
      future: dateDetailsRef.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          if (kDebugMode) {
            print("view_dates_page.dart - _datesList() - Something went wrong");
          }
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && snapshot.data == null) {
          if (kDebugMode) {
            print(
                "view_dates_page.dart - _datesList() - Document does not exist");
          }
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (kDebugMode) {
            print("view_dates_page.dart - _datesList() - ConnectionState.done");
          }
          List<DateDetailsWidget> dateDetailsList = [];
          for (var doc in (snapshot.data!).docs) {
            DateDetailsModel aDate = DateDetailsModel.fromDocument(doc);
            DateDetailsWidget aDateDetailsWidget =
                DateDetailsWidget(aDate, _dbService, _uid);
            dateDetailsList.add(aDateDetailsWidget);
            if (kDebugMode) {
              print("view_dates_page.dart - _datesList() - Date Added");
            }
          }

          if (kDebugMode) {
            print("view_dates_page.dart - _datesList() - Returning List View");
          }
          return Flexible(
            child: ListView(
              children: dateDetailsList,
            ),
          );
        }

        return const Text("Loading");
      },
    );
  }
}
