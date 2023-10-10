import 'package:flutter/material.dart';
import 'package:smart_case/widgets/file/file_item.dart';

import '../data/data.dart';
import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class FilesPage extends StatelessWidget {
  const FilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppBarContent(
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
          fileName: files[index]['name'],
          fileNumber: files[index]['number'],
          dateCreated: files[index]['date'],
          clientName: files[index]['client'],
          color: Colors.white,
          padding: 20,
        );
      },
    );
  }
}
