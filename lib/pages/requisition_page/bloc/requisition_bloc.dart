import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/services/apis/smartcase_apis/requisition_api.dart';

part 'requisition_event.dart';
part 'requisition_state.dart';

class RequisitionBloc extends Bloc<RequisitionEvent, RequisitionState> {
  RequisitionBloc() : super(const RequisitionState()) {
    on<GetRequisitions>(_mapGetRequisitionsEventToState);
    // on<GetRequisition>(_mapGetRequisitionEventToState);
    // on<PostRequisition>(_mapPostRequisitionEventToState);
    // on<PutRequisition>(_mapPutRequisitionEventToState);
    on<SelectRequisition>(_mapSelectRequisitionEventToState);
  }

  void _mapGetRequisitionsEventToState(
      GetRequisitions event, Emitter<RequisitionState> emit) async {
    emit(state.copyWith(status: RequisitionStatus.loading));

    try {
      final requisitions = await RequisitionApi.fetchAll();

      emit(
        state.copyWith(
            status: RequisitionStatus.success, requisitions: requisitions),
      );
    } catch (error) {
      emit(state.copyWith(status: RequisitionStatus.error));
    }
  }

  // void _mapGetRequisitionEventToState(
  //     GetRequisition event, Emitter<RequisitionState> emit) async {
  //   emit(state.copyWith(status: RequisitionStatus.loading));
  //
  //   try {
  //     final requisitions = await RequisitionApi.fetch();
  //
  //     emit(
  //       state.copyWith(
  //           status: RequisitionStatus.success, requisitions: requisitions),
  //     );
  //   } catch (error) {
  //     emit(state.copyWith(status: RequisitionStatus.error));
  //   }
  // }

  // void _mapPostRequisitionEventToState(
  //     PostRequisition file, Emitter<RequisitionState> emit) async {
  //   emit(state.copyWith(status: RequisitionStatus.loading));
  //
  //   try {
  //     final requisitions = await RequisitionApi.post();
  //
  //     emit(
  //       state.copyWith(
  //           status: RequisitionStatus.success, requisitions: requisitions),
  //     );
  //   } catch (error) {
  //     emit(state.copyWith(status: RequisitionStatus.error));
  //   }
  // }

  // void _mapPutRequisitionEventToState(
  //     PutRequisition file, Emitter<RequisitionState> emit) async {
  //   emit(state.copyWith(status: RequisitionStatus.loading));
  //
  //   try {
  //     final requisitions = await RequisitionApi.put();
  //
  //     emit(
  //       state.copyWith(
  //           status: RequisitionStatus.success, requisitions: requisitions),
  //     );
  //   } catch (error) {
  //     emit(state.copyWith(status: RequisitionStatus.error));
  //   }
  // }

  void _mapSelectRequisitionEventToState(
      SelectRequisition event, Emitter<RequisitionState> emit) async {
    emit(
      state.copyWith(
        status: RequisitionStatus.selected,
        idSelected: event.idSelected,
      ),
    );
  }
}
