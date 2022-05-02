// date_chat_page.dart - App page containing a users chat with either their date or their contacts

import 'package:cherub/models/date_chat_model.dart';
import 'package:cherub/models/date_details_model.dart';
import 'package:cherub/services/database_service.dart';
import 'package:cherub/widgets/user_input_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../models/date_message_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/date_chat_provider.dart';
import '../../services/navigation_service.dart';
import '../../widgets/custom_tile_list_widget.dart';
import '../../widgets/top_bar_widget.dart';
import '../date_activities/date_details_page.dart';

class DateChatPage extends StatefulWidget {
  final DateChat dateChat;
  const DateChatPage({Key? key, required this.dateChat}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DateChatPageState();
  }
}

class _DateChatPageState extends State<DateChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthProvider _auth;
  late DatabaseService _db;
  late NavigationService _nav;
  late DateChatProvider _pageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
    _db = GetIt.instance.get<DatabaseService>();
    _nav = GetIt.instance.get<NavigationService>();
    subscribeToDate();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DateChatProvider>(
          create: (_) => DateChatProvider(
              widget.dateChat.uid, _auth, _messagesListViewController),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<DateChatProvider>();
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
                    widget.dateChat.title(),
                    fontSize: 25,
                    primaryAction: IconButton(
                      icon: const Icon(
                        Icons.info,
                        color: Color.fromARGB(255, 20, 133, 43),
                      ),
                      onPressed: () async {
                        bool valid = false;
                        try {
                          DocumentSnapshot dbRef = await _db.dateDb
                              .getDateDetails(widget.dateChat.hostId,
                                  widget.dateChat.dateId);
                          if (dbRef.exists && dbRef.data() != null) {
                            DateDetailsModel aDate =
                                DateDetailsModel.fromDocument(dbRef);
                            _nav.goToPage(DateDetailsPage(aDate: aDate));
                            valid = true;
                          } else {
                            valid = false;
                          }
                        } on Exception catch (e) {
                          if (kDebugMode) {
                            print(
                                "date_chat_page.dart - Date has been deleted - " +
                                    e.toString());
                          }
                          valid = false;
                        }
                        if (mounted) {
                          if (!valid) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text(
                                      "Host has deleted the date details"),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("Continue"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                    secondaryAction: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 20, 133, 43),
                      ),
                      onPressed: () {
                        _pageProvider.goBack();
                      },
                    ),
                  ),
                  _messagesListView(),
                  _sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return SizedBox(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
            controller: _messagesListViewController,
            itemCount: _pageProvider.messages!.length,
            itemBuilder: (BuildContext _context, int _index) {
              DateMessage _message = _pageProvider.messages![_index];
              bool _isOwnMessage = _message.senderID == _auth.user.userId;
              return CustomTileListViewChat(
                deviceHeight: _deviceHeight,
                deviceWidth: _deviceWidth * 0.80,
                message: _message,
                isOwnMessage: _isOwnMessage,
                sender: widget.dateChat.contacts
                    .where((_user) => _user.userId == _message.senderID)
                    .first,
              );
            },
          ),
        );
      } else {
        return Align(
          alignment: Alignment.center,
          child: Text(
            "Say Hi!",
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

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      width: _deviceWidth,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 20, 133, 43),
        borderRadius: BorderRadius.circular(50),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
        vertical: _deviceHeight * 0.03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
            _locationUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.5,
      child: CustomInputForm(
          onSaved: (_value) {
            _pageProvider.message = _value;
          },
          regex: r"^(?!\s*$).+",
          hint: "Type a message",
          hidden: false),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.05;
    return SizedBox(
      height: _size,
      width: _size,
      child: IconButton(
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _pageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
      ),
    );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.05;
    return SizedBox(
      height: _size,
      width: _size,
      child: IconButton(
        icon: const Icon(
          Icons.camera_enhance,
          color: Colors.white,
        ),
        onPressed: () {
          _pageProvider.sendImageMessage();
        },
      ),
    );
  }

  Widget _locationUpdateButton() {
    double _size = _deviceHeight * 0.04;
    return SizedBox(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 20, 133, 43),
        onPressed: () {
          _pageProvider.sendUpdateMessage();
        },
        child: const Icon(Icons.location_on_rounded),
      ),
    );
  }

  void subscribeToDate() async {
    if (kDebugMode) {
      print("dateChat Uid: " +
          widget.dateChat.uid +
          ", dateDetails Uid: " +
          widget.dateChat.dateId);
    }
    await FirebaseMessaging.instance
        .subscribeToTopic(widget.dateChat.uid)
        .then((value) => {
              // ignore: avoid_print
              print("subscribeToDate(): User " +
                  _auth.user.username +
                  " subscribed to date chat notifications")
            });
    await FirebaseMessaging.instance
        .subscribeToTopic(widget.dateChat.dateId)
        .then((value) => {
              // ignore: avoid_print
              print("subscribeToDate(): User " +
                  _auth.user.username +
                  " subscribed to date started/ended notifications")
            });
  }
}
