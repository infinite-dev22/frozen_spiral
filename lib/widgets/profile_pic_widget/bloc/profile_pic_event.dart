part of 'profile_pic_bloc.dart';

@immutable
abstract class ProfilePicEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProfilePic extends ProfilePicEvent {}

class UpdateProfilePic extends ProfilePicEvent {
  UpdateProfilePic(this.file);

  final File file;

  @override
  List<Object?> get props => [file];
}

class Success extends ProfilePicEvent {}
