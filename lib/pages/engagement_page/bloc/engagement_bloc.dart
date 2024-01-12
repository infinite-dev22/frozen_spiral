import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/database/engagement/engagement_model.dart';
import 'package:smart_case/services/apis/smartcase_apis/engagement_api.dart';

part 'engagement_event.dart';
part 'engagement_state.dart';

class EngagementBloc extends Bloc<EngagementEvent, EngagementState> {
  EngagementBloc() : super(const EngagementState()) {
    on<GetActivitiesEvent>(_mapGetActivitiesEventToState);
    on<GetEngagementEvent>(_mapGetEngagementEventToState);
    on<PostEngagementEvent>(_mapPostEngagementEventToState);
    on<PutEngagementEvent>(_mapPutEngagementEventToState);
    on<DeleteEngagementEvent>(_mapDeleteEngagementEventToState);
  }

  Future<FutureOr<void>> _mapGetActivitiesEventToState(
      GetActivitiesEvent event, Emitter<EngagementState> emit) async {
    emit(state.copyWith(status: EngagementStatus.engagementsLoading));
    await EngagementApi.fetchAll().then((engagements) {
      emit(state.copyWith(
          status: EngagementStatus.engagementsSuccess,
          engagements: engagements));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: EngagementStatus.engagementsSuccess));
    });
  }

  Future<FutureOr<void>> _mapGetEngagementEventToState(
      GetEngagementEvent event, Emitter<EngagementState> emit) async {
    emit(state.copyWith(status: EngagementStatus.engagementsLoading));
    await EngagementApi.fetch(event.engagementId).then((engagement) {
      emit(state.copyWith(
          status: EngagementStatus.engagementSuccess, engagement: engagement));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: EngagementStatus.engagementSuccess));
    });
  }

  Future<FutureOr<void>> _mapPostEngagementEventToState(
      PostEngagementEvent event, Emitter<EngagementState> emit) async {
    emit(state.copyWith(status: EngagementStatus.engagementsLoading));
    await EngagementApi.post(event.engagement, event.engagementId)
        .then((engagement) {
      emit(state.copyWith(
          status: EngagementStatus.engagementSuccess, engagement: engagement));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: EngagementStatus.engagementSuccess));
    });
  }

  Future<FutureOr<void>> _mapPutEngagementEventToState(
      PutEngagementEvent event, Emitter<EngagementState> emit) async {
    emit(state.copyWith(status: EngagementStatus.engagementsLoading));
    await EngagementApi.put(event.engagement, event.engagementId)
        .then((engagement) {
      emit(state.copyWith(
          status: EngagementStatus.engagementSuccess, engagement: engagement));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: EngagementStatus.engagementSuccess));
    });
  }

  Future<FutureOr<void>> _mapDeleteEngagementEventToState(
      DeleteEngagementEvent event, Emitter<EngagementState> emit) async {
    emit(state.copyWith(status: EngagementStatus.engagementsLoading));
    await EngagementApi.delete(event.engagementId).whenComplete(() {
      emit(state.copyWith(status: EngagementStatus.engagementSuccess));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: EngagementStatus.engagementSuccess));
    });
  }
}
