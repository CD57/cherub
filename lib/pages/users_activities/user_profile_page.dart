import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherub/models/user_model.dart';
import 'package:cherub/services/navigation_service.dart';
import 'package:cherub/widgets/top_bar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';

class UserProfilePage extends StatefulWidget {
  //final NavigationService _nav = GetIt.instance.get<NavigationService>();
  final UserModel aUser;
  const UserProfilePage({Key? key, required this.aUser}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfilePage> {
  final NavigationService _nav = GetIt.instance.get<NavigationService>();
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthProvider _auth;
  bool loadingBool = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
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
          children: <Widget>[
            TopBar(
              widget.aUser.name,
              primaryAction: topBarButton()
            ),
            buildProfile(),
          ],
        ),
      ),
    );
  }

  buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.grey,
                backgroundImage:
                    CachedNetworkImageProvider(widget.aUser.imageURL),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const <Widget>[Text("Friends")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        profileButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              widget.aUser.username,
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
              widget.aUser.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              widget.aUser.email,
            ),
          ),
        ],
      ),
    );
  }

  profileButton() {
    bool isProfileOwner = _auth.user.userId == widget.aUser.userId;
    if (isProfileOwner) {
      return buildButton(text: "Edit Profile", function: editProfile);
    } else {
      return buildButton(text: "Send Message", function: sendMessage);
    }
  }

  topBarButton() {
    bool isProfileOwner = _auth.user.userId == widget.aUser.userId;
    if (isProfileOwner) {
      return IconButton(
        icon: const Icon(
          Icons.logout_sharp,
          color: Color.fromARGB(255, 20, 133, 43),
        ),
        onPressed: () {
          _auth.logout();
        },
      );
    } else {
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
  }

  TextButton buildButton(
      {required String text, required Function()? function}) {
    return TextButton(
      onPressed: function,
      child: Container(
        width: 200.0,
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

  editProfile() {
    if (kDebugMode) {
      print("User Profile Edit Button Pressed");
    }
  }

  sendMessage() {
    if (kDebugMode) {
      print("User Profile Message Button Pressed");
    }
  }
}
