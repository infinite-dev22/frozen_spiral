import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:smart_case/pages/activities_page.dart';
import 'package:smart_case/pages/activity_view_page.dart';
import 'package:smart_case/pages/diary_page.dart';
import 'package:smart_case/pages/engagements_page.dart';
import 'package:smart_case/pages/event_view.dart';
import 'package:smart_case/pages/files_page.dart';
import 'package:smart_case/pages/home_page.dart';
import 'package:smart_case/pages/locator_page.dart';
import 'package:smart_case/pages/notifications_page.dart';
import 'package:smart_case/pages/profile_page.dart';
import 'package:smart_case/pages/reports_page.dart';
import 'package:smart_case/pages/requisition_view_page.dart';
import 'package:smart_case/pages/requisitions_page.dart';
import 'package:smart_case/pages/root_page.dart';
import 'package:smart_case/pages/tasks_page.dart';
import 'package:smart_case/pages/welcome_page.dart';
import 'package:smart_case/services/apis/firebase_apis.dart';
import 'package:smart_case/services/navigation/locator.dart';
import 'package:smart_case/services/navigation/navigator_service.dart';
import 'package:smart_case/theme/color.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initPushNotification();
  appFCMInit();
  handleForegroundMasseges();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  InAppNotifications.init();
  setupLocator();

  await GetSecureStorage.init(password: 'infosec_technologies_ug_smart_case_law_manager');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root widget
  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
        invalidateSessionForAppLostFocus: const Duration(minutes: 5),
        invalidateSessionForUserInactivity: const Duration(minutes: 5));

    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        locator<NavigationService>().navigateTo("/");
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   "/",
        //   (route) => false,
        // );
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        locator<NavigationService>().navigateTo("/");
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   "/",
        //   (route) => false,
        // );
      }
    });

    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      child: MaterialApp(
        navigatorKey: locator<NavigationService>().navigatorKey,
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
          '/requisitions': (context) => const RequisitionsPage(),
          '/events': (context) => const DiaryPage(),
          '/tasks': (context) => const TasksPage(),
          '/engagements': (context) => const EngagementsPage(),
          '/reports': (context) => const ReportsPage(),
          '/alerts': (context) => const AlertsPage(),
          '/locator': (context) => const LocatorPage(),
          '/profile': (context) => const ProfilePage(),
          '/requisition': (context) => const RequisitionViewPage(),
          '/event': (context) => const EventView(),
          '/activity': (context) => const ActivityViewPage(),
        },
      ),
    );
  }
}
