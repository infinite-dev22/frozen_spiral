import 'package:flutter/material.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_items_form_layout.dart';

class InvoiceItemsForm extends StatelessWidget {
  final BuildContext parentContext;

  const InvoiceItemsForm({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return InvoiceItemsFormLayout(grandParentContext: parentContext);
  }
}
