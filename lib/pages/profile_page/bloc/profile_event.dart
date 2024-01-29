part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfilesEvent extends ProfileEvent {
}

class GetProfileEvent extends ProfileEvent {
  final int profileId;

  GetProfileEvent(this.profileId);

  @override
  List<Object?> get props => [profileId];
}

class PostProfileEvent extends ProfileEvent {
  final Map<String, dynamic> profile;
  final int profileId;

  PostProfileEvent(this.profile, this.profileId);

  @override
  List<Object?> get props => [profileId, profile];
}

class PutProfileEvent extends ProfileEvent {
  final int profileId;
  final Map<String, dynamic> profile;

  PutProfileEvent(
      this.profileId,
      this.profile,
      );

  @override
  List<Object?> get props => [profileId, profile];
}

class DeleteProfileEvent extends ProfileEvent {
  final int profileId;

  DeleteProfileEvent(this.profileId);

  @override
  List<Object?> get props => [profileId];
}
