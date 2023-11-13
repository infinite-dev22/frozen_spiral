import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smart_case/widgets/file_widget/file_item.dart';

import '../database/file/file_model.dart';
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
    files = await FileApi.fetchAll();
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

  Future<void> _onRefresh() async {
    await FileApi.fetchAll();
  }
}
