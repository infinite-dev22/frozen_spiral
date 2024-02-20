import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            return const SuccessWidget();
          }
        }
        if (state.status == ActivityStatus.loading) {
          return const LoadingWidget();
        }
        if (state.status == ActivityStatus.noData) {
          return const NoDataWidget();
        }
        if (state.status == ActivityStatus.success) {
          return const SuccessWidget();
        }
        if (state.status == ActivityStatus.notFound) {
          return NotFoundWidget(searchString: state.searchString!);
        }
        return const ActivityErrorWidget();
      },
    );
  }
}
