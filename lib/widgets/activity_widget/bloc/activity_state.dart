part of 'activity_bloc.dart';

enum ActivityStatus { initial, success, error, loading, selected }

extension ActivityStatusX on ActivityStatus {
  bool get isInitial => this == ActivityStatus.initial;

  bool get isSuccess => this == ActivityStatus.success;

  bool get isError => this == ActivityStatus.error;

  bool get isLoading => this == ActivityStatus.loading;

  bool get isSelected => this == ActivityStatus.selected;
}

class ActivityState extends Equatable {
  final List<SmartActivity> activities;
  final ActivityStatus status;
  final int idSelected;

  const ActivityState({
    this.status = ActivityStatus.initial,
    List<SmartActivity>? activities,
    this.idSelected = 0,
  }) : activities = activities ?? const [];

  @override
  List<Object> get props => [status, activities, idSelected];

  ActivityState copyWith({
    List<SmartActivity>? activities,
    ActivityStatus? status,
    int? idSelected,
  }) {
    return ActivityState(
      activities: activities ?? this.activities,
      status: status ?? this.status,
      idSelected: idSelected ?? this.idSelected,
    );
  }
}

class ActivityInitial extends ActivityState {
  @override
  List<Object> get props => [status, activities, idSelected];

  @override
  ActivityState copyWith({
    List<SmartActivity>? activities,
    ActivityStatus? status,
    int? idSelected,
  }) {
    return ActivityState(
      activities: activities ?? this.activities,
      status: status ?? this.status,
      idSelected: idSelected ?? this.idSelected,
    );
  }
}
