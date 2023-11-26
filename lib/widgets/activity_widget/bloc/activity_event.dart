part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetActivities extends ActivityEvent {}

class SelectActivity extends ActivityEvent {
  SelectActivity({required this.idSelected});

  final int idSelected;

  @override
  List<Object?> get props => [idSelected];
}
