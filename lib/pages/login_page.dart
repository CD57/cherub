// login_page.dart - App page containing forms for user to enter login details, or go to registration page
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/navigation_service.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/user_input_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthProvider _auth;
  late NavigationService _nav;

  final _loginFormKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  void initState() {
    if (kDebugMode) {
      print("login_page.dart - initState()");
    }
    _nav = GetIt.instance.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("login_page.dart - build - begin");
    }
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthProvider>(context);
    // _nav = GetIt.instance.get<NavigationService>();
    _auth.logout;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: ListView(
          children: [
            _pageTitle(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            _loginForm(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _loginButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            Center(child: _registerAccountLink()),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return SizedBox(
      height: _deviceHeight * 0.40,
      child: Container(
        height: 250,
        width: 250,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage('assets/images/Cherub-PNG-NoBack.png'),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return SizedBox(
      height: _deviceHeight * 0.18,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputForm(
                onSaved: (_value) {
                  setState(() {
                    _email = _value;
                  });
                },
                regex:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hint: "Email",
                hidden: false),
            CustomInputForm(
                onSaved: (_value) {
                  setState(() {
                    _password = _value;
                  });
                },
                regex: r".{8,}",
                hint: "Password",
                hidden: true),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return CustomButton(
      name: "Login",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if (_loginFormKey.currentState!.validate()) {
          _loginFormKey.currentState!.save();
          await _auth.emailLogin(_email!, _password!);
        }
        if (_auth.authorised) {
          if (kDebugMode) {
            print("login_page.dart - _loginButton() - User Authorised");
          }
          _nav.removeAndGoToRoute('/home');
        }
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => _nav.goToRoute('/registration'),
      child: Text(
        'Create A New Account',
        style: TextStyle(
          color: Colors.green.shade900,
        ),
      ),
    );
  }
}
