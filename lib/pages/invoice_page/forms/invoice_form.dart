import 'package:flutter/material.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_form_layout.dart';

class InvoiceForm extends StatelessWidget {
  final List<SmartCurrency> currencies;

  const InvoiceForm({super.key, required this.currencies});

  @override
  Widget build(BuildContext context) {
    return InvoiceFormLayout(currencies: currencies);
  }
}
