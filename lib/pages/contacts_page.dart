// contacts_page.dart - App page containing a users contacts

import 'package:cherub/models/user_model.dart';
import 'package:cherub/providers/contacts_provider.dart';
import 'package:cherub/widgets/custom_button_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_tile_list_widget.dart';
import '../widgets/top_bar_widget.dart';
import '../widgets/user_input_widget.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ContactsPageState();
  }
}

class _ContactsPageState extends State<ContactsPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthProvider _auth;
  late ContactsProvider _contactsProvider;
  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("contacts_page.dart - build");
    }
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
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
    return Builder(
      builder: (BuildContext _context) {
        _contactsProvider = _context.watch<ContactsProvider>();
        return Container(
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
                'Users',
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
              CustomTextField(
                onEditingComplete: (_value) {
                  _contactsProvider.getUsers(name: _value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search...",
                obscureText: false,
                controller: _searchFieldTextEditingController,
                icon: Icons.search,
              ),
              _usersList(),
              _createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _usersList() {
    List<UserModel>? _users = _contactsProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.isNotEmpty) {
          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext _context, int _index) {
              return CustomTileListView(
                height: _deviceHeight * 0.10,
                title: _users[_index].name,
                subtitle: "Last Active: ${_users[_index].lastDayActive()}",
                imagePath: _users[_index].imageURL,
                isActive: _users[_index].wasRecentlyActive(),
                isSelected: _contactsProvider.selectedUsers.contains(
                  _users[_index],
                ),
                onTap: () {
                  _contactsProvider.updateSelectedUsers(
                    _users[_index],
                  );
                },
              );
            },
          );
        } else {
          return Center(
            child: Text(
              "No Users Found.",
              style: TextStyle(
                color: Colors.green.shade900,
              ),
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
    }());
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _contactsProvider.selectedUsers.isNotEmpty,
      child: CustomButton(
        name: _contactsProvider.selectedUsers.length == 1
            ? "Chat With ${_contactsProvider.selectedUsers.first.name}"
            : "Create Group Chat",
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPressed: () {
          _contactsProvider.createChat();
        },
      ),
    );
  }
}
