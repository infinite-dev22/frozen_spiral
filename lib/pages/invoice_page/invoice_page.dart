import 'package:flutter/material.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_item_widget.dart';
import 'package:smart_case/theme/color.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => InvoiceItemWidget(
              color: AppColors.white,
              padding: 10,
              invoice: new SmartInvoice(),
            ),
            childCount: 16,
          ),
        ),
      ],
    );
  }
}
