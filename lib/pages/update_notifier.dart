import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_upgrade_version/flutter_upgrade_version.dart';

class UpdateNotifier extends StatefulWidget {
  const UpdateNotifier({super.key});

  @override
  State<UpdateNotifier> createState() => _UpdateNotifierState();
}

class _UpdateNotifierState extends State<UpdateNotifier> {
  PackageInfo _packageInfo = PackageInfo();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getPackageData() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    _packageInfo = await PackageManager.getPackageInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody()();
  }

  _buildBody() async {
    // Locale myLocale = Localizations.localeOf(context);
    // print('LOCALE: ${myLocale.languageCode} || ${myLocale.countryCode}');
    if (Platform.isAndroid) {
      InAppUpdateManager manager = InAppUpdateManager();
      AppUpdateInfo? appUpdateInfo = await manager.checkForUpdate();
      if (appUpdateInfo == null) return;
      if (appUpdateInfo.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress) {
        //If an in-app update is already running, resume the update.
        String? message =
            await manager.startAnUpdate(type: AppUpdateType.immediate);
        debugPrint(message ?? '');
      } else if (appUpdateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        ///Update available
        if (appUpdateInfo.immediateAllowed) {
          String? message =
              await manager.startAnUpdate(type: AppUpdateType.immediate);
          debugPrint(message ?? '');
        } else if (appUpdateInfo.flexibleAllowed) {
          String? message =
              await manager.startAnUpdate(type: AppUpdateType.flexible);
          debugPrint(message ?? '');
        } else {
          debugPrint(
              'Update available. Immediate & Flexible Update Flow not allow');
        }
      }
    } else if (Platform.isIOS) {
      VersionInfo? _versionInfo = await UpgradeVersion.getiOSStoreVersion(
          packageInfo: _packageInfo, regionCode: "US");
      debugPrint(_versionInfo.toJson().toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getPackageData();
  }
}
