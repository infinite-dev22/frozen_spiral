part of 'activity_bloc.dart';

enum ActivityStatus {
  initial,
  activitySuccess,
  activitiesSuccess,
  activityError,
  activitiesError,
  activityLoading,
  activitiesLoading,
  selected,
  activityNoData,
  activitiesNoData,
}

extension ActivityStatusX on ActivityStatus {
  bool get isInitial => this == ActivityStatus.initial;

  bool get activityIsSuccess => this == ActivityStatus.activitySuccess;

  bool get activitiesIsSuccess => this == ActivityStatus.activitiesSuccess;

  bool get activityIsError => this == ActivityStatus.activityError;

  bool get activitiesIsError => this == ActivityStatus.activitiesError;

  bool get activityIsLoading => this == ActivityStatus.activityLoading;

  bool get activitiesIsLoading => this == ActivityStatus.activitiesLoading;

  bool get activityIsNoData => this == ActivityStatus.activityNoData;

  bool get activitiesIsNoData => this == ActivityStatus.activitiesNoData;
}

@immutable
class ActivityState extends Equatable {
  final List<SmartActivity>? activities;
  final SmartActivity? activity;
  final ActivityStatus? status;
  final int? idSelected;

  const ActivityState({
    List<SmartActivity>? activities,
    this.activity,
    this.status = ActivityStatus.initial,
    this.idSelected = 0,
  }) : activities = activities ?? const [];

  @override
  List<Object?> get props => [
        activities,
        activity,
        status,
        idSelected,
      ];

  ActivityState copyWith({
    List<SmartActivity>? activities,
    SmartActivity? activity,
    ActivityStatus? status,
    int? idSelected,
  }) {
    return ActivityState(
      activities: activities,
      activity: activity,
      status: status,
      idSelected: idSelected,
    );
  }
}

class ActivityInitial extends ActivityState {
  @override
  List<Object> get props => [];
}

class ActivitiesInitial extends ActivityState {
  @override
  List<Object> get props => [];
}

class ActivityLoading extends ActivityState {}

class ActivitiesLoading extends ActivityState {}

class ActivitySuccessful extends ActivityState {
  @override
  List<Object?> get props => [];
}

class ActivitiesSuccessful extends ActivityState {
  @override
  List<Object?> get props => [];
}

class ActivityError extends ActivityState {}

class ActivitiesError extends ActivityState {}

class ActivityNoData extends ActivityState {}

class ActivitiesNoData extends ActivityState {}
