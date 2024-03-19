import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/provider/auth_provider.dart';

import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/register.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) {
          return const RegisterPage();
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      if (context.watch<AuthProvider>().isLoggedIn) {
        return '/';
      } else {
        return '/login';
      }
    },
  );
}
