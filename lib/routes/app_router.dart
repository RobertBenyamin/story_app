import 'package:go_router/go_router.dart';
import 'package:story_app/provider/auth_provider.dart';

import '../data/api/api_services.dart';
import '../data/db/auth_repository.dart';
import '../screens/auth.dart';
import '../screens/home.dart';

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
      if (loginInfo.isLoggedIn) {
        return null;
      } else {
        return '/login';
      }
    },
    refreshListenable: loginInfo,
  );
}
