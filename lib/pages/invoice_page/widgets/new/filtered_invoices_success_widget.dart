import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/invoice_page/bloc/invoice_bloc.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_item.dart';
import 'package:smart_case/theme/color.dart';

class FilteredInvoicesWidget extends StatelessWidget {
  const FilteredInvoicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.invoices.length,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return InvoiceItemWidget(
              color: AppColors.white,
              padding: 10,
              invoice: state.invoices.elementAt(index),
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
