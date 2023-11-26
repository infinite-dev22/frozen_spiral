import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/models/smart_currency.dart';
import 'package:smart_case/widgets/requisition_widget/requisition_item.dart';

import '../../database/requisition/requisition_model.dart';
import '../../theme/color.dart';
import 'bloc/requisition_bloc.dart';

class UnfilteredRequisitionsWidget extends StatelessWidget {
  final List<SmartRequisition> requisitions;
  final List<SmartCurrency> currencies;

  const UnfilteredRequisitionsWidget(
      {Key? key, required this.requisitions, required this.currencies})
      : super(key: key);

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
              currencies: currencies,
              showActions: true,
              showFinancialStatus: true,
            );
          },
        );
      },
    );
    // } else {
    //   return ListView.builder(
    //     itemCount: 3,
    //     padding: const EdgeInsets.all(10),
    //     itemBuilder: (context, index) => const RequisitionShimmer(),
    //   );
    // }
  }
}
