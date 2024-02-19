part of 'engagement_bloc.dart';

enum EngagementStatus {
  initial,
  success,
  error,
  loading,
  selected,
  noData,
  notFound,
}

@immutable
class EngagementState extends Equatable {
  final List<SmartEngagement>? engagements;
  final SmartEngagement? engagement;
  final String? searchString;
  final EngagementStatus? status;
  final int? idSelected;

  const EngagementState({
    List<SmartEngagement>? engagements,
    this.engagement,
    this.searchString,
    this.status = EngagementStatus.initial,
    this.idSelected = 0,
  }) : engagements = engagements ?? const [];

  @override
  List<Object?> get props => [
        engagements,
        engagement,
        searchString,
        status,
        idSelected,
      ];

  EngagementState copyWith({
    List<SmartEngagement>? engagements,
    SmartEngagement? engagement,
    String? searchString,
    EngagementStatus? status,
    int? idSelected,
  }) {
    return EngagementState(
      engagements: engagements,
      engagement: engagement,
      searchString: searchString,
      status: status,
      idSelected: idSelected,
    );
  }
}
