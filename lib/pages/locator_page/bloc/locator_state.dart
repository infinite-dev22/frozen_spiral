part of 'locator_bloc.dart';

enum LocatorStatus {
  initial,
  locatorSuccess,
  locatorsSuccess,
  locatorError,
  locatorsError,
  locatorLoading,
  locatorsLoading,
  selected,
  locatorNoData,
  locatorsNoData,
}

extension LocatorStatusX on LocatorStatus {
  bool get isInitial => this == LocatorStatus.initial;

  bool get locatorIsSuccess => this == LocatorStatus.locatorSuccess;

  bool get locatorsIsSuccess => this == LocatorStatus.locatorsSuccess;

  bool get locatorIsError => this == LocatorStatus.locatorError;

  bool get locatorsIsError => this == LocatorStatus.locatorsError;

  bool get locatorIsLoading => this == LocatorStatus.locatorLoading;

  bool get locatorsIsLoading => this == LocatorStatus.locatorsLoading;

  bool get locatorIsNoData => this == LocatorStatus.locatorNoData;

  bool get locatorsIsNoData => this == LocatorStatus.locatorsNoData;
}

@immutable
class LocatorState extends Equatable {
  final LocatorStatus? status;
  final int? idSelected;

  const LocatorState({
    this.status = LocatorStatus.initial,
    this.idSelected = 0,
  });

  @override
  List<Object?> get props => [
        status,
        idSelected,
      ];

  LocatorState copyWith({
    LocatorStatus? status,
    int? idSelected,
  }) {
    return LocatorState(
      status: status,
      idSelected: idSelected,
    );
  }
}

class LocatorInitial extends LocatorState {
  @override
  List<Object> get props => [];
}

class LocatorsInitial extends LocatorState {
  @override
  List<Object> get props => [];
}

class LocatorLoading extends LocatorState {}

class LocatorsLoading extends LocatorState {}

class LocatorSuccessful extends LocatorState {
  @override
  List<Object?> get props => [];
}

class LocatorsSuccessful extends LocatorState {
  @override
  List<Object?> get props => [];
}

class LocatorError extends LocatorState {}

class LocatorsError extends LocatorState {}

class LocatorNoData extends LocatorState {}

class LocatorsNoData extends LocatorState {}
