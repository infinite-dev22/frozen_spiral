import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/activity_page/bloc/activity_bloc.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class NotFoundWidget extends StatelessWidget {
  final String searchString;

  const NotFoundWidget({super.key, required this.searchString});

  @override
  Widget build(BuildContext context) {
    TextEditingController filterController = TextEditingController();
    TextEditingController searchController = TextEditingController(
        text: context.read<ActivityBloc>().state.searchString ?? "");

    final List<String>? filters = [
      "Name",
      "File Name",
      "File Number",
      "File Number (Court)",
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
          filterController: filterController,
          searchController: searchController,
          search: 'activities',
          onChanged: (search) {
            context.read<ActivityBloc>().add(SearchActivityEvent(search));
          },
          filters: filters,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Center(
      child: Text(
        "No activity found for search \"$searchString\"",
        style: TextStyle(color: AppColors.inActiveColor),
      ),
    );
  }
}
