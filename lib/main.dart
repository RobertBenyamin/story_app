import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_services.dart';
import 'package:story_app/provider/auth_provider.dart';

import 'data/db/auth_repository.dart';
import 'provider/list_provider.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthRepository.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(
              authRepository: AuthRepository(),
              apiService: ApiServices(),
            ),
          ),
          ChangeNotifierProvider(
              create: (context) =>
                  StoryListProvider(apiService: ApiServices())),
        ],
        child: MaterialApp.router(
          title: 'Story App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: AppRouter.router,
        ));
  }
}
