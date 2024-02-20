import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
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
    on<SearchActivityEvent>(_mapSearchActivityEventToState);
  }

  Future<FutureOr<void>> _mapGetActivitiesEventToState(
      GetActivitiesEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.loading));
    await ActivityApi.fetchAll().then((activities) {
      emit(state.copyWith(
          status: ActivityStatus.success, activities: activities));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: ActivityStatus.error));
    });
  }

  Future<FutureOr<void>> _mapGetActivityEventToState(
      GetActivityEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.loading));
    await ActivityApi.fetch(event.fileId, event.activityId).then((activity) {
      emit(state.copyWith(status: ActivityStatus.success, activity: activity));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: ActivityStatus.error));
    });
  }

  Future<FutureOr<void>> _mapPostActivityEventToState(
      PostActivityEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.loading));
    await ActivityApi.post(event.activity, event.fileId).then((activity) {
      emit(state.copyWith(status: ActivityStatus.success, activity: activity));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: ActivityStatus.error));
    });
  }

  Future<FutureOr<void>> _mapPutActivityEventToState(
      PutActivityEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.loading));
    await ActivityApi.put(event.activity, event.fileId, event.fileId)
        .then((activity) {
      emit(state.copyWith(status: ActivityStatus.success, activity: activity));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: ActivityStatus.error));
    });
  }

  Future<FutureOr<void>> _mapDeleteActivityEventToState(
      DeleteActivityEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.loading));
    await ActivityApi.delete(event.fileId, event.fileId).whenComplete(() {
      emit(state.copyWith(status: ActivityStatus.success));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: ActivityStatus.error));
    });
  }

  Future<FutureOr<void>> _mapSearchActivityEventToState(
      SearchActivityEvent event, Emitter<ActivityState> emit) async {
    emit(state.copyWith(status: ActivityStatus.initial));

    var activities = preloadedActivities
        .where((smartActivity) =>
            smartActivity
                .getName()
                .toLowerCase()
                .contains(event.search.toLowerCase()) ||
            smartActivity.file!
                .getName()
                .toLowerCase()
                .contains(event.search.toLowerCase()) ||
            smartActivity.date!
                .toString()
                .toLowerCase()
                .contains(event.search.toLowerCase()) ||
            smartActivity.employee!
                .getName()
                .toLowerCase()
                .contains(event.search.toLowerCase()) ||
            smartActivity.caseActivityStatus!
                .getName()
                .toLowerCase()
                .contains(event.search.toLowerCase()) ||
            smartActivity.date!.toString().contains(event.search.toLowerCase()))
        .toList();
    if (activities.isNotEmpty) {
      emit(state.copyWith(
          status: ActivityStatus.success, activities: activities, searchString: event.search));
    } else if (activities.isEmpty) {
      emit(state.copyWith(
          status: ActivityStatus.notFound, searchString: event.search));
    }
  }

  @override
  void onChange(Change<ActivityState> change) {
    super.onChange(change);
    if (kDebugMode) {
      print("Change: $change");
    }
  }

  @override
  void onEvent(ActivityEvent event) {
    super.onEvent(event);
    if (kDebugMode) {
      print("Event: $event");
    }
  }

  @override
  void onTransition(Transition<ActivityEvent, ActivityState> transition) {
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
