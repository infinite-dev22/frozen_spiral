import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_api.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(const InvoiceState()) {
    on<GetInvoices>(_mapGetInvoicesEventToState);
    on<FormGetInvoice>(_mapFormGetInvoiceEventToState);
    on<ViewGetInvoice>(_mapViewGetInvoiceEventToState);
    on<UpdateInvoice>(_mapUpdateInvoiceEventToState);
    on<ProcessInvoice>(_mapProcessInvoiceEventToState);
    on<DeleteInvoice>(_mapDeleteInvoiceEventToState);
    on<SelectInvoice>(_mapSelectInvoiceEventToState);
  }

  _mapGetInvoicesEventToState(
      GetInvoices event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(status: InvoiceStatus.loading));
    await InvoiceApi.fetchAll().then((invoices) {
      emit(state.copyWith(status: InvoiceStatus.success, invoices: invoices));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: InvoiceStatus.error));
    });
  }

  _mapFormGetInvoiceEventToState(
      FormGetInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(status: InvoiceStatus.formLoading));
    await InvoiceApi.fetch(event.invoiceId).then((invoice) {
      emit(state.copyWith(status: InvoiceStatus.formSuccess, invoice: invoice));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: InvoiceStatus.formError));
    });
  }

  _mapViewGetInvoiceEventToState(
      ViewGetInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(status: InvoiceStatus.viewLoading));
    await InvoiceApi.fetch(event.invoiceId).then((invoice) {
      emit(state.copyWith(status: InvoiceStatus.viewSuccess, invoice: invoice));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: InvoiceStatus.viewError));
    });
  }

  _mapUpdateInvoiceEventToState(
      UpdateInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(status: InvoiceStatus.formLoading));
    await InvoiceApi.put(event.invoice, event.invoiceId).then((invoice) {
      emit(state.copyWith(status: InvoiceStatus.formSuccess, invoice: invoice));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: InvoiceStatus.formError));
    });
  }

  _mapProcessInvoiceEventToState(
      ProcessInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(status: InvoiceStatus.viewLoading));
    await InvoiceApi.process(event.invoice, event.invoiceId).then((invoice) {
      emit(state.copyWith(status: InvoiceStatus.viewSuccess, invoice: invoice));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: InvoiceStatus.viewError));
    });
  }

  _mapDeleteInvoiceEventToState(
      DeleteInvoice event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(status: InvoiceStatus.loading));
    try {
      emit(state.copyWith(status: InvoiceStatus.success));
    } catch (e) {
      emit(state.copyWith(status: InvoiceStatus.error));
    }
  }

  _mapSelectInvoiceEventToState(
      SelectInvoice event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(status: InvoiceStatus.loading));
    try {
      emit(state.copyWith(
          status: InvoiceStatus.success, invoice: event.invoice));
    } catch (e) {
      emit(state.copyWith(status: InvoiceStatus.error));
    }
  }

  @override
  void onChange(Change<InvoiceState> change) {
    super.onChange(change);
    if (kDebugMode) {
      print("Change: $change");
    }
  }

  @override
  void onEvent(InvoiceEvent event) {
    super.onEvent(event);
    if (kDebugMode) {
      print("Event: $event");
    }
  }

  @override
  void onTransition(Transition<InvoiceEvent, InvoiceState> transition) {
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
