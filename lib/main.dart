import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/core/api_client.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id', null);
  await GetStorage.init();

  await dotenv.load(fileName: ".env");

  ApiClient.initialize();

  // Check auth status untuk set initial route
  final storage = GetStorage();
  final token = storage.read('token');
  final userData = storage.read('user_data');

  String initialRoute = '/welcome';
  if (token != null && userData != null) {
    try {
      final userMap = Map<String, dynamic>.from(userData);
      final onboardingCompleted = userMap['profile']?['onboarding_completed'] ?? false;
      if (onboardingCompleted == true) {
        initialRoute = '/home';
      } else {
        initialRoute = '/onboarding';
      }
    } catch (e) {
      initialRoute = '/welcome';
    }
  }

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Irtiqa",
          initialRoute: initialRoute,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('id'), Locale('en')],
          locale: const Locale('id'),
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                physics: const BouncingScrollPhysics(),
              ),
              child: child!,
            );
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF009689),
              brightness: Brightness.light,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(),
            useMaterial3: true,
          ),
        );
      },
    ),
  );
}
