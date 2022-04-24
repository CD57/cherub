// date_chat_page.dart - App page containing a users chat with either their date or their contacts

import 'package:cherub/models/date_session_model.dart';
import 'package:cherub/models/location_data_model.dart';
import 'package:cherub/providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_tile_list_widget.dart';
import '../../widgets/top_bar_widget.dart';

class SessionPage extends StatefulWidget {
  final DateSession dateSession;
  const SessionPage({Key? key, required this.dateSession}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SessionPageState();
  }
}

class _SessionPageState extends State<SessionPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthProvider _auth;
  late SessionProvider _sessionProvider;
  late GlobalKey<FormState> _updateFormState;
  late ScrollController _locationsListViewController;

  @override
  void initState() {
    super.initState();
    _updateFormState = GlobalKey<FormState>();
    _locationsListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SessionProvider>(
          create: (_) => SessionProvider(
              widget.dateSession.dateUid, _locationsListViewController),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _sessionProvider = _context.watch<SessionProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02,
              ),
              height: _deviceHeight,
              width: _deviceWidth * 0.97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    widget.dateSession.sessionUid,
                    fontSize: 25,
                    primaryAction: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 20, 133, 43),
                      ),
                      onPressed: () {
                        _sessionProvider.deleteSession();
                      },
                    ),
                    secondaryAction: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 20, 133, 43),
                      ),
                      onPressed: () {
                        _sessionProvider.goBack();
                      },
                    ),
                  ),
                  _updatesListView(),
                  _sendUpdateForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _updatesListView() {
    if (_sessionProvider.locations != null) {
      if (_sessionProvider.locations!.isNotEmpty) {
        return SizedBox(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
            controller: _locationsListViewController,
            itemCount: _sessionProvider.locations!.length,
            itemBuilder: (BuildContext _context, int _index) {
              LocationData _locationData = _sessionProvider.locations![_index];
              return SessionListViewTileUpdates(
                deviceHeight: _deviceHeight,
                deviceWidth: _deviceWidth * 0.80,
                locationUpdate: _locationData,
              );
            },
          ),
        );
      } else {
        return Align(
          alignment: Alignment.center,
          child: Text(
            "Provide an Update!",
            style: TextStyle(color: Colors.green.shade900),
          ),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.green.shade900,
        ),
      );
    }
  }

  Widget _sendUpdateForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 20, 133, 43),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
        vertical: _deviceHeight * 0.03,
      ),
      child: Form(
        key: _updateFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _sendUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _sendUpdateButton() {
    double _size = _deviceHeight * 0.05;
    return SizedBox(
      height: _size,
      width: _size,
      child: IconButton(
        icon: const Icon(
          Icons.location_pin,
          color: Colors.white,
        ),
        onPressed: () {
          if (_updateFormState.currentState!.validate()) {
            _updateFormState.currentState!.save();
            _sessionProvider.sendLocationData();
            _updateFormState.currentState!.reset();
          }
        },
      ),
    );
  }
}
