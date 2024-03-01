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

class EditInvoiceForm extends InvoiceFormEvent {
  EditInvoiceForm(this.invoice);

  final SmartInvoice invoice;

  @override
  List<Object?> get props => [invoice];
}

class PrepareInvoiceForm extends InvoiceFormEvent {}

class Success extends InvoiceFormEvent {}
