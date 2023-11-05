part of 'engagement_bloc.dart';

abstract class EngagementState extends Equatable {
  const EngagementState();
}

class EngagementInitial extends EngagementState {
  @override
  List<Object> get props => [];
}
