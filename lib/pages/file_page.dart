import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smart_case/widgets/file_widget/file_item.dart';

import '../database/file/file_model.dart';
import '../services/apis/smartcase_api.dart';
import '../services/apis/smartcase_apis/file_api.dart';
import '../theme/color.dart';
import '../util/smart_case_init.dart';
import '../widgets/custom_appbar.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController filterController = TextEditingController();

  List<SmartFile> files = List.empty(growable: true);
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
          isNetwork: currentUserImage != null ? true : false,
          searchable: true,
          filterable: true,
          search: 'files',
          filterController: filterController,
          onChanged: _searchFiles,
          filters: filters,
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(
            refresh: CupertinoActivityIndicator(),
            waterDropColor: AppColors.primary),
        footer: CustomFooter(
          builder: (context, mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("more data");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed! Pull up to retry");
            } else if (mode == LoadStatus.noMore) {
              body = const Text("That's all for now");
            } else {
              body = const Text("No more Data");
            }
            return SizedBox(
              height: 15,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        child: _buildBody(),
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        enableTwoLevel: true,
      ),
    );
  }

  _buildBody() {
    return (filteredFiles.isEmpty)
        ? _buildNonSearchedBody()
        : _buildSearchedBody();
  }

  _buildNonSearchedBody() {
    return (files.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: files.length,
            itemBuilder: (context, index) {
              return FileItem(
                fileName: files[index].fileName!,
                fileNumber: files[index].fileNumber!,
                dateCreated: files[index].dateOpened,
                clientName: files[index].clientName!,
                color: Colors.white,
                padding: 20,
                status: files[index].status ?? 'N/A',
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  _buildSearchedBody() {
    return (filteredFiles.isNotEmpty)
        ? ListView.builder(
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
    files = await SmartCaseApi.fetchAllFiles(currentUser.token);
    filterController.text == 'Name';
    setState(() {});
  }

  _searchFiles(String value) {
    filteredFiles.clear();
    if (filterController.text == 'Client') {
      filteredFiles.addAll(files.where((smartFile) =>
          smartFile.clientName!.toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Status') {
      filteredFiles.addAll(files.where((smartFile) =>
          smartFile.status!.toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'File Number') {
      filteredFiles.addAll(files.where((smartFile) =>
          smartFile.fileNumber!.toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'File Number (Court)') {
      filteredFiles.addAll(files.where((smartFile) => smartFile.courtFileNumber!
          .toLowerCase()
          .contains(value.toLowerCase())));
      setState(() {});
    } else {
      filteredFiles.addAll(files.where((smartFile) =>
          smartFile.getName().toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    }
  }

  void _onRefresh() async {
    FileApi.fetchAll()
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
    FileApi.fetchAll()
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
