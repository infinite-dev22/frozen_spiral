import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/engagement_page/bloc/engagement_bloc.dart';
import 'package:smart_case/pages/engagement_page/widgets/engagement_barrel.dart';

class LayoutWidget extends StatelessWidget {
  const LayoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EngagementBloc, EngagementState>(
      listener: (context, state) {
        // TODO: implement listener}
      },
      child: _buildBody(),
    );
  }

  _buildBody() {
    return BlocBuilder<EngagementBloc, EngagementState>(
      builder: (context, state) {
        if (state.status == EngagementStatus.initial) {
          if (context.read<EngagementBloc>().state.engagements!.isEmpty) {
            context.read<EngagementBloc>().add(GetEngagementsEvent());
          } else if (context
              .read<EngagementBloc>()
              .state
              .engagements!
              .isNotEmpty) {
            return const SuccessWidget();
          }
        }
        if (state.status == EngagementStatus.loading) {
          return const LoadingWidget();
        }
        if (state.status == EngagementStatus.noData) {
          return const NoDataWidget();
        }
        if (state.status == EngagementStatus.success) {
          return const SuccessWidget();
        }
        if (state.status == EngagementStatus.notFound) {
          return NotFoundWidget(searchString: state.searchString!);
        }
        return const EngagementErrorWidget();
      },
    );
  }
}
