part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  userSuccess,
  usersSuccess,
  userError,
  usersError,
  userLoading,
  usersLoading,
  selected,
  userNoData,
  usersNoData,
}

extension ProfileStatusX on ProfileStatus {
  bool get isInitial => this == ProfileStatus.initial;

  bool get userIsSuccess => this == ProfileStatus.userSuccess;

  bool get usersIsSuccess => this == ProfileStatus.usersSuccess;

  bool get userIsError => this == ProfileStatus.userError;

  bool get usersIsError => this == ProfileStatus.usersError;

  bool get userIsLoading => this == ProfileStatus.userLoading;

  bool get usersIsLoading => this == ProfileStatus.usersLoading;

  bool get userIsNoData => this == ProfileStatus.userNoData;

  bool get usersIsNoData => this == ProfileStatus.usersNoData;
}

@immutable
class ProfileState extends Equatable {
  final List<SmartUser>? users;
  final SmartUser? user;
  final ProfileStatus? status;
  final int? idSelected;

  const ProfileState({
    List<SmartUser>? users,
    this.user,
    this.status = ProfileStatus.initial,
    this.idSelected = 0,
  }) : users = users ?? const [];

  @override
  List<Object?> get props => [
    users,
    user,
    status,
    idSelected,
  ];

  ProfileState copyWith({
    List<SmartUser>? users,
    SmartUser? user,
    ProfileStatus? status,
    int? idSelected,
  }) {
    return ProfileState(
      users: users,
      user: user,
      status: status,
      idSelected: idSelected,
    );
  }
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfilesInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfilesLoading extends ProfileState {}

class ProfileSuccessful extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfilesSuccessful extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileError extends ProfileState {}

class ProfilesError extends ProfileState {}

class ProfileNoData extends ProfileState {}

class ProfilesNoData extends ProfileState {}

