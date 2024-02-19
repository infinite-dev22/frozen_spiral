import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/engagement_page/bloc/engagement_bloc.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class EngagementErrorWidget extends StatelessWidget {
  const EngagementErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          isNetwork: currentUser.avatar != null ? true : false,
          searchable: false,
          filterable: false,
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
            Text(
              "An error occurred whilst loading your activities",
              style: TextStyle(color: AppColors.red),
            ),
            const SizedBox(height: 36),
            FilledButton(
              onPressed: () => _onRefresh(context),
              child: Text("Try Again"),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.primary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<EngagementBloc>().add(GetEngagementsEvent());
  }
}
