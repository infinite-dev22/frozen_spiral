part of 'invoice_bloc.dart';

@immutable
abstract class InvoiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetInvoices extends InvoiceEvent {}

class FormGetInvoice extends InvoiceEvent {
  FormGetInvoice(this.invoiceId);

  final int invoiceId;

  @override
  List<Object?> get props => [invoiceId];
}

class ViewGetInvoice extends InvoiceEvent {
  ViewGetInvoice(this.invoiceId);

  final int invoiceId;

  @override
  List<Object?> get props => [invoiceId];
}

class UpdateInvoice extends InvoiceEvent {
  UpdateInvoice(this.invoiceId, this.invoice);

  final int invoiceId;
  final SmartInvoice invoice;

  @override
  List<Object?> get props => [invoiceId, invoice];
}

class ProcessInvoice extends InvoiceEvent {
  ProcessInvoice(this.invoiceId, this.invoice);

  final int invoiceId;
  final SmartInvoice invoice;

  @override
  List<Object?> get props => [invoiceId, invoice];
}

class SetInvoice extends InvoiceEvent {
  SetInvoice(this.invoice);

  final SmartInvoice invoice;

  @override
  List<Object?> get props => [invoice];
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
