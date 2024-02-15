import 'dart:io';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:list_load_more/utils/ext/iterable_ext.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/data/screen_arguments.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/local/notifications.dart';
import 'package:smart_case/pages/activity_page/activities_page.dart';
import 'package:smart_case/pages/activity_page/widgets/activity_form.dart';
import 'package:smart_case/pages/engagement_page/widgets/engagements_form.dart';
import 'package:smart_case/pages/event_page/widgets/event_form.dart';
import 'package:smart_case/pages/file_page/file_page.dart';
import 'package:smart_case/pages/home_page/home_page.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_form.dart';
import 'package:smart_case/pages/invoice_page/invoice_page.dart';
import 'package:smart_case/pages/notification_page/notifications_page.dart';
import 'package:smart_case/pages/requisition_page/widgets/requisition_form.dart';
import 'package:smart_case/pages/root_page/widgets/bottom_bar_item.dart';
import 'package:smart_case/pages/task_page/widgets/task_form.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/bank_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/client_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/engagement_type_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/file_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_approver_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_item_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_type_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/requisition_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/tax_type_api.dart';
import 'package:smart_case/services/navigation/locator.dart';
import 'package:smart_case/services/navigation/navigator_service.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String release = "";
  int _activeTab = 0;

  final TextEditingController activitySearchController =
      TextEditingController();
  final TextEditingController fileSearchController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController otherNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController personalEmailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController socialSecurityNumberController =
      TextEditingController();
  final TextEditingController tinNumberController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  List<SmartCurrency> currencies = List.empty(growable: true);

  _barItems() {
    return [
      {
        "icon": Icons.home_outlined,
        "active_icon": Icons.home_rounded,
        "name": "Home",
        "page": const HomePage(),
      },
      {
        "icon": Icons.file_copy_outlined,
        "active_icon": Icons.file_copy_rounded,
        "name": "Files",
        "page": const FilesPage(),
      },
      {
        "icon": Icons.local_activity_outlined,
        "active_icon": Icons.local_activity_rounded,
        "name": "Activities",
        "page": const ActivitiesPage(),
      },
      {
        "icon": Icons.notifications_none_rounded,
        "active_icon": Icons.notifications_rounded,
        "name": "Alerts",
        "page": const AlertsPage(),
      },
      {
        "icon": Icons.location_on_outlined,
        "active_icon": Icons.location_on_rounded,
        "name": "Locator",
        "page": const InvoicePage() /*LocatorPage()*/,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: DoubleBack(
        message: 'Tap back again to exit',
        child: _buildPage(),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _buildFab(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  _buildFab() {
    return ExpandableFab(
      type: ExpandableFabType.up,
      duration: const Duration(milliseconds: 500),
      distance: 65.0,
      childrenOffset: const Offset(0, 20),
      overlayStyle: ExpandableFabOverlayStyle(
        // color: Colors.black.withOpacity(0.5),
        blur: 5,
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        angle: 3.14 * 2,
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
      ),
      children: [
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.handshake_outlined),
          onPressed: _buildEngagementForm,
          label: const Text("Engagement"),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.list_rounded),
          onPressed: _buildRequisitionForm,
          label: const Text("Requisition"),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.local_activity_outlined),
          onPressed: _buildActivityForm,
          label: const Text("Activity"),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.class_outlined),
          onPressed: _buildInvoiceDialog,
          label: const Text("Invoice"),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.task_outlined),
          onPressed: _buildTaskForm,
          label: const Text("Task"),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.calendar_month_rounded),
          onPressed: _buildDairyForm,
          label: const Text("Diary"),
        ),
      ],
    );
  }

  Widget _buildPage() {
    return IndexedStack(
      index: _activeTab,
      children: List.generate(
        _barItems().length,
        (index) => _barItems()[index]["page"],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: (Platform.isIOS) ? 80 : 60,
      // formerly 80.
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          _barItems().length,
          (index) {
            if (index == 3) {
              return ValueListenableBuilder(
                  valueListenable:
                      Hive.box<Notifications>('notifications').listenable(),
                  builder: (context, Box<Notifications> box, _) {
                    var unreadNotificationsLength = box.values
                        .where((element) => element.read == false)
                        .length;
                    if (unreadNotificationsLength > 0) {
                      return BottomBarItem(
                        _activeTab == index
                            ? _barItems()[index]["active_icon"]
                            : _barItems()[index]["icon"],
                        _barItems()[index]["name"],
                        showBadge: true,
                        badge: Text(unreadNotificationsLength.toString()),
                        isActive: _activeTab == index,
                        activeColor: AppColors.primary,
                        onTap: () {
                          setState(() {
                            _activeTab = index;
                          });
                        },
                      );
                    }
                    return BottomBarItem(
                      _activeTab == index
                          ? _barItems()[index]["active_icon"]
                          : _barItems()[index]["icon"],
                      _barItems()[index]["name"],
                      isActive: _activeTab == index,
                      activeColor: AppColors.primary,
                      onTap: () {
                        setState(() {
                          _activeTab = index;
                        });
                      },
                    );
                  });
            }
            return BottomBarItem(
              _activeTab == index
                  ? _barItems()[index]["active_icon"]
                  : _barItems()[index]["icon"],
              _barItems()[index]["name"],
              isActive: _activeTab == index,
              activeColor: AppColors.primary,
              onTap: () {
                setState(() {
                  _activeTab = index;
                });
              },
            );
          },
        ),
      ),
    );
  }

  _buildActivityForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      backgroundColor: AppColors.appBgColor,
      builder: (context) => const ActivityForm(),
    );
  }

  _buildRequisitionForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => RequisitionForm(currencies: currencies),
    );
  }

  _buildTaskForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const TaskForm(),
    );
  }

  _buildDairyForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const DiaryForm(),
    );
  }

  _buildInvoiceDialog() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => InvoiceForm(currencies: currencies),
    );
  }

  _buildEngagementForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const EngagementForm(),
    );
  }

  _loadCurrencies() async {
    Map currencyMap = await SmartCaseApi.smartFetch(
        'api/admin/currencytypes', currentUser.token);
    List? currencyList = currencyMap["currencytypes"];
    currencies =
        currencyList!.map((doc) => SmartCurrency.fromJson(doc)).toList();
    currencyList = null;
  }

  _loadApprovers() async {
    Map usersMap = await SmartCaseApi.smartFetch(
        'api/hr/employees/requisitionApprovers', currentUser.token);

    List users = usersMap['search']['employees'];

    preloadedApprovers
        .addAll(users.map((doc) => SmartEmployee.fromJson(doc)).toList());
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // Instantiate NewVersion manager object (Using GCP Console app as example)
    final newVersion = NewVersionPlus(
      iOSId: 'com.infosec.smartCase',
      androidId: 'com.infosec.smartCase',
      androidPlayStoreCountry: "es_ES",
      androidHtmlReleaseNotes: true, //support country code
    );
    advancedStatusCheck(newVersion);

    // currentUser.avatar = currentUserAvatar;

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();

    preloadedRequisitions.clear();

    RequisitionApi.fetchAll();
    ClientApi.fetchAll();
    EngagementTypeApi.fetchAll();
    InvoiceItemApi.fetchAll();
    TaxTypeApi.fetchAll();
    FileApi.fetchAll();
    BankApi.fetchAll();
    InvoiceItemApi.fetchAll();
    InvoiceTypeApi.fetchAll();
    InvoiceApproverApi.fetchAll();
    InvoiceApi.fetchAll();
    _loadApprovers;

    if (preloadedRequisitions.isNotEmpty) {
      flowType = preloadedRequisitions.first.canApprove;
    }

    _checkCanApprove();
    _loadCurrencies();

    super.initState();
  }

  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      if (status.localVersion != status.storeVersion) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: 'Update Available',
          dialogText:
              'Version ${status.storeVersion} is available for download from version '
              '${status.localVersion}. Update your app to keep up with a streamlined and smooth '
              'workflow of the app(Tap any where to dismiss)',
          launchModeVersion: LaunchModeVersion.normal,
          allowDismissal: true,
        );
      }
    }
  }

  _checkCanApprove() async {
    SmartEmployee? approver;
    Map usersMap = await SmartCaseApi.smartFetch(
        'api/hr/employees/requisitionApprovers', currentUser.token);

    List users = usersMap['search']['employees'];

    var approvers = users.map((doc) => SmartEmployee.fromJson(doc)).toList();
    approver =
        approvers.firstWhereOrNull((element) => element.id == currentUser.id);

    if (approver != null) {
      canApprove = true;
    } else {
      canApprove = false;
    }
  }

// It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    String page = message.data['page'];
    if (page.toLowerCase() == "requisition") {
      Navigator.pushNamed(context, '/requisition',
          arguments: message.data['Requisition']);
    }
    if (page.toLowerCase() == "activity") {
      Navigator.pushNamed(context, '/activity',
          arguments:
              ScreenArguments(message.data['File'], message.data['Activity']));
    }
    if (page.toLowerCase() == "event") {
      Navigator.pushNamed(context, '/event', arguments: message.data['Event']);
    }
    // if (page.toLowerCase() == "task") {
    //   Navigator.pushNamed(context, '/task',
    //       arguments: message.data['task']);
    // }
    if (page.toLowerCase() == "file") {
      locator<NavigationService>()
          .navigateWithArgumentsTo("/file", message.data['File']);
    }
  }
}
