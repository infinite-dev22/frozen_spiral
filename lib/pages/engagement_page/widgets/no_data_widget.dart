import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/engagement_page/bloc/engagement_bloc.dart';
import 'package:smart_case/pages/engagement_page/forms/engagements_form.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

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
          search: 'engagements',
          filters: filters,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "engagements_success$key",
        onPressed: () => _buildEngagementsForm(context),
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return LayoutBuilder(builder: (context, constraint) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No Engagements available currently",
              style: TextStyle(color: AppColors.inActiveColor, fontSize: 18),
            ),
            Text(
              "Click refresh to get new engagements or",
              style: TextStyle(color: AppColors.inActiveColor),
            ),
            Text(
              "the \"+\" button to add an engagement",
              style: TextStyle(color: AppColors.inActiveColor),
            ),
            const SizedBox(height: 30),
            FilledButton(
                onPressed: () =>
                    context.read<EngagementBloc>().add(GetEngagementsEvent()),
                child: Text("Refresh"))
          ],
        ),
      );
    });
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
