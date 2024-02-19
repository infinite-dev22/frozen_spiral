import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/engagement_page/bloc/engagement_bloc.dart';
import 'package:smart_case/pages/engagement_page/forms/engagements_form.dart';
import 'package:smart_case/pages/engagement_page/widgets/item_widget.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController filterController = TextEditingController();
    TextEditingController searchController = TextEditingController(
        text: context.read<EngagementBloc>().state.searchString ?? "");

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
          search: 'engagements',
          filterController: filterController,
          searchController: searchController,
          onChanged: (search) {
            context.read<EngagementBloc>().add(SearchEngagementEvent(search));
          },
          filters: filters,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "engagements_success${this.key}",
        onPressed: () => _buildEngagementsForm(context),
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
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 10,
        top: 16,
        right: 10,
        bottom: 80,
      ),
      itemCount: context.read<EngagementBloc>().state.engagements!.length,
      itemBuilder: (context, index) {
        return ItemWidget(
          engagement: context.read<EngagementBloc>().state.engagements![index],
        );
      },
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<EngagementBloc>().add(GetEngagementsEvent());
  }

  Future _buildEngagementsForm(BuildContext context) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const EngagementForm(),
    );
  }
}
