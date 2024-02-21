import 'package:flutter/material.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/actions_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/bank_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/info_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/items_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/to_widget.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/form_title.dart';

class InvoiceViewLayout extends StatelessWidget {
  const InvoiceViewLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Scaffold(
      floatingActionButton: SizedBox(height: 110, child: ActionsWidget()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: AppColors.transparent,
      body: Column(
        children: [
          FormTitle(
            name: 'Invoice',
            addButtonText: 'Edit',
            onSave: () {},
            isElevated: true,
          ),
          Expanded(
            child: ListView(
              children: [
                InfoWidget(),
                ToWidget(),
                BankWidget(),
                ItemsWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
