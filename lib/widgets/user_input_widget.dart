// user_input_widget.dart - Custom widget for user form input, containing text hint, regex validation, and hidden text option

import 'package:flutter/material.dart';

class CustomInputForm extends StatelessWidget {
  final Function(String) onSaved;
  final String regex;
  final String hint;
  final bool hidden;

  const CustomInputForm(
      {Key? key,
      required this.onSaved,
      required this.regex,
      required this.hint,
      required this.hidden})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (_value) => onSaved(_value!),
      cursorColor: Colors.green.shade900,
      style: TextStyle(color: Colors.green.shade900),
      obscureText: hidden,
      validator: (_value) {
        return RegExp(regex).hasMatch(_value!)
            ? null
            : 'Invalid Input, Please Try Again';
      },
      decoration: InputDecoration(
        fillColor: Colors.green.shade400,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.green.shade900),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  IconData? icon;

  CustomTextField(
      {Key? key, required this.onEditingComplete,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: () => onEditingComplete(controller.value.text),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Colors.green[900],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
      ),
    );
  }
}
