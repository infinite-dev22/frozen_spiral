part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class GetActivitiesEvent extends ActivityEvent {}

class GetActivityEvent extends ActivityEvent {
  final int fileId;
  final int activityId;

  const GetActivityEvent(this.fileId, this.activityId);

  @override
  List<Object?> get props => [fileId, activityId];
}

class PostActivityEvent extends ActivityEvent {
  final Map<String, dynamic> activity;
  final int fileId;

  const PostActivityEvent(this.activity, this.fileId);

  @override
  List<Object?> get props => [fileId, activity];
}

class PutActivityEvent extends ActivityEvent {
  final int fileId;
  final int activityId;
  final Map<String, dynamic> activity;

  const PutActivityEvent(
    this.fileId,
    this.activityId,
    this.activity,
  );

  @override
  List<Object?> get props => [fileId, activityId, activity];
}

class DeleteActivityEvent extends ActivityEvent {
  final int fileId;
  final int activityId;

  const DeleteActivityEvent(this.fileId, this.activityId);

  @override
  List<Object?> get props => [fileId, activityId];
}

class SearchActivityEvent extends ActivityEvent {
  final String search;

  const SearchActivityEvent(this.search);

  @override
  List<Object?> get props => [search];
}
