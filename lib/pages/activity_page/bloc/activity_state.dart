part of 'activity_bloc.dart';

enum ActivityStatus {
  initial,
  success,
  error,
  loading,
  selected,
  noData,
  notFound,
}

@immutable
class ActivityState extends Equatable {
  final List<SmartActivity>? activities;
  final SmartActivity? activity;
  final String? searchString;
  final ActivityStatus? status;
  final int? idSelected;

  const ActivityState({
    List<SmartActivity>? activities,
    this.activity,
    this.searchString,
    this.status = ActivityStatus.initial,
    this.idSelected = 0,
  }) : activities = activities ?? const [];

  @override
  List<Object?> get props => [
        activities,
        activity,
        searchString,
        status,
        idSelected,
      ];

  ActivityState copyWith({
    List<SmartActivity>? activities,
    SmartActivity? activity,
    String? searchString,
    ActivityStatus? status,
    int? idSelected,
  }) {
    return ActivityState(
      activities: activities,
      activity: activity,
      searchString: searchString,
      status: status,
      idSelected: idSelected,
    );
  }
}
