import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/data/global_data.dart';
import 'package:smart_case/widgets/file_widget/file_item.dart';

import '../database/file/file_model.dart';
import '../services/apis/smartcase_apis/file_api.dart';
import '../theme/color.dart';
import '../util/smart_case_init.dart';
import '../widgets/better_toast.dart';
import '../widgets/custom_appbar.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  TextEditingController filterController = TextEditingController();
  bool _doneLoading = false;
  String? searchText;
  Timer? _timer;

  List<SmartFile> filteredFiles = List.empty(growable: true);
  final List<String>? filters = [
    "Name",
    "Client",
    "Status",
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
          search: 'files',
          filterController: filterController,
          onChanged: (search) {
            _searchFiles(search);
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
    );
  }

  _buildBody() {
    return (filteredFiles.isEmpty)
        ? _buildNonSearchedBody()
        : _buildSearchedBody();
  }

  _buildNonSearchedBody() {
    return (preloadedFiles.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: preloadedFiles.length,
            itemBuilder: (context, index) {
              return FileItem(
                fileName: preloadedFiles[index].fileName!,
                fileNumber: preloadedFiles[index].fileNumber!,
                dateCreated: preloadedFiles[index].dateOpened,
                clientName: preloadedFiles[index].clientName!,
                color: Colors.white,
                padding: 20,
                status: preloadedFiles[index].status ?? 'N/A',
              );
            },
          )
        : (_doneLoading && preloadedFiles.isEmpty)
            ? const Center(
                child: Text(
                  "Your files appear here",
                  style: TextStyle(color: AppColors.inActiveColor),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
  }

  _buildSearchedBody() {
    return (filteredFiles.isNotEmpty)
        ? SearchTextInheritedWidget(
            searchText: searchText,
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 10,
                top: 16,
                right: 10,
                bottom: 80,
              ),
              itemCount: filteredFiles.length,
              itemBuilder: (context, index) {
                return FileItem(
                  fileName: filteredFiles[index].fileName!,
                  fileNumber: filteredFiles[index].fileNumber!,
                  dateCreated: filteredFiles[index].dateOpened,
                  clientName: filteredFiles[index].clientName!,
                  color: Colors.white,
                  padding: 20,
                  status: filteredFiles[index].status ?? "N/A",
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
    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        FileApi.fetchAll();
        // _buildFilteredList();
        setState(() {});
      });
    }
  }

  Future<void> _setUpData() async {
    await FileApi.fetchAll().then((value) {
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

  _searchFiles(String value) {
    filteredFiles.clear();
    filteredFiles.addAll(preloadedFiles.where((smartFile) =>
        smartFile.getName()
            .toLowerCase()
            .contains(value.toLowerCase()) ||
        smartFile.fileNumber!
            .toLowerCase()
            .contains(value.toLowerCase()) ||
        smartFile.clientName!
            .toLowerCase()
            .contains(value.toLowerCase()) ||
        smartFile.dateOpened!
            .toLowerCase()
            .contains(value.toLowerCase()) ||
        (smartFile.status ?? "N/A")
            .toLowerCase()
            .contains(value.toLowerCase())));
    setState(() {});
  }

  Future<void> _onRefresh() async {
    await FileApi.fetchAll().then((value) {
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

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }

    super.dispose();
  }
}
