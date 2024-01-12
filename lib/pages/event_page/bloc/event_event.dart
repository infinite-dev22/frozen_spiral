// part of 'event_bloc.dart';
//
// abstract class EventEvent extends Equatable {
//   const EventEvent();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class GetActivitiesEvent extends EventEvent {}
//
// class GetEventEvent extends EventEvent {
//   final int eventId;
//
//   GetEventEvent(this.eventId);
//
//   @override
//   List<Object?> get props => [eventId];
// }
//
// class PostEventEvent extends EventEvent {
//   final Map<String, dynamic> event;
//   final int eventId;
//
//   PostEventEvent(this.event, this.eventId);
//
//   @override
//   List<Object?> get props => [eventId, event];
// }
//
// class PutEventEvent extends EventEvent {
//   final int eventId;
//   final Map<String, dynamic> event;
//
//   PutEventEvent(
//     this.eventId,
//     this.event,
//   );
//
//   @override
//   List<Object?> get props => [eventId, event];
// }
//
// class DeleteEventEvent extends EventEvent {
//   final int eventId;
//
//   DeleteEventEvent(this.eventId);
//
//   @override
//   List<Object?> get props => [eventId];
// }
