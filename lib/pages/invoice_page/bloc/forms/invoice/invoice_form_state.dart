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
  final SmartInvoiceType? invoiceType;
  final dynamic date;
  final dynamic dueDate;
  final SmartFile? file;
  final SmartClient? client;
  final SmartCurrency? currency;
  final List<InvoiceFormItem>? invoiceItems;
  final SmartBank? bank;
  final SmartEmployee? supervisor;
  final String? paymentTerms;
  final List<InvoiceFormItemListItem>? items;
  final List<SmartCurrency>? currencies;
  final InvoiceFormStatus? status;
  final int idSelected;

  const InvoiceFormState({
    this.items,
    this.currencies,
    this.invoice,
    this.invoiceType,
    this.date,
    this.dueDate,
    this.file,
    this.client,
    this.currency,
    this.invoiceItems,
    this.bank,
    this.supervisor,
    this.paymentTerms,
    this.status = InvoiceFormStatus.initial,
    this.idSelected = 0,
  });

  @override
  List<Object?> get props => [
        items,
        currencies,
        invoice,
        invoiceType,
        date,
        dueDate,
        file,
        client,
        currency,
        bank,
        supervisor,
        paymentTerms,
        status,
        idSelected,
      ];

  InvoiceFormState copyWith({
    List<InvoiceFormItemListItem>? items,
    List<SmartCurrency>? currencies,
    SmartInvoice? invoice,
    SmartInvoiceType? invoiceType,
    dynamic date,
    dynamic dueDate,
    SmartFile? file,
    SmartClient? client,
    SmartCurrency? currency,
    List<InvoiceFormItem>? invoiceItems,
    SmartBank? bank,
    SmartEmployee? supervisor,
    String? paymentTerms,
    InvoiceFormStatus? status,
    int? idSelected,
  }) {
    return InvoiceFormState(
      items: items ?? this.items,
      currencies: currencies ?? this.currencies,
      invoice: invoice ?? this.invoice,
      invoiceType: invoiceType ?? this.invoiceType,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      file: file ?? this.file,
      client: client ?? this.client,
      currency: currency ?? this.currency,
      invoiceItems: invoiceItems ?? this.invoiceItems,
      bank: bank ?? this.bank,
      supervisor: supervisor ?? this.supervisor,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      status: status ?? this.status,
      idSelected: idSelected ?? this.idSelected,
    );
  }
}
