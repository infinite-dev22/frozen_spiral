import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/activity_page/bloc/activity_bloc.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class ActivityErrorWidget extends StatelessWidget {
  const ActivityErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> filters = [
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
          search: 'activities',
          filters: filters,
        ),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "An error occurred whilst loading your activities",
              style: TextStyle(color: AppColors.red),
            ),
            const SizedBox(height: 36),
            FilledButton(
              onPressed: () => _onRefresh(context),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.primary),
              ),
              child: const Text("Try Again"),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<ActivityBloc>().add(GetActivitiesEvent());
  }
}
