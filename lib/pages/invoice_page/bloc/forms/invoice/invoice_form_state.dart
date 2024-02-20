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
  final InvoiceFormStatus? status;
  final int idSelected;

  const InvoiceFormState({
    this.invoice,
    this.items,
    this.status = InvoiceFormStatus.initial,
    this.idSelected = 0,
  });

  @override
  List<Object?> get props => [invoice, items, status, idSelected];

  InvoiceFormState copyWith({
    SmartInvoice? invoice,
    List<InvoiceFormItemListItem>? items,
    InvoiceFormStatus? status,
    int? idSelected,
  }) {
    return InvoiceFormState(
      invoice: invoice ?? this.invoice,
      items: items ?? this.items,
      status: status ?? this.status,
      idSelected: idSelected ?? this.idSelected,
    );
  }
}

class InvoiceFormInitial extends InvoiceFormState {}

class InvoiceFormSuccess extends InvoiceFormState {}

class InvoiceFormRefresh extends InvoiceFormState {
  const InvoiceFormRefresh(items);

  @override
  List<Object?> get props => [items];
}
