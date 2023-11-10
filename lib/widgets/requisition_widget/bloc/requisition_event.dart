part of 'requisition_bloc.dart';

abstract class RequisitionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRequisitions extends RequisitionEvent {}
class GetRequisition extends RequisitionEvent {}
class PostRequisition extends RequisitionEvent {}
class PutRequisition extends RequisitionEvent {}

class SelectRequisition extends RequisitionEvent {
  SelectRequisition({required this.idSelected});

  final int idSelected;

  @override
  List<Object?> get props => [idSelected];
}
