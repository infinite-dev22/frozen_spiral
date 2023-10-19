import 'package:flutter/material.dart';
import 'package:smart_case/pages/activities_page.dart';
import 'package:smart_case/pages/files_page.dart';
import 'package:smart_case/pages/home_page.dart';
import 'package:smart_case/pages/locator_page.dart';
import 'package:smart_case/pages/notifications_page.dart';
import 'package:smart_case/pages/profile_page.dart';
import 'package:smart_case/pages/root_page.dart';
import 'package:smart_case/pages/welcome_page.dart';
import 'package:smart_case/theme/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartCase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.light,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme */
      routes: {
        '/': (context) => const WelcomePage(),
        '/root': (context) => const RootPage(),
        '/home': (context) => const HomePage(),
        '/files': (context) => const FilesPage(),
        '/activities': (context) => const ActivitiesPage(),
        '/alerts': (context) => const AlertsPage(),
        '/locator': (context) => const LocatorPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }

  // _getPreferences() async {
  //   String? value = await storage.read(key: 'email');
  //
  //   Map<String, String> allValues = await storage.readAll();
  //
  //   await storage.delete(key: key);
  //
  //   await storage.deleteAll();
  // }
}
