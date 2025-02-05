import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/database/bank/bank_model.dart';
import 'package:smart_case/database/client/client_model.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/database/invoice/invoice_type_model.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_form_item_list_item.dart';
import 'package:smart_case/services/apis/smartcase_apis/currency_api.dart';

part 'invoice_form_event.dart';
part 'invoice_form_state.dart';

class InvoiceFormBloc extends Bloc<InvoiceFormEvent, InvoiceFormState> {
  InvoiceFormBloc() : super(const InvoiceFormState()) {
    on<RefreshInvoiceForm>(_mapGetInvoiceFormEventToState);
    on<PrepareInvoiceForm>(_mapPrepareInvoiceFormEventToState);
    on<EditInvoiceForm>(_mapEditInvoiceFormEventToState);
  }

  _mapGetInvoiceFormEventToState(
      RefreshInvoiceForm event, Emitter<InvoiceFormState> emit) {
    emit(state.copyWith(status: InvoiceFormStatus.loading));
    emit(state.copyWith(
      status: InvoiceFormStatus.success,
      items: event.items,
    ));
  }

  _mapPrepareInvoiceFormEventToState(
      PrepareInvoiceForm event, Emitter<InvoiceFormState> emit) async {
    emit(state.copyWith(status: InvoiceFormStatus.loading));
    await CurrencyApi.fetchAll()
        .then((currencies) => emit(state.copyWith(
              status: InvoiceFormStatus.success,
              currencies: currencies,
            )))
        .onError((error, stackTrace) => emit(state.copyWith(
              status: InvoiceFormStatus.error,
            )));
  }

  _mapEditInvoiceFormEventToState(
      EditInvoiceForm event, Emitter<InvoiceFormState> emit) async {
    emit(state.copyWith(status: InvoiceFormStatus.loading));
    await CurrencyApi.fetchAll()
        .then((currencies) => emit(state.copyWith(
              status: InvoiceFormStatus.success,
              currencies: currencies,
              invoice: event.invoice,
              invoiceType: event.invoice.invoiceType,
              date: event.invoice.date,
              dueDate: event.invoice.dueDate,
              file: event.invoice.file,
              client: event.invoice.client,
              currency: event.invoice.currency,
              invoiceItems: event.invoice.invoiceItems,
              bank: event.invoice.bank,
              supervisor: event.invoice.approver,
              paymentTerms: event.invoice.paymentTerms,
            )))
        .onError((error, stackTrace) => emit(state.copyWith(
              status: InvoiceFormStatus.error,
            )));
  }

  @override
  void onChange(Change<InvoiceFormState> change) {
    super.onChange(change);
    if (kDebugMode) {
      print("Change: $change");
    }
  }

  @override
  void onEvent(InvoiceFormEvent event) {
    super.onEvent(event);
    if (kDebugMode) {
      print("Event: $event");
    }
  }

  @override
  void onTransition(Transition<InvoiceFormEvent, InvoiceFormState> transition) {
    super.onTransition(transition);
    if (kDebugMode) {
      print("Transition: $transition");
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    if (kDebugMode) {
      print("Error: $error");
      print("StackTrace: $stackTrace");
    }
  }
}
