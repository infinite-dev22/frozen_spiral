import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/database/event/event_model.dart';
import 'package:smart_case/services/apis/smartcase_apis/event_api.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(const EventState()) {
    on<GetActivitiesEvent>(_mapGetActivitiesEventToState);
    // on<GetEventEvent>(_mapGetEventEventToState);
    // on<PostEventEvent>(_mapPostEventEventToState);
    // on<PutEventEvent>(_mapPutEventEventToState);
    // on<DeleteEventEvent>(_mapDeleteEventEventToState);
  }

  Future<FutureOr<void>> _mapGetActivitiesEventToState(
      GetActivitiesEvent event, Emitter<EventState> emit) async {
    emit(state.copyWith(status: EventStatus.eventsLoading));
    await EventApi.fetchAll().then((events) {
      emit(state.copyWith(status: EventStatus.eventsSuccess, events: events));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: EventStatus.eventsSuccess));
    });
  }

// Future<FutureOr<void>> _mapGetEventEventToState(
//     GetEventEvent event, Emitter<EventState> emit) async {
//   emit(state.copyWith(status: EventStatus.eventsLoading));
//   await EventApi.fetch(event.eventId).then((event) {
//     emit(state.copyWith(
//         status: EventStatus.eventSuccess, event: event));
//   }).onError((error, stackTrace) {
//     if (kDebugMode) {
//       print(error);
//       print(stackTrace);
//     }
//     emit(state.copyWith(status: EventStatus.eventSuccess));
//   });
// }
//
// Future<FutureOr<void>> _mapPostEventEventToState(
//     PostEventEvent event, Emitter<EventState> emit) async {
//   emit(state.copyWith(status: EventStatus.eventsLoading));
//   await EventApi.post(event.event, event.eventId)
//       .then((event) {
//     emit(state.copyWith(
//         status: EventStatus.eventSuccess, event: event));
//   }).onError((error, stackTrace) {
//     if (kDebugMode) {
//       print(error);
//       print(stackTrace);
//     }
//     emit(state.copyWith(status: EventStatus.eventSuccess));
//   });
// }
//
// Future<FutureOr<void>> _mapPutEventEventToState(
//     PutEventEvent event, Emitter<EventState> emit) async {
//   emit(state.copyWith(status: EventStatus.eventsLoading));
//   await EventApi.put(event.event, event.eventId)
//       .then((event) {
//     emit(state.copyWith(
//         status: EventStatus.eventSuccess, event: event));
//   }).onError((error, stackTrace) {
//     if (kDebugMode) {
//       print(error);
//       print(stackTrace);
//     }
//     emit(state.copyWith(status: EventStatus.eventSuccess));
//   });
// }
//
// Future<FutureOr<void>> _mapDeleteEventEventToState(
//     DeleteEventEvent event, Emitter<EventState> emit) async {
//   emit(state.copyWith(status: EventStatus.eventsLoading));
//   await EventApi.delete(event.eventId).whenComplete(() {
//     emit(state.copyWith(status: EventStatus.eventSuccess));
//   }).onError((error, stackTrace) {
//     if (kDebugMode) {
//       print(error);
//       print(stackTrace);
//     }
//     emit(state.copyWith(status: EventStatus.eventSuccess));
//   });
// }
}
