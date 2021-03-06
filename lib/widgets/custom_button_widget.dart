// custom_button_widget.dart - Custom widget for button, containing text and size details

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final Function onPressed;

  const CustomButton({
    Key? key,
    required this.name,
    required this.height,
    required this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * 0.25),
        color: Colors.green.shade900,
      ),
      child: TextButton(
        onPressed: () => onPressed(),
        child: Text(
          name,
          style: const TextStyle(
              fontSize: 22, color: Colors.white, height: 1.5),
        ),
      ),
    );
  }
}
