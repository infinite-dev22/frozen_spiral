import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/requisition_page/bloc/requisition_bloc.dart';
import 'package:smart_case/pages/requisition_page/widgets/filtered_requisitions_success_widget.dart';

class RequisitionWidget extends StatelessWidget {
  const RequisitionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequisitionBloc, RequisitionState>(
      buildWhen: (previous, current) => current.status.isSuccess,
      builder: (context, state) => const FilteredRequisitionsWidget(),
    );
  }
}
