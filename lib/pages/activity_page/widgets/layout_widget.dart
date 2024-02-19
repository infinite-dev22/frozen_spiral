import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/pages/activity_page/bloc/activity_bloc.dart';
import 'package:smart_case/pages/activity_page/widgets/activity_barrel.dart';

class LayoutWidget extends StatelessWidget {
  const LayoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivityBloc, ActivityState>(
      listener: (context, state) {
        // TODO: implement listener}
      },
      child: _buildBody(),
    );
  }

  _buildBody() {
    print(preloadedActivities.length);
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        if (state.status == ActivityStatus.initial) {
          if (context.read<ActivityBloc>().state.activities!.isEmpty) {
            context.read<ActivityBloc>().add(GetActivitiesEvent());
          } else if (context
              .read<ActivityBloc>()
              .state
              .activities!
              .isNotEmpty) {
            return SuccessWidget();
          }
        }
        if (state.status == ActivityStatus.loading) {
          return LoadingWidget();
        }
        if (state.status == ActivityStatus.noData) {
          return NoDataWidget();
        }
        if (state.status == ActivityStatus.success) {
          return SuccessWidget();
        }
        if (state.status == ActivityStatus.notFound) {
          return NotFoundWidget(searchString: state.searchString!);
        }
        return ActivityErrorWidget();
      },
    );
  }
}
