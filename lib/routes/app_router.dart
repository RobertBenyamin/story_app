import 'package:go_router/go_router.dart';
import 'package:story_app/screens/add_story.dart';
import 'package:story_app/provider/auth_provider.dart';

import '../screens/auth.dart';
import '../screens/home.dart';
import '../screens/detail.dart';
import '../data/api/api_services.dart';
import '../data/db/auth_repository.dart';

class AppRouter {
  static final loginInfo = AuthProvider(
    authRepository: AuthRepository(),
    apiService: ApiServices(),
  );
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          return const HomePage();
        },
        routes: [
          GoRoute(
            path: 'stories/create',
            name: 'add_story',
            builder: (context, state) {
              return const AddStoryPage();
            },
          ),
          GoRoute(
            path: 'stories/:id',
            name: 'detail',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return DetailPage(id: id!);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return const AuthPage();
        },
      ),
    ],
    redirect: (context, state) {
      bool loggedIn = loginInfo.isLoggedIn;
      bool loggingIn = state.fullPath == '/login';
      if (!loggedIn) return loggingIn ? null : '/login';

      // if the user is logged in but still on the login page, send them to
      // the home page
      if (loggingIn) return '/';

      // no need to redirect at all
      return null;
    },
    refreshListenable: loginInfo,
  );
}
