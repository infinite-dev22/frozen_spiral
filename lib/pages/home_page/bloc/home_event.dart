part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetHomesEvent extends HomeEvent {
}

class GetHomeEvent extends HomeEvent {
  final int homeId;

  GetHomeEvent(this.homeId);

  @override
  List<Object?> get props => [homeId];
}

class PostHomeEvent extends HomeEvent {
  final Map<String, dynamic> home;
  final int homeId;

  PostHomeEvent(this.home, this.homeId);

  @override
  List<Object?> get props => [homeId, home];
}

class PutHomeEvent extends HomeEvent {
  final int homeId;
  final Map<String, dynamic> home;

  PutHomeEvent(
      this.homeId,
      this.home,
      );

  @override
  List<Object?> get props => [homeId, home];
}

class DeleteHomeEvent extends HomeEvent {
  final int homeId;

  DeleteHomeEvent(this.homeId);

  @override
  List<Object?> get props => [homeId];
}
