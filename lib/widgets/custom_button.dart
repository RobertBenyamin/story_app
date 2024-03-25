import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common.dart';
import '../utils/result_state.dart';
import '../provider/auth_provider.dart';

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
                ? AppLocalizations.of(context)!.loading
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
