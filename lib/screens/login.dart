import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';

import '../utils/result_state.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/custom_button.dart';

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
            const Text(
              'Story App',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            AuthTextField(
                textController: _emailController,
                obscureText: null,
                hintText: 'Email'),
            const SizedBox(height: 16.0),
            AuthTextField(
                textController: _passwordController,
                obscureText: true,
                hintText: 'Password'),
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
            CustomButton(hintText: 'Login', function: _login),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account yet? "),
                GestureDetector(
                  onTap: widget.showRegisterPage,
                  child: const Text(
                    "Register Now",
                    style: TextStyle(color: Colors.blue),
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
