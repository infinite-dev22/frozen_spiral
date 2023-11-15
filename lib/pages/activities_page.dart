import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:smart_case/data/global_data.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/activity_widget/activity_item.dart';

import '../services/apis/smartcase_apis/activity_api.dart';
import '../theme/color.dart';
import '../widgets/better_toast.dart';
import '../widgets/custom_appbar.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  TextEditingController filterController = TextEditingController();
  bool _doneLoading = false;

  List<SmartActivity> filteredActivities = List.empty(growable: true);
  final List<String>? filters = [
    "Name",
    "File Name",
    "File Number",
    "File Number (Court)",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          isNetwork: currentUser.avatar != null ? true : false,
          searchable: true,
          filterable: true,
          search: 'activities',
          filterController: filterController,
          onChanged: _searchActivities,
          filters: filters,
        ),
      ),
      body: LiquidPullToRefresh(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        child: _buildBody(),
        showChildOpacityTransition: false,
      ),
      // SmartRefresher(
      //   enablePullDown: true,
      //   header: const WaterDropHeader(
      //       refresh: CupertinoActivityIndicator(),
      //       waterDropColor: AppColors.primary),
      //   // footer: CustomFooter(
      //   //   height: 0,
      //   //   builder: (context, mode) {
      //   //     Widget body;
      //   //     if (mode == LoadStatus.idle) {
      //   //       body = const Text("more data");
      //   //     } else if (mode == LoadStatus.loading) {
      //   //       body = const CupertinoActivityIndicator();
      //   //     } else if (mode == LoadStatus.failed) {
      //   //       body = const Text("Load Failed! Pull up to retry");
      //   //     } else if (mode == LoadStatus.noMore) {
      //   //       body = const Text("That's all for now");
      //   //     } else {
      //   //       body = const Text("No more Data");
      //   //     }
      //   //     return SizedBox(
      //   //       height: 15,
      //   //       child: Center(child: body),
      //   //     );
      //   //   },
      //   // ),
      //   controller: _refreshController,
      //   child: _buildBody(),
      //   onLoading: _onLoading,
      //   onRefresh: _onRefresh,
      //   enableTwoLevel: true,
      // ),
    );
  }

  _buildBody() {
    return (filteredActivities.isEmpty)
        ? _buildNonSearchedBody()
        : _buildSearchedBody();
  }

  _buildNonSearchedBody() {
    return (_doneLoading && preloadedActivities.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: preloadedActivities.length,
            itemBuilder: (context, index) {
              return ActivityItem(
                activity: preloadedActivities[index],
                padding: 20,
                color: Colors.white,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/activity',
                  arguments: preloadedActivities[index],
                ),
              );
            },
          )
        : (_doneLoading && preloadedActivities.isEmpty)
            ? const Center(
                child: Text(
                  "Your activities appear here",
                  style: TextStyle(color: AppColors.inActiveColor),
                ),
              )
            : const Center(
                child: CupertinoActivityIndicator(radius: 20),
              );
  }

  _buildSearchedBody() {
    return (filteredActivities.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: filteredActivities.length,
            itemBuilder: (context, index) {
              return ActivityItem(
                activity: filteredActivities[index],
                padding: 20,
                color: Colors.white,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/activity',
                  arguments: filteredActivities[index],
                ),
              );
            },
          )
        : const Center(
            child: Text('No result found'),
          );
  }

  @override
  void initState() {
    _setUpData();

    super.initState();
  }

  Future<void> _setUpData() async {
    await ActivityApi.fetchAll().then((value) {
      _doneLoading = true;
      setState(() {});
    }).onError((error, stackTrace) {
      _doneLoading = true;
      const BetterErrorToast(
        text: "An error occurred",
      );
      setState(() {});
    });
    filterController.text == 'Name';
    setState(() {});
  }

  _searchActivities(String value) {
    filteredActivities.clear();
    if (filterController.text == 'File Name') {
      filteredActivities.addAll(preloadedActivities.where((smartActivity) =>
          smartActivity.file!
              .getName()
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'File Number') {
      filteredActivities.addAll(preloadedActivities.where((smartActivity) =>
          smartActivity.fileNumber!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'File Number (Court)') {
      filteredActivities.addAll(preloadedActivities.where((smartActivity) =>
          smartActivity.courtFileNumber!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else {
      filteredActivities.addAll(preloadedActivities.where((smartActivity) =>
          smartActivity.getName().toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    }
  }

  Future<void> _onRefresh() async {
    await ActivityApi.fetchAll().then((value) {
      _doneLoading = true;
      setState(() {});
    }).onError((error, stackTrace) {
      _doneLoading = true;
      const BetterErrorToast(
        text: "An error occurred",
      );
      setState(() {});
    });
  }
}
