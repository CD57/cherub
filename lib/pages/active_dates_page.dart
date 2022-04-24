// active_dates_page.dart - App page containing display for all users availiable date sessions.

import 'package:cherub/models/date_session_model.dart';
import 'package:cherub/models/user_model.dart';
import 'package:cherub/providers/sessions_page_provider.dart';
import 'package:cherub/widgets/custom_tile_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:cherub/providers/auth_provider.dart';
import '../services/navigation_service.dart';
import '../widgets/top_bar_widget.dart';

class ActiveDatesPage extends StatefulWidget {
  const ActiveDatesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActiveDatesPageState();
}

class _ActiveDatesPageState extends State<ActiveDatesPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthProvider _auth;
  late NavigationService _nav;
  late SessionsPageProvider _pageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthProvider>(context);
    _nav = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SessionsPageProvider>(
          create: (_) => SessionsPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<SessionsPageProvider>();
        return Scaffold(
          body: Container(
            color: Theme.of(context).backgroundColor,
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
                  'My Active Dates',
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
                _datesList(),
              ],
            ),
          ),
        );
      },
    );
  }

  _datesList() {
    List<DateSession>? _dateChat = _pageProvider.dates;
    return Expanded(
      child: (() {
        if (_dateChat != null) {
          if (_dateChat.isNotEmpty) {
            return ListView.builder(
              itemCount: _dateChat.length,
              itemBuilder: (BuildContext _context, int _index) {
                return _sessionTile(
                  _dateChat[_index],
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Active Dates",
                style: TextStyle(color: Color.fromARGB(255, 20, 133, 43)),
              ),
            );
          }
        } else {
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
        }
      })(),
    );
  }

  Widget _sessionTile(DateSession _dateSession) {
    List<UserModel> _recepients = _dateSession.received();
    bool _isActive = _recepients.any((_d) => _d.wasRecentlyActive());
    String _subtitle = "";
    if (_dateSession.locations.isNotEmpty) {
      _subtitle =
          "Active at " + _dateSession.locations.first.timeOfUpdate.toString();
    }
    return SessionListViewTile(
      height: _deviceHeight * 0.10,
      title: _dateSession.sessionUid,
      subtitle: _subtitle,
      isActive: _isActive,
      onTap: () {
        // _nav.goToPage(
        //   DateSessionPage(DateSession: _dateSession),
        // );
      },
    );
  }
}
