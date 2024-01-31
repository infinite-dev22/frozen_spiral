import 'package:flutter/material.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_items_form_layout.dart';

class InvoiceItemsForm extends StatefulWidget {
  const InvoiceItemsForm({super.key});

  @override
  State<InvoiceItemsForm> createState() => _InvoiceItemsFormState();
}

class _InvoiceItemsFormState extends State<InvoiceItemsForm> {
  @override
  Widget build(BuildContext context) {
    return const InvoiceItemsFormLayout();
  }
}
