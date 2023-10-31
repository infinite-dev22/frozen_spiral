import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'requisition_event.dart';
part 'requisition_state.dart';

class RequisitionBloc extends Bloc<RequisitionEvent, RequisitionState> {
  RequisitionBloc() : super(RequisitionInitial());

  @override
  Stream<RequisitionState> mapEventToState(
    RequisitionEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
