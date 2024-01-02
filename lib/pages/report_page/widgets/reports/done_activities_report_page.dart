import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/reports/models/done_activities_report.dart';
import 'package:smart_case/pages/activity_page/widgets/activity_form.dart';
import 'package:smart_case/pages/report_page/widgets/reports/widgets/done_activity_report_item.dart';
import 'package:smart_case/services/apis/smartcase_apis/activity_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/done_activities_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class DoneActivitiesReportPage extends StatefulWidget {
  const DoneActivitiesReportPage({super.key});

  @override
  State<DoneActivitiesReportPage> createState() =>
      _DoneActivitiesReportPageState();
}

class _DoneActivitiesReportPageState extends State<DoneActivitiesReportPage> {
  TextEditingController filterController = TextEditingController();
  bool _doneLoading = false;
  String? searchText;

  List<SmartDoneActivityReport> filteredDoneActivities =
      List.empty(growable: true);
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
          search: 'done activities',
          filterController: filterController,
          onChanged: (search) {
            _searchDoneActivitiesReport(search);
            searchText = search;
          },
          filters: filters,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buildDoneActivitiesReportForm,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
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
    return (filteredDoneActivities.isEmpty)
        ? _buildNonSearchedBody()
        : _buildSearchedBody();
  }

  _buildNonSearchedBody() {
    return (preloadedDoneActivities.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: preloadedDoneActivities.length,
            itemBuilder: (context, index) => DoneActivityReportItem(
              doneActivity: preloadedDoneActivities.elementAt(index),
            ),
          )
        : (_doneLoading && preloadedDoneActivities.isEmpty)
            ? const Center(
                child: Text(
                  "You currently have no done activities",
                  style: TextStyle(color: AppColors.inActiveColor),
                ),
              )
            : const Center(
                child: CupertinoActivityIndicator(radius: 20),
              );
  }

  _buildSearchedBody() {
    return (filteredDoneActivities.isNotEmpty)
        ? SearchTextInheritedWidget(
            searchText: searchText,
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 10,
                top: 16,
                right: 10,
                bottom: 80,
              ),
              itemCount: filteredDoneActivities.length,
              itemBuilder: (context, index) => DoneActivityReportItem(
                doneActivity: filteredDoneActivities.elementAt(index),
              ),
            ),
          )
        : const Center(
            child: Text('No result found'),
          );
  }

  @override
  void initState() {
    super.initState();

    _setUpData();
  }

  Future<void> _setUpData() async {
    await DoneActivitiesApi.fetchAll().then((value) {
      _doneLoading = true;
      setState(() {});
    }).onError((error, stackTrace) {
      _doneLoading = true;
            Fluttertoast.showToast(
                msg: "An error occurred",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                backgroundColor: AppColors.red,
                textColor: AppColors.white,
                fontSize: 16.0);
      if (mounted) setState(() {});
    });
    filterController.text == 'Name';
    if (mounted) setState(() {});
  }

  _searchDoneActivitiesReport(String value) {
    filteredDoneActivities.clear();
    filteredDoneActivities.addAll(preloadedDoneActivities.where(
        (doneActivity) =>
            doneActivity.lockedBy!
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            doneActivity.notifyClient!
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            doneActivity.date
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            doneActivity.caseFile
                .getName()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            doneActivity.employee!
                .getName()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            doneActivity.caseActivityStatus
                .getName()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            doneActivity.date.toString().contains(value.toLowerCase())));
    setState(() {});
  }

  Future<void> _onRefresh() async {
    await ActivityApi.fetchAll().then((value) {
      _doneLoading = true;
      setState(() {});
    }).onError((error, stackTrace) {
      _doneLoading = true;
            Fluttertoast.showToast(
                msg: "An error occurred",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                backgroundColor: AppColors.red,
                textColor: AppColors.white,
                fontSize: 16.0);
      setState(() {});
    });
  }

  _buildDoneActivitiesReportForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const ActivityForm(),
    );
  }
}
