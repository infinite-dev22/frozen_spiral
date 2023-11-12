import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/activity_widget/activity_item.dart';

import '../services/apis/smartcase_apis/activity_api.dart';
import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController filterController = TextEditingController();

  List<SmartActivity> activities = List.empty(growable: true);
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
          isNetwork: currentUserImage != null ? true : false,
          searchable: true,
          filterable: true,
          search: 'activities',
          filterController: filterController,
          onChanged: _searchActivities,
          filters: filters,
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        header: const WaterDropHeader(
            refresh: CupertinoActivityIndicator(),
            waterDropColor: AppColors.primary),
        // footer: CustomFooter(
        //   height: 0,
        //   builder: (context, mode) {
        //     Widget body;
        //     if (mode == LoadStatus.idle) {
        //       body = const Text("more data");
        //     } else if (mode == LoadStatus.loading) {
        //       body = const CupertinoActivityIndicator();
        //     } else if (mode == LoadStatus.failed) {
        //       body = const Text("Load Failed! Pull up to retry");
        //     } else if (mode == LoadStatus.noMore) {
        //       body = const Text("That's all for now");
        //     } else {
        //       body = const Text("No more Data");
        //     }
        //     return SizedBox(
        //       height: 15,
        //       child: Center(child: body),
        //     );
        //   },
        // ),
        controller: _refreshController,
        child: _buildBody(),
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        enableTwoLevel: true,
      ),
    );
  }

  _buildBody() {
    return (filteredActivities.isEmpty)
        ? _buildNonSearchedBody()
        : _buildSearchedBody();
  }

  _buildNonSearchedBody() {
    return (activities.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return ActivityItem(
                activity: activities[index],
                padding: 20,
                color: Colors.white,
              );
            },
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
    activities = await SmartCaseApi.fetchAllActivities(currentUser.token);
    filterController.text == 'Name';
    setState(() {});
  }

  _searchActivities(String value) {
    filteredActivities.clear();
    if (filterController.text == 'File Name') {
      filteredActivities.addAll(activities.where((smartActivity) =>
          smartActivity.file!
              .getName()
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'File Number') {
      filteredActivities.addAll(activities.where((smartActivity) =>
          smartActivity.fileNumber!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'File Number (Court)') {
      filteredActivities.addAll(activities.where((smartActivity) =>
          smartActivity.courtFileNumber!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else {
      filteredActivities.addAll(activities.where((smartActivity) =>
          smartActivity.getName().toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    }
  }

  void _onRefresh() async {
    ActivityApi.fetchAll()
        .then((value) => {
              _refreshController.refreshCompleted(),
              if (mounted) setState(() {})
            })
        .onError((error, stackTrace) => {
              _refreshController.refreshFailed(),
              if (mounted) setState(() {}),
            });
  }

  void _onLoading() async {
    ActivityApi.fetchAll()
        .then((value) => {
              if (value.isNotEmpty)
                _refreshController.loadComplete()
              else if (value.isEmpty)
                _refreshController.loadNoData(),
              if (mounted) setState(() {})
            })
        .onError((error, stackTrace) => {
              _refreshController.loadFailed(),
              if (mounted) setState(() {}),
            });
  }
}
