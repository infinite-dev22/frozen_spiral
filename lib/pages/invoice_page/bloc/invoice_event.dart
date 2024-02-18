part of 'invoice_bloc.dart';

@immutable
abstract class InvoiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetInvoices extends InvoiceEvent {}

class GetInvoice extends InvoiceEvent {
  GetInvoice(this.invoiceId);

  final int invoiceId;

  @override
  List<Object?> get props => [invoiceId];
}

class DeleteInvoice extends InvoiceEvent {
  DeleteInvoice(this.invoiceId);

  final int invoiceId;

  @override
  List<Object?> get props => [invoiceId];
}

class SelectInvoice extends InvoiceEvent {
  SelectInvoice(this.invoice);

  final SmartInvoice invoice;

  @override
  List<Object?> get props => [invoice];
}
