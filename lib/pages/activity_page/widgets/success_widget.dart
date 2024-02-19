import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/pages/activity_page/bloc/activity_bloc.dart';
import 'package:smart_case/pages/activity_page/forms/activity_form.dart';
import 'package:smart_case/pages/activity_page/widgets/item_widget.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({super.key});

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
          search: 'activities',
          filterController: filterController,
          searchController: searchController,
          onChanged: (search) {
            context.read<ActivityBloc>().add(SearchActivityEvent(search));
          },
          filters: filters,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "activity_success${this.key}",
        onPressed: () => _buildActivitiesForm(context),
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        child: _buildBody(context),
        onRefresh: () => _onRefresh(context),
        color: AppColors.primary,
        backgroundColor: AppColors.white,
      ),
    );
  }

  _buildBody(BuildContext context) {
    return SearchTextInheritedWidget(
      searchText: context.read<ActivityBloc>().state.searchString ?? "",
      child: ListView.builder(
        padding: const EdgeInsets.only(
          left: 10,
          top: 16,
          right: 10,
          bottom: 80,
        ),
        itemCount: context.read<ActivityBloc>().state.activities!.length,
        itemBuilder: (context, index) {
          return ItemWidget(
            activity: context.read<ActivityBloc>().state.activities![index],
            padding: 20,
            color: Colors.white,
            onTap: () => Navigator.pushNamed(
              context,
              '/activity',
              arguments: context.read<ActivityBloc>().state.activities![index],
            ),
          );
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<ActivityBloc>().add(GetActivitiesEvent());
  }

  Future _buildActivitiesForm(BuildContext context) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const ActivityForm(),
    );
  }
}
