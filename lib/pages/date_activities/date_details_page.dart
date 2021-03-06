import 'package:cherub/models/date_details_model.dart';
import 'package:cherub/services/database_service.dart';
import 'package:cherub/services/navigation_service.dart';
import 'package:cherub/services/notification_service.dart';
import 'package:cherub/widgets/top_bar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';

class DateDetailsPage extends StatefulWidget {
  final DateDetailsModel aDate;
  const DateDetailsPage({Key? key, required this.aDate}) : super(key: key);

  @override
  _DateDetailsState createState() {
    return _DateDetailsState();
  }
}

class _DateDetailsState extends State<DateDetailsPage> {
  late final NavigationService _nav = GetIt.instance.get<NavigationService>();
  late final DatabaseService _db = GetIt.instance.get<DatabaseService>();
  late final NotificationService _notifications =
      GetIt.instance.get<NotificationService>();
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthProvider _auth;
  bool loadingBool = false;

  final Map<String, Marker> _markers = {};

  @override
  void didChangeDependencies() {
    if (kDebugMode) {
      print("date_details_page.dart - didChangeDependencies()");
    }
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
    setState(() {
      _deviceHeight = MediaQuery.of(context).size.height;
      _deviceWidth = MediaQuery.of(context).size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("date_details_page.dart - build");
    }
    return _buildUI();
  }

  Widget _buildUI() {
    return Material(child: Builder(
      builder: (BuildContext _context) {
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
              children: <Widget>[
                TopBar("Date Info", primaryAction: topBarButton()),
                buildProfile(),
              ],
            ),
          ),
        );
      },
    ));
  }

  buildProfile() {
    List<String> latLng = widget.aDate.dateGPS.split(",");
    double latitude = double.parse(latLng[0]);
    double longitude = double.parse(latLng[1]);
    LatLng _location = LatLng(latitude, longitude);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 300.0,
            height: 300.0,
            child: GoogleMap(
              scrollGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: _onMapCreated,
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: _location,
                zoom: 20.0,
              ),
              markers: _markers.values.toSet(),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              "Date Plan: " + widget.aDate.datePlan,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "Date Time: " + widget.aDate.dateTime.toDate().toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "Check-In Time: " + widget.aDate.checkInTime.toDate().toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              "Date with: " + widget.aDate.datesUserId,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: dateButtons(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: dateButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  dateButtons() {
    bool isDateOwner = _auth.user.userId == widget.aDate.hostUid;
    if (isDateOwner) {
      return <Widget>[
        buildButton(text: "Start of Date Alert", function: startDate),
        buildButton(text: "End of Date Alert", function: endDate),
      ];
    } else {
      return <Widget>[];
    }
  }

  dateButton() {
    bool isDateOwner = _auth.user.userId == widget.aDate.hostUid;
    if (isDateOwner) {
      return <Widget>[
        buildButton(text: "Cancel Date", function: cancelDate),
      ];
    } else {
      return <Widget>[];
    }
  }

  topBarButton() {
    return IconButton(
      icon: const Icon(
        Icons.keyboard_return_rounded,
        color: Color.fromARGB(255, 20, 133, 43),
      ),
      onPressed: () {
        _nav.goBack();
      },
    );
  }

  TextButton buildButton(
      {required String text, required Function()? function}) {
    return TextButton(
      onPressed: function,
      child: Container(
        width: 125.0,
        height: 30.0,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green.shade700,
          border: Border.all(
            color: Colors.green.shade700,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  startDate() async {
    await _notifications.createBeginNotification();
    await _db.dateDb
        .updateDateStarted(_auth.user.userId, widget.aDate.uid, true);
  }

  endDate() async {
    await _notifications.createEndNotification();
    await _db.dateDb
        .updateDateStarted(_auth.user.userId, widget.aDate.uid, false);
  }

  cancelDate() async {
    await _db.dateDb.deleteDateDetails(_auth.user.userId, widget.aDate);
    _nav.goBack();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    var latLngString = widget.aDate.dateGPS.split(",");
    double lat = double.parse(latLngString[0]);
    double lng = double.parse(latLngString[1]);
    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId(widget.aDate.dateGPS),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: "Date Location",
          snippet: widget.aDate.dateGPS,
        ),
      );
      _markers[widget.aDate.dateGPS] = marker;
    });
  }
}
