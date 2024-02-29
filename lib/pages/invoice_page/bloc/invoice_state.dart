part of 'invoice_bloc.dart';

enum InvoiceStatus {
  initial,
  success,
  error,
  loading,
  selected,
  noData,
  formSuccess,
  formError,
  formLoading,
  formInitial,
  viewSuccess,
  viewError,
  viewLoading,
  viewInitial,
  invoiceApproveSuccess,
  invoiceApproveError,
}

extension InvoiceStatusX on InvoiceStatus {
  bool get isInitial => this == InvoiceStatus.initial;

  bool get isSuccess => this == InvoiceStatus.success;

  bool get isError => this == InvoiceStatus.error;

  bool get isLoading => this == InvoiceStatus.loading;

  bool get isSelected => this == InvoiceStatus.selected;
}

@immutable
class InvoiceState extends Equatable {
  final SmartInvoice? invoice;
  final List<SmartInvoice> invoices;
  final List<SmartCurrency> currencies;
  final InvoiceStatus status;
  final int? idSelected;

  const InvoiceState({
    this.invoice,
    List<SmartInvoice>? invoices,
    List<SmartCurrency>? currencies,
    this.status = InvoiceStatus.initial,
    this.idSelected,
  })  : invoices = invoices ?? const [],
        currencies = currencies ?? const [];

  @override
  List<Object?> get props => [invoice, invoices, status, idSelected];

  // Copy state.
  InvoiceState copyWith({
    SmartInvoice? invoice,
    List<SmartInvoice>? invoices,
    InvoiceStatus? status,
    int? idSelected,
  }) {
    return InvoiceState(
      invoice: invoice ?? this.invoice,
      invoices: invoices ?? this.invoices,
      status: status ?? this.status,
      idSelected: idSelected ?? this.idSelected,
    );
  }
}
