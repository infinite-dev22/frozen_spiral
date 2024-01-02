import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/reports/models/cause_list_report.dart';
import 'package:smart_case/pages/report_page/widgets/reports/widgets/cause_list_report_item.dart';
import 'package:smart_case/services/apis/smartcase_apis/cause_list_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class CauseListReportPage extends StatefulWidget {
  const CauseListReportPage({super.key});

  @override
  State<CauseListReportPage> createState() => _CauseListReportPageState();
}

class _CauseListReportPageState extends State<CauseListReportPage> {
  TextEditingController filterController = TextEditingController();
  bool _doneLoading = false;
  String? searchText;

  List<SmartCauseListReport> filteredCauseListReport =
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
          search: 'cause lists',
          filterController: filterController,
          onChanged: (search) {
            _searchCauseListReport(search);
            searchText = search;
          },
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
    return (filteredCauseListReport.isEmpty)
        ? _buildNonSearchedBody()
        : _buildSearchedBody();
  }

  _buildNonSearchedBody() {
    return (preloadedCauseList.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: preloadedCauseList.length,
            itemBuilder: (context, index) {
              return CauseListReportItem(
                causeReport: preloadedCauseList.elementAt(index),
              );
            },
          )
        : (_doneLoading && preloadedCauseList.isEmpty)
            ? const Center(
                child: Text(
                  "You currently have no cause lists",
                  style: TextStyle(color: AppColors.inActiveColor),
                ),
              )
            : const Center(
                child: CupertinoActivityIndicator(radius: 20),
              );
  }

  _buildSearchedBody() {
    return (filteredCauseListReport.isNotEmpty)
        ? SearchTextInheritedWidget(
            searchText: searchText,
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 10,
                top: 16,
                right: 10,
                bottom: 80,
              ),
              itemCount: filteredCauseListReport.length,
              itemBuilder: (context, index) {
                return CauseListReportItem(
                  causeReport: filteredCauseListReport.elementAt(index),
                );
              },
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
    CauseListApi.fetchAll().then((value) {
      _doneLoading = true;
      setState(() {});
    }).onError((error, stackTrace) {
      print(error);
      debugPrintStack(stackTrace: stackTrace);
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

  _searchCauseListReport(String value) {
    filteredCauseListReport.clear();
    filteredCauseListReport.addAll(preloadedCauseList.where(
        (smartCauseListReport) =>
            smartCauseListReport.fileName!
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartCauseListReport.fileNumber!
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartCauseListReport.title!
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            (smartCauseListReport.court?.name ?? "N/A")
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartCauseListReport.toBeDoneBy!
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartCauseListReport.partners!.first
                .getName()
                .toString()
                .contains(value.toLowerCase())));
    setState(() {});
  }

  Future<void> _onRefresh() async {
    CauseListApi.fetchAll().then((value) {
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
}
