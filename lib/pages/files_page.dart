import 'package:flutter/material.dart';
import 'package:smart_case/widgets/file/file_item.dart';

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
  List<SmartFile> files = List.empty(growable: true);

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
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 10,
        top: 16,
        right: 10,
        bottom: 80,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        return FileItem(
          fileName: files[index].fileName,
          fileNumber: files[index].fileNumber,
          dateCreated: files[index].dateOpened,
          clientName: files[index].clientName,
          color: Colors.white,
          padding: 20,
          status: files[index].status!,
        );
      },
    );
  }

  @override
  void initState() {
    _setUpData();

    super.initState();
  }

  Future<void> _setUpData() async {
    files = await SmartCaseApi.fetchAllFiles(currentUser.token);
    setState(() {});
  }
}
