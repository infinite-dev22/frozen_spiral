import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/requisition_page/bloc/requisition_bloc.dart';
import 'package:smart_case/pages/requisition_page/widgets/requisition_item.dart';
import 'package:smart_case/theme/color.dart';

class FilteredRequisitionsWidget extends StatelessWidget {
  const FilteredRequisitionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return BlocBuilder<RequisitionBloc, RequisitionState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.requisitions.length,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return RequisitionItem(
              color: AppColors.white,
              padding: 10,
              requisition: state.requisitions.elementAt(index),
              currencies: state.currencies,
              showActions: true,
              showFinancialStatus: true,
            );
          },
        );
      },
    );
  }
}
