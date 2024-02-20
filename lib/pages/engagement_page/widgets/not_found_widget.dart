import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/engagement_page/bloc/engagement_bloc.dart';
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
        text: context.read<EngagementBloc>().state.searchString ?? "");

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
          filterController: filterController,
          searchController: searchController,
          search: 'engagements',
          onChanged: (search) {
            context.read<EngagementBloc>().add(SearchEngagementEvent(search));
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
        "No engagement found for search \"$searchString\"",
        style: const TextStyle(color: AppColors.inActiveColor),
      ),
    );
  }
}
