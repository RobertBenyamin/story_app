import 'package:go_router/go_router.dart';
import 'package:story_app/screens/add_story.dart';
import 'package:story_app/provider/auth_provider.dart';

import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/detail.dart';
import '../screens/register.dart';
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
          return const LoginPage();
        },
      ),
      GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) {
            return const RegisterPage();
          }),
    ],
    redirect: (context, state) {
      bool loggedIn = loginInfo.isLoggedIn;
      String currentPath = state.fullPath!;

      // Jika pengguna belum masuk, dan mencoba mengakses halaman selain /login atau /register,
      // arahkan mereka ke /login.
      if (!loggedIn && currentPath != '/login' && currentPath != '/register') {
        return '/login';
      }

      // Jika pengguna telah masuk, tetapi mencoba mengakses halaman /login atau /register,
      // arahkan mereka kembali ke halaman beranda.
      if (loggedIn && (currentPath == '/login' || currentPath == '/register')) {
        return '/';
      }

      // Tidak perlu redirect
      return null;
    },
    refreshListenable: loginInfo,
  );
}
