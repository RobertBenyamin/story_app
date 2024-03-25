import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common.dart';
import 'routes/app_router.dart';
import 'data/api/api_services.dart';
import 'provider/list_provider.dart';
import 'data/db/auth_repository.dart';
import 'provider/detail_provider.dart';
import 'provider/upload_provider.dart';
import 'provider/localization_provider.dart';

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
          ChangeNotifierProvider.value(
            value: AppRouter.loginInfo,
          ),
          ChangeNotifierProvider(
              create: (context) =>
                  StoryListProvider(apiService: ApiServices())),
          ChangeNotifierProvider(
              create: (context) =>
                  StoryDetailProvider(apiService: ApiServices())),
          ChangeNotifierProvider(
              create: (context) => UploadProvider(apiService: ApiServices())),
          ChangeNotifierProvider(create: (context) => LocalizationProvider())
        ],
        builder: (context, child) {
          final provider = Provider.of<LocalizationProvider>(context);
          return MaterialApp.router(
            title: 'Story App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              fontFamily: GoogleFonts.quicksand().fontFamily,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: provider.locale,
            routerConfig: AppRouter.router,
          );
        });
  }
}
