part of 'engagement_bloc.dart';

enum EngagementStatus {
  initial,
  engagementSuccess,
  engagementsSuccess,
  engagementError,
  engagementsError,
  engagementLoading,
  engagementsLoading,
  selected,
  engagementNoData,
  engagementsNoData,
}

extension EngagementStatusX on EngagementStatus {
  bool get isInitial => this == EngagementStatus.initial;

  bool get engagementIsSuccess => this == EngagementStatus.engagementSuccess;

  bool get engagementsIsSuccess => this == EngagementStatus.engagementsSuccess;

  bool get engagementIsError => this == EngagementStatus.engagementError;

  bool get engagementsIsError => this == EngagementStatus.engagementsError;

  bool get engagementIsLoading => this == EngagementStatus.engagementLoading;

  bool get engagementsIsLoading => this == EngagementStatus.engagementsLoading;

  bool get engagementIsNoData => this == EngagementStatus.engagementNoData;

  bool get engagementsIsNoData => this == EngagementStatus.engagementsNoData;
}

@immutable
class EngagementState extends Equatable {
  final List<SmartEngagement>? engagements;
  final SmartEngagement? engagement;
  final EngagementStatus? status;
  final int? idSelected;

  const EngagementState({
    List<SmartEngagement>? engagements,
    this.engagement,
    this.status = EngagementStatus.initial,
    this.idSelected = 0,
  }) : engagements = engagements ?? const [];

  @override
  List<Object?> get props => [
        engagements,
        engagement,
        status,
        idSelected,
      ];

  EngagementState copyWith({
    List<SmartEngagement>? engagements,
    SmartEngagement? engagement,
    EngagementStatus? status,
    int? idSelected,
  }) {
    return EngagementState(
      engagements: engagements,
      engagement: engagement,
      status: status,
      idSelected: idSelected,
    );
  }
}

class EngagementInitial extends EngagementState {
  @override
  List<Object> get props => [];
}

class ActivitiesInitial extends EngagementState {
  @override
  List<Object> get props => [];
}

class EngagementLoading extends EngagementState {}

class ActivitiesLoading extends EngagementState {}

class EngagementSuccessful extends EngagementState {
  @override
  List<Object?> get props => [];
}

class ActivitiesSuccessful extends EngagementState {
  @override
  List<Object?> get props => [];
}

class EngagementError extends EngagementState {}

class ActivitiesError extends EngagementState {}

class EngagementNoData extends EngagementState {}

class ActivitiesNoData extends EngagementState {}
