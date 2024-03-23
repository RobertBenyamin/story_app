import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/utils/result_state.dart';

class CustomButton extends StatelessWidget {
  final String hintText;
  final Function()? function;
  const CustomButton({
    super.key,
    required this.hintText,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF2D3E50),
        ),
        width: double.infinity,
        child: Center(
          child: Text(
            context.watch<AuthProvider>().state == ResultState.loading
                ? 'Loading...'
                : hintText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
