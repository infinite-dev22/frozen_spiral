part of 'event_bloc.dart';

enum EventStatus {
  initial,
  eventSuccess,
  eventsSuccess,
  eventError,
  eventsError,
  eventLoading,
  eventsLoading,
  selected,
  eventNoData,
  eventsNoData,
}

extension EventStatusX on EventStatus {
  bool get isInitial => this == EventStatus.initial;

  bool get eventIsSuccess => this == EventStatus.eventSuccess;

  bool get eventsIsSuccess => this == EventStatus.eventsSuccess;

  bool get eventIsError => this == EventStatus.eventError;

  bool get eventsIsError => this == EventStatus.eventsError;

  bool get eventIsLoading => this == EventStatus.eventLoading;

  bool get eventsIsLoading => this == EventStatus.eventsLoading;

  bool get eventIsNoData => this == EventStatus.eventNoData;

  bool get eventsIsNoData => this == EventStatus.eventsNoData;
}

@immutable
class EventState extends Equatable {
  final Map<DateTime, List<SmartEvent>>? events;
  final SmartEvent? event;
  final EventStatus? status;
  final int? idSelected;

  const EventState({
    Map<DateTime, List<SmartEvent>>? events,
    this.event,
    this.status = EventStatus.initial,
    this.idSelected = 0,
  }) : events = events ?? const {};

  @override
  List<Object?> get props => [
        events,
        event,
        status,
        idSelected,
      ];

  EventState copyWith({
    Map<DateTime, List<SmartEvent>>? events,
    SmartEvent? event,
    EventStatus? status,
    int? idSelected,
  }) {
    return EventState(
      events: events,
      event: event,
      status: status,
      idSelected: idSelected,
    );
  }
}

class EventInitial extends EventState {
  @override
  List<Object> get props => [];
}

class ActivitiesInitial extends EventState {
  @override
  List<Object> get props => [];
}

class EventLoading extends EventState {}

class ActivitiesLoading extends EventState {}

class EventSuccessful extends EventState {
  @override
  List<Object?> get props => [];
}

class ActivitiesSuccessful extends EventState {
  @override
  List<Object?> get props => [];
}

class EventError extends EventState {}

class ActivitiesError extends EventState {}

class EventNoData extends EventState {}

class ActivitiesNoData extends EventState {}
