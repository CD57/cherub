// date_chat_page.dart - App page containing a users chat with either their date or their contacts

import 'package:cherub/models/date_chat_model.dart';
import 'package:cherub/widgets/user_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/date_message_model.dart';
import '../providers/auth_provider.dart';
import '../providers/date_chat_provider.dart';
import '../widgets/custom_tile_list_widget.dart';
import '../widgets/top_bar_widget.dart';

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
  late DateChatProvider _pageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
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
                    fontSize: 10,
                    primaryAction: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                      onPressed: () {
                        _pageProvider.deleteChat();
                      },
                    ),
                    secondaryAction: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
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
              bool _isOwnMessage = _message.senderID == _auth.user.uid;
              return CustomTileListViewChat(
                deviceHeight: _deviceHeight,
                width: _deviceWidth * 0.80,
                message: _message,
                isOwnMessage: _isOwnMessage,
                sender: widget
                    .dateChat
                    .contacts
                    .where((_m) => _m.uid == _message.senderID)
                    .first,
              );
            },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say Hi!",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
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
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: UserInputForm(
          onSaved: (_value) {
            _pageProvider.message = _value;
          },
          regex: r"^(?!\s*$).+",
          hint: "Type a message",
          hidden: false),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;
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
    double _size = _deviceHeight * 0.04;
    return SizedBox(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(
          0,
          82,
          218,
          1.0,
        ),
        onPressed: () {
          _pageProvider.sendImageMessage();
        },
        child: const Icon(Icons.camera_enhance),
      ),
    );
  }
}
