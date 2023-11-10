part of 'requisition_bloc.dart';

enum RequisitionStatus { initial, success, error, loading, selected }

extension RequisitionStatusX on RequisitionStatus {
  bool get isInitial => this == RequisitionStatus.initial;

  bool get isSuccess => this == RequisitionStatus.success;

  bool get isError => this == RequisitionStatus.error;

  bool get isLoading => this == RequisitionStatus.loading;

  bool get isSelected => this == RequisitionStatus.selected;
}

class RequisitionState extends Equatable {
  final List<SmartRequisition> requisitions;
  final List<SmartCurrency> currencies;
  final RequisitionStatus status;
  final int idSelected;

  const RequisitionState({
    this.status = RequisitionStatus.initial,
    List<SmartRequisition>? requisitions,
    List<SmartCurrency>? currencies,
    this.idSelected = 0,
  })  : requisitions = requisitions ?? const [],
        currencies = currencies ?? const [];

  @override
  List<Object> get props => [status, requisitions, currencies, idSelected];

  RequisitionState copyWith({
    List<SmartRequisition>? requisitions,
    List<SmartCurrency>? currencies,
    RequisitionStatus? status,
    int? idSelected,
  }) {
    return RequisitionState(
      requisitions: requisitions ?? this.requisitions,
      currencies: currencies ?? this.currencies,
      status: status ?? this.status,
      idSelected: idSelected ?? this.idSelected,
    );
  }
}

class RequisitionInitial extends RequisitionState {
  @override
  List<Object> get props => [status, requisitions, currencies, idSelected];

  @override
  RequisitionState copyWith({
    List<SmartRequisition>? requisitions,
    List<SmartCurrency>? currencies,
    RequisitionStatus? status,
    int? idSelected,
  }) {
    return RequisitionState(
      requisitions: requisitions ?? this.requisitions,
      currencies: currencies ?? this.currencies,
      status: status ?? this.status,
      idSelected: idSelected ?? this.idSelected,
    );
  }
}
