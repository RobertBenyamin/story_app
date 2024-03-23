import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common.dart';
import '../utils/result_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_textfield.dart';
import '../provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _login() {
    context.read<AuthProvider>().login(
          _emailController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.appName,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            AuthTextField(
                textController: _emailController,
                obscureText: null,
                hintText: AppLocalizations.of(context)!.email),
            const SizedBox(height: 16.0),
            AuthTextField(
                textController: _passwordController,
                obscureText: true,
                hintText: AppLocalizations.of(context)!.password),
            const SizedBox(height: 16.0),
            Consumer<AuthProvider>(
              builder: (context, state, _) {
                if (state.state == ResultState.error) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 16.0),
            CustomButton(
                hintText: AppLocalizations.of(context)!.login,
                function: _login),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.registerTextButton1),
                GestureDetector(
                  onTap: widget.showRegisterPage,
                  child: Text(
                    AppLocalizations.of(context)!.registerTextButton2,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
