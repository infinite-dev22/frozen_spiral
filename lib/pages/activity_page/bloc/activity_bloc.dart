import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/services/apis/smartcase_apis/activity_api.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(const ActivityState()) {
    on<GetActivitiesEvent>(_mapGetActivitiesEventToState);
    on<GetActivityEvent>(_mapGetActivityEventToState);
    on<PostActivityEvent>(_mapPostActivityEventToState);
    on<PutActivityEvent>(_mapPutActivityEventToState);
    on<DeleteActivityEvent>(_mapDeleteActivityEventToState);
  }

  Future<FutureOr<void>> _mapGetActivitiesEventToState(
      GetActivitiesEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.activitiesLoading));
    await ActivityApi.fetchAll().then((activities) {
      emit(state.copyWith(
          status: ActivityStatus.activitiesSuccess, activities: activities));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: ActivityStatus.activitiesSuccess));
    });
  }

  Future<FutureOr<void>> _mapGetActivityEventToState(
      GetActivityEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.activitiesLoading));
    await ActivityApi.fetch(event.fileId, event.activityId).then((activity) {
      emit(state.copyWith(
          status: ActivityStatus.activitySuccess, activity: activity));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: ActivityStatus.activitySuccess));
    });
  }

  Future<FutureOr<void>> _mapPostActivityEventToState(
      PostActivityEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.activitiesLoading));
    await ActivityApi.post(event.activity, event.fileId).then((activity) {
      emit(state.copyWith(
          status: ActivityStatus.activitySuccess, activity: activity));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: ActivityStatus.activitySuccess));
    });
  }

  Future<FutureOr<void>> _mapPutActivityEventToState(
      PutActivityEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.activitiesLoading));
    await ActivityApi.put(event.activity, event.fileId, event.fileId)
        .then((activity) {
      emit(state.copyWith(
          status: ActivityStatus.activitySuccess, activity: activity));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: ActivityStatus.activitySuccess));
    });
  }

  Future<FutureOr<void>> _mapDeleteActivityEventToState(
      DeleteActivityEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.activitiesLoading));
    await ActivityApi.delete(event.fileId, event.fileId).whenComplete(() {
      emit(state.copyWith(status: ActivityStatus.activitySuccess));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: ActivityStatus.activitySuccess));
    });
  }
}
