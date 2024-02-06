part of 'invoice_form_bloc.dart';

@immutable
abstract class InvoiceFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RefreshInvoiceForm extends InvoiceFormEvent {
  RefreshInvoiceForm(this.items);

  final List<InvoiceFormItemListItem>? items;

  @override
  List<Object?> get props => [items];
}

class Success extends InvoiceFormEvent {}
