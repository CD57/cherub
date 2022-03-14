// registraion_page.dart - App page containing forms for user to enter details of registration.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/media_service.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/profile_picture_widget.dart';
import '../widgets/user_input_widget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthProvider _auth;
  late DatabaseService _db;
  late StorageService _storage;

  String? _username;
  String? _name;
  String? _number;
  String? _email;
  String? _password;
  XFile? _profileImage;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("registration_page.dart - build()");
    }
    _auth = Provider.of<AuthProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<StorageService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profilePictureField(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _registrationForm(),
            SizedBox(
              height: _deviceHeight * 0.1,
            ),
            _registerButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilePictureField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().getImageFromGallery().then(
          (_file) {
            setState(
              () {
                _profileImage = _file;
              },
            );
          },
        );
      },
      child: () {
        if (_profileImage != null) {
          return ProfilePictureFile(
            key: UniqueKey(),
            image: _profileImage!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return ProfilePictureNetwork(
            key: UniqueKey(),
            image:
                "https://firebasestorage.googleapis.com/v0/b/cherub-app.appspot.com/o/images%2Fdefault%2FNoPicture%2FUser-NoProfile-PNG.png?alt=media&token=4e098702-0f8c-4eb4-b670-9ac2035dbe3c",
            size: _deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget _registrationForm() {
    return SizedBox(
      height: _deviceHeight * 0.50,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputForm(
                onSaved: (_value) {
                  setState(() {
                    _username = _value;
                  });
                },
                regex: r'.{5,}',
                hint: "Username",
                hidden: false),
                SizedBox(
              height: _deviceHeight * 0.01,
            ),
            CustomInputForm(
                onSaved: (_value) {
                  setState(() {
                    _name = _value;
                  });
                },
                regex: r'.{8,}',
                hint: "Name",
                hidden: false),
                SizedBox(
              height: _deviceHeight * 0.01,
            ),
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
                SizedBox(
              height: _deviceHeight * 0.01,
            ),
            CustomInputForm(
                onSaved: (_value) {
                  setState(() {
                    _number = _value;
                  });
                },
                regex: r".{8,}",
                hint: "Phone Number",
                hidden: false),
                SizedBox(
              height: _deviceHeight * 0.01,
            ),
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

  Widget _registerButton() {
    late String _imageURL;
    return CustomButton(
      name: "Register",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate()) {
          _registerFormKey.currentState!.save();
          String? _uid = await _auth.emailRegister(_email!, _password!);
          if (_profileImage != null) {
            _imageURL =
                (await _storage.saveProfilePicture(_uid!, _profileImage!))!;
          } else {
            _imageURL =
                "https://firebasestorage.googleapis.com/v0/b/cherub-app.appspot.com/o/images%2Fdefault%2FNoPicture%2FUser-NoProfile-PNG.png?alt=media&token=4e098702-0f8c-4eb4-b670-9ac2035dbe3c";
          }

          await _db.createUser(_uid!, _username!, _name!, _number!, _email!, _imageURL);
          await _auth.setAccountDetails(_username!, _imageURL);
          if (kDebugMode) {
            print("registration_page.dart - registerButton() - User Created and Account Details Updated");
          }
        } else {
          if (kDebugMode) {
            print(
                "registration_page.dart - _registerButton - onPressed: Error");
          }
        }
      },
    );
  }
}
