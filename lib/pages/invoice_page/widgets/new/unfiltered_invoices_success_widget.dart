import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/pages/invoice_page/bloc/invoice_bloc.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_item.dart';
import 'package:smart_case/theme/color.dart';

class UnfilteredInvoicesWidget extends StatelessWidget {
  final List<SmartInvoice> invoices;
  final List<SmartCurrency> currencies;

  const UnfilteredInvoicesWidget(
      {super.key, required this.invoices, required this.currencies});

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
            return InvoiceItem(
              color: AppColors.white,
              padding: 10,
              invoice: state.invoices.elementAt(index),
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
    //     itemBuilder: (context, index) => const InvoiceShimmer(),
    //   );
    // }
  }
}
