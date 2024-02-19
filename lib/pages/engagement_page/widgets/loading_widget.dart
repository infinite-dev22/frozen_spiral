import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String>? filters = [
      "Client",
      "Type",
      "Cost",
      "Done By",
      "Description (Cost)",
      "Date",
    ];

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
          readOnly: true,
          search: 'engagements',
          filters: filters,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return const Center(
      child: CupertinoActivityIndicator(radius: 20),
    );
  }
}
