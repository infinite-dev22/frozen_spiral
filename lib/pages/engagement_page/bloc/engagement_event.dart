part of 'engagement_bloc.dart';

abstract class EngagementEvent extends Equatable {
  const EngagementEvent();

  @override
  List<Object?> get props => [];
}

class GetEngagementsEvent extends EngagementEvent {}

class GetEngagementEvent extends EngagementEvent {
  final int engagementId;

  const GetEngagementEvent(this.engagementId);

  @override
  List<Object?> get props => [engagementId];
}

class PostEngagementEvent extends EngagementEvent {
  final Map<String, dynamic> engagement;
  final int engagementId;

  const PostEngagementEvent(this.engagement, this.engagementId);

  @override
  List<Object?> get props => [engagementId, engagement];
}

class PutEngagementEvent extends EngagementEvent {
  final int engagementId;
  final Map<String, dynamic> engagement;

  const PutEngagementEvent(
    this.engagementId,
    this.engagement,
  );

  @override
  List<Object?> get props => [engagementId, engagement];
}

class DeleteEngagementEvent extends EngagementEvent {
  final int engagementId;

  const DeleteEngagementEvent(this.engagementId);

  @override
  List<Object?> get props => [engagementId];
}

class SearchEngagementEvent extends EngagementEvent {
  final String search;

  const SearchEngagementEvent(this.search);

  @override
  List<Object?> get props => [search];
}
