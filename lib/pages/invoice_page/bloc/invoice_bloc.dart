import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceInitial()) {
    on<InvoiceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
