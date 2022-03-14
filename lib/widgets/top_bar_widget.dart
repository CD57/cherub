// top_bar_widget.dart - Custom widget for top bar, containing details such as title and actions

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopBar extends StatelessWidget {
  final String _barTitle;
  Widget? primaryAction;
  Widget? secondaryAction;
  double? fontSize;

  late double _deviceHeight;
  late double _deviceWidth;

  TopBar(
    this._barTitle, {Key? key, 
    this.primaryAction,
    this.secondaryAction,
    this.fontSize = 35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return SizedBox(
      height: _deviceHeight * 0.10,
      width: _deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryAction != null) secondaryAction!,
          _titleBar(),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget _titleBar() {
    return Text(
      _barTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: const Color.fromARGB(255, 20, 133, 43),
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
