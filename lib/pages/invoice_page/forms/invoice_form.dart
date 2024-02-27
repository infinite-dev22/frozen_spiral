import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/pages/invoice_page/bloc/forms/invoice/invoice_form_bloc.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_form_layout.dart';

class InvoiceForm extends StatelessWidget {
  const InvoiceForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<InvoiceFormBloc>(
        create: (context) => InvoiceFormBloc(),
      )
    ], child: InvoiceFormLayout());
  }
}
