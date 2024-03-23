import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/widgets/custom_button.dart';

import '../utils/result_state.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_textfield.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _register() {
    context.read<AuthProvider>().register(
          _nameController.text,
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
                textController: _nameController,
                obscureText: null,
                hintText: 'Name'),
            const SizedBox(height: 16.0),
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
                } else if (state.state == ResultState.hasData) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.blue, fontSize: 16),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 16.0),
            CustomButton(hintText: 'Register', function: _register),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: widget.showLoginPage,
                  child: const Text(
                    "Login Now",
                    style: TextStyle(
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
