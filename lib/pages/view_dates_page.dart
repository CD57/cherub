import 'package:cherub/models/date_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../providers/auth_provider.dart';
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
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthProvider _auth;
  late String _uid;
  late bool datesFound;
  List<DateDetailsWidget> datesList = [];

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
    AuthProvider _auth;
    _auth = Provider.of<AuthProvider>(context);

    setState(() {
      _uid = _auth.user.userId;
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
                    Icons.logout,
                    color: Color.fromARGB(255, 20, 133, 43),
                  ),
                  onPressed: () {
                    _auth.logout();
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
      child: ListView(
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
    );
  }

  _datesList(BuildContext context) {
    if (kDebugMode) {
      print("view_dates_page.dart - _datesList()");
    }
    CollectionReference dates = FirebaseFirestore.instance.collection('Dates');
    return FutureBuilder<QuerySnapshot>(
      future: dates.doc(_uid).collection("DateDetails").get(),
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
              children: datesList,
            ),
          );
        }

        return const Text("Loading");
      },
    );
  }
}
