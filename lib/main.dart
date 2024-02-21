import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:smart_case/database/local/notifications.dart';
import 'package:smart_case/firebase_options.dart';
import 'package:smart_case/pages/activity_page/activities_page.dart';
import 'package:smart_case/pages/activity_page/widgets/view_widget.dart';
import 'package:smart_case/pages/auth_pages/login_page/login_page.dart';
import 'package:smart_case/pages/auth_pages/signin_page/signin_page.dart';
import 'package:smart_case/pages/engagement_page/engagements_page.dart';
import 'package:smart_case/pages/event_page/event_page.dart';
import 'package:smart_case/pages/event_page/widgets/event_view.dart';
import 'package:smart_case/pages/file_page/file_page.dart';
import 'package:smart_case/pages/home_page/home_page.dart';
import 'package:smart_case/pages/invoice_page/invoice_page.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/invoice_view_page.dart';
import 'package:smart_case/pages/locator_page/locator_page.dart';
import 'package:smart_case/pages/notification_page/notifications_page.dart';
import 'package:smart_case/pages/profile_page/profile_page.dart';
import 'package:smart_case/pages/report_page/reports_page.dart';
import 'package:smart_case/pages/report_page/widgets/reports/cause_list_report_page.dart';
import 'package:smart_case/pages/report_page/widgets/reports/done_activities_report_page.dart';
import 'package:smart_case/pages/requisition_page/requisitions_page.dart';
import 'package:smart_case/pages/requisition_page/widgets/requisition_view_page.dart';
import 'package:smart_case/pages/root_page/root_page.dart';
import 'package:smart_case/pages/task_page/tasks_page.dart';
import 'package:smart_case/services/apis/firebase_apis.dart';
import 'package:smart_case/services/navigation/locator.dart';
import 'package:smart_case/services/navigation/navigator_service.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/profile_pic_widget/bloc/profile_pic_bloc.dart';

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
          '/login': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const LoginPage(),
              ),
          '/sign_in': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const WelcomePage(),
              ),
          '/': (context) => (email != null && email.isNotEmpty && email != "")
              ? BlocProvider(
                  create: (context) => ProfilePicBloc(),
                  child: const WelcomePage(),
                )
              : BlocProvider(
                  create: (context) => ProfilePicBloc(),
                  child: const LoginPage(),
                ),
          '/root': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const RootPage(),
              ),
          '/home': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const HomePage(),
              ),
          '/files': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const FilesPage(),
              ),
          '/activities': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const ActivitiesPage(),
              ),
          '/requisitions': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const RequisitionsPage(),
              ),
          '/events': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const DiaryPage(),
              ),
          '/tasks': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const TasksPage(),
              ),
          '/engagements': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const EngagementsPage(),
              ),
          '/reports': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const ReportsPage(),
              ),
          '/alerts': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const AlertsPage(),
              ),
          '/locator': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const LocatorPage(),
              ),
          '/profile': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const ProfilePage(),
              ),
          '/requisition': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const RequisitionViewPage(),
              ),
          '/event': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const EventView(),
              ),
          '/activity': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const ViewWidget(),
              ),
          '/cause_list_report': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const CauseListReportPage(),
              ),
          '/done_activities_report': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const DoneActivitiesReportPage(),
              ),
          '/invoices': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const InvoicePage(),
              ),
          '/invoice': (context) => BlocProvider(
                create: (context) => ProfilePicBloc(),
                child: const InvoiceViewPage(),
              ),
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
