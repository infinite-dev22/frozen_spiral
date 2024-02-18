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
    on<GetEventsEvent>(_mapGetActivitiesEventToState);
  }

  Future<FutureOr<void>> _mapGetActivitiesEventToState(
      GetEventsEvent event, Emitter<EventState> emit) async {
    emit(state.copyWith(status: EventStatus.eventsLoading));
    await EventApi.fetchAll(body: event.body).then((events) {
      emit(state.copyWith(status: EventStatus.eventsSuccess, events: events));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: EventStatus.eventsSuccess));
    });
  }
}
