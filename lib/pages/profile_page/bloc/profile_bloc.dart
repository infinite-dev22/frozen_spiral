import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/database/user/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

// class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
//   ProfileBloc() : super(const ProfileState()) {
//     on<GetProfilesEvent>(_mapGetProfilesEventToState);
//     on<GetProfileEvent>(_mapGetProfileEventToState);
//     on<PostProfileEvent>(_mapPostProfileEventToState);
//     on<PutProfileEvent>(_mapPutProfileEventToState);
//   }
//
//   Future<FutureOr<void>> _mapGetProfilesEventToState(
//       GetProfilesEvent event, Emitter<ProfileState> emit) async {
//     emit(state.copyWith(status: ProfileStatus.profilesLoading));
//     await EmployeeApi.fetchAll().then((profiles) {
//       emit(state.copyWith(status: ProfileStatus.profilesSuccess, profiles: profiles));
//     }).onError((error, stackTrace) {
//       if (kDebugMode) {
//         print(error);
//         print(stackTrace);
//       }
//       emit(state.copyWith(status: ProfileStatus.profilesSuccess));
//     });
//   }
//
//   Future<FutureOr<void>> _mapGetProfileEventToState(
//       GetProfileEvent event, Emitter<ProfileState> emit) async {
//     emit(state.copyWith(status: ProfileStatus.profilesLoading));
//     await EmployeeApi.fetch(event.profileId).then((profile) {
//       emit(state.copyWith(status: ProfileStatus.profileSuccess, profile: profile));
//     }).onError((error, stackTrace) {
//       if (kDebugMode) {
//         print(error);
//         print(stackTrace);
//       }
//       emit(state.copyWith(status: ProfileStatus.profileSuccess));
//     });
//   }
//
//   Future<FutureOr<void>> _mapPostProfileEventToState(
//       PostProfileEvent event, Emitter<ProfileState> emit) async {
//     emit(state.copyWith(status: ProfileStatus.profilesLoading));
//     await EmployeeApi.post(event.profile, event.profileId).then((profile) {
//       emit(state.copyWith(status: ProfileStatus.profileSuccess, profile: profile));
//     }).onError((error, stackTrace) {
//       if (kDebugMode) {
//         print(error);
//         print(stackTrace);
//       }
//       emit(state.copyWith(status: ProfileStatus.profileSuccess));
//     });
//   }
//
//   Future<FutureOr<void>> _mapPutProfileEventToState(
//       PutProfileEvent event, Emitter<ProfileState> emit) async {
//     emit(state.copyWith(status: ProfileStatus.profilesLoading));
//     await EmployeeApi.put(event.profile, event.profileId).then((profile) {
//       emit(state.copyWith(status: ProfileStatus.profileSuccess, profile: profile));
//     }).onError((error, stackTrace) {
//       if (kDebugMode) {
//         print(error);
//         print(stackTrace);
//       }
//       emit(state.copyWith(status: ProfileStatus.profileSuccess));
//     });
//   }
// }
