// contacts_page.dart - App page containing a users contacts

import 'package:cherub/models/user_model.dart';
import 'package:cherub/providers/contacts_provider.dart';
import 'package:cherub/widgets/custom_button_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../services/navigation_service.dart';
import '../../widgets/custom_tile_list_widget.dart';
import '../../widgets/top_bar_widget.dart';
import '../../widgets/user_input_widget.dart';

final DatabaseService _dbService = GetIt.instance.get<DatabaseService>();
late List<String> usersFriendUids = [];
late String _uid;

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key, required this.dateId}) : super(key: key);
  final String dateId;
  @override
  State<StatefulWidget> createState() {
    return _ContactsPageState();
  }
}

class _ContactsPageState extends State<ContactsPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthProvider _auth;
  late final NavigationService _nav = GetIt.instance.get<NavigationService>();
  late ContactsProvider _contactsProvider;
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (kDebugMode) {
      print("contacts_page.dart - didChangeDependencies()");
    }
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
    setState(() {
      _deviceHeight = MediaQuery.of(context).size.height;
      _deviceWidth = MediaQuery.of(context).size.width;
      _uid = _auth.user.userId;
    });
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("contacts_page.dart - build");
    }
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
    return Material(child: Builder(
      builder: (BuildContext _context) {
        _contactsProvider = _context.watch<ContactsProvider>();
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
                'Contacts',
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
              CustomTextField(
                onEditingComplete: (_value) {
                  _contactsProvider.getUsers(name: _value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search...",
                obscureText: false,
                controller: _searchController,
                icon: Icons.search,
              ),
              _usersList(),
              _createChatButton(),
            ],
          ),
        );
      },
    ));
  }

  Expanded _usersList() {
    List<UserModel>? _users = _contactsProvider.users;
    List<UserModel>? _contacts = [];

    return Expanded(child: () {
      if (_users != null) {
        if (_users.isNotEmpty) {
          for (UserModel aUser in _users) {
            if (usersFriendUids.contains(aUser.userId)) {
              _contacts.add(aUser);
            }
          }
          return ListView.builder(
            itemCount: _contacts.length,
            itemBuilder: (BuildContext _context, int _index) {
              return CustomTileListView(
                height: _deviceHeight * 0.10,
                title: _contacts[_index].name,
                subtitle: "Last Active: ${_contacts[_index].lastDayActive()}",
                imagePath: _contacts[_index].imageURL,
                isActive: _contacts[_index].wasRecentlyActive(),
                isSelected: _contactsProvider.selectedUsers.contains(
                  _contacts[_index],
                ),
                onTap: () {
                  _contactsProvider.updateSelectedUsers(
                    _contacts[_index],
                  );
                },
              );
            },
          );
        } else {
          return Center(
            child: Text(
              "No Contacts Found.",
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
          if (widget.dateId != "None") {
            _contactsProvider.createChatWithId(widget.dateId);
          }
          _contactsProvider.createAndGoToChat();
        },
      ),
    );
  }

  void getFriends() async {
    usersFriendUids = await _dbService.getFriendsID(_uid);
    if (mounted) {
      setState(() {
        usersFriendUids = usersFriendUids;
      });
    }
  }
}
