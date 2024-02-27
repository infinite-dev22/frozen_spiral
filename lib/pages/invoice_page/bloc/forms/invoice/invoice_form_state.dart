part of 'invoice_form_bloc.dart';

enum InvoiceFormStatus { initial, success, error, loading, selected }

extension InvoiceFormStatusX on InvoiceFormStatus {
  bool get isInitial => this == InvoiceFormStatus.initial;

  bool get isSuccess => this == InvoiceFormStatus.success;

  bool get isError => this == InvoiceFormStatus.error;

  bool get isLoading => this == InvoiceFormStatus.loading;

  bool get isSelected => this == InvoiceFormStatus.selected;
}

@immutable
class InvoiceFormState extends Equatable {
  final SmartInvoice? invoice;
  final List<InvoiceFormItemListItem>? items;
  final List<SmartCurrency>? currencies;
  final InvoiceFormStatus? status;
  final int idSelected;

  const InvoiceFormState({
    this.items,
    this.currencies,
    this.invoice,
    this.status = InvoiceFormStatus.initial,
    this.idSelected = 0,
  });

  @override
  List<Object?> get props => [items, currencies, invoice, status, idSelected];

  InvoiceFormState copyWith({
    List<InvoiceFormItemListItem>? items,
    List<SmartCurrency>? currencies,
    SmartInvoice? invoice,
    InvoiceFormStatus? status,
    int? idSelected,
  }) {
    return InvoiceFormState(
      items: items ?? this.items,
      currencies: currencies ?? this.currencies,
      invoice: invoice ?? this.invoice,
      status: status ?? this.status,
      idSelected: idSelected ?? this.idSelected,
    );
  }
}
