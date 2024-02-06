import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_form_item_list_item.dart';

part 'invoice_form_event.dart';
part 'invoice_form_state.dart';

class InvoiceFormBloc extends Bloc<InvoiceFormEvent, InvoiceFormState> {
  InvoiceFormBloc() : super(InvoiceFormInitial()) {
    on<RefreshInvoiceForm>(_mapGetInvoiceFormEventToState);
  }

  _mapGetInvoiceFormEventToState(
      RefreshInvoiceForm event, Emitter<InvoiceFormState> emit) {
    emit(state.copyWith(status: InvoiceFormStatus.loading));
    emit(state.copyWith(
      status: InvoiceFormStatus.success,
      items: event.items,
    ));
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
