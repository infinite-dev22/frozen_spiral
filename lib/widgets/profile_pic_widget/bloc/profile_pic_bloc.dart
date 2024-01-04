import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
// import 'package:smart_case/services/apis/smartcase_apis/employee_api.dart';
import 'package:smart_case/util/smart_case_init.dart';

part 'profile_pic_event.dart';
part 'profile_pic_state.dart';

class ProfilePicBloc extends Bloc<ProfilePicEvent, ProfilePicState> {
  ProfilePicBloc() : super(const ProfilePicState()) {
    on<GetProfilePic>(_mapGetProfilePicEventToState);
    on<UpdateProfilePic>(_mapUpdateProfilePicEventToState);
  }

  _mapGetProfilePicEventToState(
      GetProfilePic event, Emitter<ProfilePicState> emit) {
    try {
      print(currentUserAvatar);
      emit(state.copyWith(
          status: ProfilePicStatus.success, imageUrl: currentUserAvatar));
    } catch (e) {
      emit(state.copyWith(status: ProfilePicStatus.error));
    }
  }

  _mapUpdateProfilePicEventToState(
      UpdateProfilePic event, Emitter<ProfilePicState> emit) async {
    emit(state.copyWith(status: ProfilePicStatus.loading));
    await SmartCaseApi.uploadProfilePicture(event.file).whenComplete(() {
      currentUserAvatar = currentUser.avatar;
      var rand = Random(2024).nextInt(2024);
      emit(state.copyWith(
          status: ProfilePicStatus.success, imageUrl: currentUserAvatar));
    }).onError((error, stackTrace) =>
        emit(state.copyWith(status: ProfilePicStatus.error)));
  }

  // _mapGetProfilePicEventToState(
  //     GetProfilePic event, Emitter<ProfilePicState> emit) async {
  //   emit(state.copyWith(status: ProfilePicStatus.loading));
  //   await EmployeeApi.getUserAvatar().then((value) {
  //     return emit(
  //         state.copyWith(status: ProfilePicStatus.success, file: value));
  //   }).onError((error, stackTrace) {
  //     print(error);
  //     print(stackTrace);
  //     emit(state.copyWith(status: ProfilePicStatus.error));
  //   });
  // }
  //
  // _mapUpdateProfilePicEventToState(
  //     UpdateProfilePic event, Emitter<ProfilePicState> emit) async {
  //   emit(state.copyWith(status: ProfilePicStatus.loading));
  //   await SmartCaseApi.uploadProfilePicture(event.file).whenComplete(() {
  //     currentUserAvatar = currentUser.avatar;
  //     emit(state.copyWith(status: ProfilePicStatus.success));
  //   }).onError((error, stackTrace) =>
  //       emit(state.copyWith(status: ProfilePicStatus.error)));
  // }

  @override
  void onChange(Change<ProfilePicState> change) {
    super.onChange(change);
    if (kDebugMode) {
      print("Change: $change");
    }
  }

  @override
  void onEvent(ProfilePicEvent event) {
    super.onEvent(event);
    if (kDebugMode) {
      print("Event: $event");
    }
  }

  @override
  void onTransition(Transition<ProfilePicEvent, ProfilePicState> transition) {
    super.onTransition(transition);
    if (kDebugMode) {
      print("Transition: $transition");
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    if (kDebugMode) {
      print("Error: $error");
      print("StackTrace: $stackTrace");
    }
  }
}
