// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  AuthTextField({
    super.key,
    required this.textController,
    required this.obscureText,
    required this.hintText,
  });

  final TextEditingController textController;
  bool? obscureText;
  final String hintText;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      obscureText: widget.obscureText ?? false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF94c8ff),
            width: 3,
          ),
        ),
        suffixIcon: widget.obscureText != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText!;
                  });
                },
                icon: Icon(
                  widget.obscureText! ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF37465D),
                ),
              )
            : null,
      ),
    );
  }
}
