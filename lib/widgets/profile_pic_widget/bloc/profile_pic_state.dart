part of 'profile_pic_bloc.dart';

// Just some preferred state design, it's a personal preference.
enum ProfilePicStatus { initial, success, error, loading, selected, noData }

extension ProfilePicStatusX on ProfilePicStatus {
  bool get isInitial => this == ProfilePicStatus.initial;

  bool get isSuccess => this == ProfilePicStatus.success;

  bool get isError => this == ProfilePicStatus.error;

  bool get isLoading => this == ProfilePicStatus.loading;
}

@immutable
class ProfilePicState extends Equatable {
  final File? file;
  final String? imageUrl;
  final ProfilePicStatus status;

  const ProfilePicState({
    this.file,
    this.imageUrl,
    this.status = ProfilePicStatus.initial,
  });

  @override
  List<Object?> get props => [
        file,
        imageUrl,
        status,
      ];

  ProfilePicState copyWith({
    File? file,
    String? imageUrl,
    ProfilePicStatus? status,
  }) {
    return ProfilePicState(
      file: file ?? this.file,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
    );
  }
}

class ProfilePicInitial extends ProfilePicState {}

class ProfilePicLoading extends ProfilePicState {}

class ProfilePicError extends ProfilePicState {}

class ProfilePicNoData extends ProfilePicState {}

class ProfilePicSuccess extends ProfilePicState {}
