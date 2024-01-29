part of 'locator_bloc.dart';

abstract class LocatorEvent extends Equatable {
  const LocatorEvent();

  @override
  List<Object?> get props => [];
}

class GetLocatorsEvent extends LocatorEvent {}

class GetLocatorEvent extends LocatorEvent {
  final int locatorId;

  GetLocatorEvent(this.locatorId);

  @override
  List<Object?> get props => [locatorId];
}

class PostLocatorEvent extends LocatorEvent {
  final Map<String, dynamic> locator;
  final int locatorId;

  PostLocatorEvent(this.locator, this.locatorId);

  @override
  List<Object?> get props => [locatorId, locator];
}

class PutLocatorEvent extends LocatorEvent {
  final int locatorId;
  final Map<String, dynamic> locator;

  PutLocatorEvent(
    this.locatorId,
    this.locator,
  );

  @override
  List<Object?> get props => [locatorId, locator];
}

class DeleteLocatorEvent extends LocatorEvent {
  final int locatorId;

  DeleteLocatorEvent(this.locatorId);

  @override
  List<Object?> get props => [locatorId];
}
