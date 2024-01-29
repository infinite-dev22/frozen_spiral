import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'locator_event.dart';
part 'locator_state.dart';

class LocatorBloc extends Bloc<LocatorEvent, LocatorState> {
  LocatorBloc() : super(LocatorInitial()) {
    on<LocatorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

// class LocatorBloc extends Bloc<LocatorEvent, LocatorState> {
// LocatorBloc() : super(const LocatorState()) {
//   on<GetLocatorsEvent>(_mapGetLocatorsEventToState);
//   on<GetLocatorEvent>(_mapGetLocatorEventToState);
//   on<PostLocatorEvent>(_mapPostLocatorEventToState);
//   on<PutLocatorEvent>(_mapPutLocatorEventToState);
// }
//
// Future<FutureOr<void>> _mapGetLocatorsEventToState(
//     GetLocatorsEvent event, Emitter<LocatorState> emit) async {
//   emit(state.copyWith(status: LocatorStatus.filesLoading));
//   await LocatorApi.fetchAll().then((files) {
//     emit(state.copyWith(status: LocatorStatus.filesSuccess, files: files));
//   }).onError((error, stackTrace) {
//     if (kDebugMode) {
//       print(error);
//       print(stackTrace);
//     }
//     emit(state.copyWith(status: LocatorStatus.filesSuccess));
//   });
// }
//
// Future<FutureOr<void>> _mapGetLocatorEventToState(
//     GetLocatorEvent event, Emitter<LocatorState> emit) async {
//   emit(state.copyWith(status: LocatorStatus.filesLoading));
//   await LocatorApi.fetch(event.fileId).then((file) {
//     emit(state.copyWith(status: LocatorStatus.fileSuccess, file: file));
//   }).onError((error, stackTrace) {
//     if (kDebugMode) {
//       print(error);
//       print(stackTrace);
//     }
//     emit(state.copyWith(status: LocatorStatus.fileSuccess));
//   });
// }
//
// Future<FutureOr<void>> _mapPostLocatorEventToState(
//     PostLocatorEvent event, Emitter<LocatorState> emit) async {
//   emit(state.copyWith(status: LocatorStatus.filesLoading));
//   await LocatorApi.post(event.file, event.fileId).then((file) {
//     emit(state.copyWith(status: LocatorStatus.fileSuccess, file: file));
//   }).onError((error, stackTrace) {
//     if (kDebugMode) {
//       print(error);
//       print(stackTrace);
//     }
//     emit(state.copyWith(status: LocatorStatus.fileSuccess));
//   });
// }
//
// Future<FutureOr<void>> _mapPutLocatorEventToState(
//     PutLocatorEvent event, Emitter<LocatorState> emit) async {
//   emit(state.copyWith(status: LocatorStatus.filesLoading));
//   await LocatorApi.put(event.file, event.fileId).then((file) {
//     emit(state.copyWith(status: LocatorStatus.fileSuccess, file: file));
//   }).onError((error, stackTrace) {
//     if (kDebugMode) {
//       print(error);
//       print(stackTrace);
//     }
//     emit(state.copyWith(status: LocatorStatus.fileSuccess));
//   });
// }
// }
