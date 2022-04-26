// dates_page.dart - App page containing display for all users availiable dates.

import 'package:cherub/models/user_model.dart';
import 'package:cherub/widgets/custom_tile_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:cherub/providers/auth_provider.dart';

import '../../models/date_chat_model.dart';
import '../../models/date_message_model.dart';
import '../../providers/dates_page_provider.dart';
import '../../services/navigation_service.dart';
import '../../widgets/top_bar_widget.dart';
import 'date_chat_page.dart';

class DatesPage extends StatefulWidget {
  const DatesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DatesPageState();
  }
}

class _DatesPageState extends State<DatesPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthProvider _auth;
  late NavigationService _nav;
  late DatesPageProvider _pageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthProvider>(context);
    _nav = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatesPageProvider>(
          create: (_) => DatesPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        if (mounted) {
          _pageProvider = _context.watch<DatesPageProvider>();
        }
        return Container(
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
                'My Date Chats',
                primaryAction: IconButton(
                  icon: const Icon(
                    Icons.logout_sharp,
                    color: Color.fromARGB(255, 20, 133, 43),
                  ),
                  onPressed: () {
                    _auth.logout();
                  },
                ),
              ),
              _datesList(),
            ],
          ),
        );
      },
    );
  }

  _datesList() {
    List<DateChat>? _dateChat = _pageProvider.dates;
    return Expanded(
      child: (() {
        if (_dateChat != null) {
          if (_dateChat.isNotEmpty) {
            return ListView.builder(
              itemCount: _dateChat.length,
              itemBuilder: (BuildContext _context, int _index) {
                return _chatTile(
                  _dateChat[_index],
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Dates Available",
                style: TextStyle(color: Color.fromARGB(255, 20, 133, 43)),
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
      })(),
    );
  }

  Widget _chatTile(DateChat _dateChat) {
    List<UserModel> _recepients = _dateChat.received();
    bool _isActive = _recepients.any((_d) => _d.wasRecentlyActive());
    String _subtitle = "";
    if (_dateChat.messages.isNotEmpty) {
      _subtitle = _dateChat.messages.first.type == MessageContentType.text
          ? _dateChat.messages.first.content
          : _dateChat.messages.first.type == MessageContentType.media
              ? "Image Sent"
              : "Location Update";
    }
    return CustomTileListViewWithActivity(
      height: _deviceHeight * 0.10,
      title: _dateChat.title(),
      subtitle: _subtitle,
      imagePath: _dateChat.imageURL(),
      isActive: _isActive,
      isTyping: _dateChat.isTyping,
      onTap: () {
        _nav.goToPage(
          DateChatPage(dateChat: _dateChat),
        );
      },
    );
  }
}
