import 'package:flutter/material.dart';
import 'package:smart_case/widgets/file_widget/file_item.dart';

import '../models/smart_file.dart';
import '../services/apis/smartcase_api.dart';
import '../theme/color.dart';
import '../util/smart_case_init.dart';
import '../widgets/custom_appbar.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  TextEditingController filterController = TextEditingController();

  List<SmartFile> files = List.empty(growable: true);
  List<SmartFile> filteredFiles = List.empty(growable: true);

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
        ),
      ),
      body: _buildBody(),
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
            itemCount:
                filteredFiles.isNotEmpty ? filteredFiles.length : files.length,
            itemBuilder: (context, index) {
              return FileItem(
                fileName: filteredFiles.isNotEmpty
                    ? filteredFiles[index].fileName!
                    : files[index].fileName!,
                fileNumber: filteredFiles.isNotEmpty
                    ? filteredFiles[index].fileNumber!
                    : files[index].fileNumber!,
                dateCreated: filteredFiles.isNotEmpty
                    ? filteredFiles[index].dateOpened
                    : files[index].dateOpened,
                clientName: filteredFiles.isNotEmpty
                    ? filteredFiles[index].clientName!
                    : files[index].clientName!,
                color: Colors.white,
                padding: 20,
                status: filteredFiles.isNotEmpty
                    ? filteredFiles[index].status!
                    : files[index].status!,
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
                status: filteredFiles[index].status!,
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
    if (filterController.text == 'Name') {
      filteredFiles.addAll(files.where((smartFile) =>
          smartFile.getName().toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    }
  }
}
