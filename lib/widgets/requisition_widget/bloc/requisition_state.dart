part of 'requisition_bloc.dart';

abstract class RequisitionState extends Equatable {
  const RequisitionState();
}

class RequisitionInitial extends RequisitionState {
  @override
  List<Object> get props => [];
}
