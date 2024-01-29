part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  fileSuccess,
  filesSuccess,
  fileError,
  filesError,
  fileLoading,
  filesLoading,
  selected,
  fileNoData,
  filesNoData,
}

extension HomeStatusX on HomeStatus {
  bool get isInitial => this == HomeStatus.initial;

  bool get fileIsSuccess => this == HomeStatus.fileSuccess;

  bool get filesIsSuccess => this == HomeStatus.filesSuccess;

  bool get fileIsError => this == HomeStatus.fileError;

  bool get filesIsError => this == HomeStatus.filesError;

  bool get fileIsLoading => this == HomeStatus.fileLoading;

  bool get filesIsLoading => this == HomeStatus.filesLoading;

  bool get fileIsNoData => this == HomeStatus.fileNoData;

  bool get filesIsNoData => this == HomeStatus.filesNoData;
}

@immutable
class HomeState extends Equatable {
  final HomeStatus? status;
  final int? idSelected;

  const HomeState({
    this.status = HomeStatus.initial,
    this.idSelected = 0,
  });

  @override
  List<Object?> get props => [
        status,
        idSelected,
      ];

  HomeState copyWith({
    HomeStatus? status,
    int? idSelected,
  }) {
    return HomeState(
      status: status,
      idSelected: idSelected,
    );
  }
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class ActivitiesInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class ActivitiesLoading extends HomeState {}

class HomeSuccessful extends HomeState {
  @override
  List<Object?> get props => [];
}

class ActivitiesSuccessful extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeError extends HomeState {}

class ActivitiesError extends HomeState {}

class HomeNoData extends HomeState {}

class ActivitiesNoData extends HomeState {}
