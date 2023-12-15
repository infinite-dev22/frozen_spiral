import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:smart_case/firebase_options.dart';
import 'package:smart_case/models/local/notifications.dart';
import 'package:smart_case/pages/activities_page.dart';
import 'package:smart_case/pages/activity_view_page.dart';
import 'package:smart_case/pages/cause_list_report_page.dart';
import 'package:smart_case/pages/diary_page.dart';
import 'package:smart_case/pages/done_activities_report_page.dart';
import 'package:smart_case/pages/engagements_page.dart';
import 'package:smart_case/pages/event_view.dart';
import 'package:smart_case/pages/file_page.dart';
import 'package:smart_case/pages/home_page.dart';
import 'package:smart_case/pages/locator_page.dart';
import 'package:smart_case/pages/login_page.dart';
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
import 'package:smart_case/util/smart_case_init.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Firebase core.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // FCM.
    await FirebaseApi().initPushNotification();
    handleForegroundMasseges();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // Navigator.
    setupLocator();
    // Shared Preferences.
    await GetSecureStorage.init(
        password: 'infosec_technologies_ug_smart_case_law_manager');
    // Local Storage.
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(NotificationsAdapter());
    }
    localStorage = await Hive.openBox<Notifications>('notifications');

    runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => const MyApp(), // Wrap your app
      ),
    );
  } catch (e) {
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppColors.red,
        textColor: AppColors.white,
        fontSize: 16.0);
  }
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

    final box = GetSecureStorage(
        password: 'infosec_technologies_ug_smart_case_law_manager');
    String? email = box.read('email');
    currentUsername = box.read('name');

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
          // textSelectionTheme: const TextSelectionThemeData(
          //   cursorColor: AppColors.gray75,
          //   selectionColor: AppColors.gray50,
          //   selectionHandleColor: AppColors.gray45,
          // ),
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
          // '/': (context) => const WelcomePage(),
          // '/': (context) => (email != null && email.isNotEmpty && email != "")
          //     ? const LoginPromptPage()
          //     : const WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/sign_in': (context) => const WelcomePage(),
          '/': (context) => (email != null && email.isNotEmpty && email != "")
              ? const WelcomePage()
              : const LoginPage(),
          // '/login': (context) => const WelcomePage(),
          // '/welcome': (context) => const LoginPromptPage(),
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
          '/cause_list_report': (context) => const CauseListReportPage(),
          '/done_activities_report': (context) =>
              const DoneActivitiesReportPage(),
        },
      ),
    );
  }

/*
  * For the profile image to change on SignIn, Try clearing the former image when the user clicks on the Login button.
  * Else implement Streams here.
  *
  * File search bottom sheet has an error, doesn't search files well.
   */
}
