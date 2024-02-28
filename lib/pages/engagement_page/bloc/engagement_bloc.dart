import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/engagement/engagement_model.dart';
import 'package:smart_case/services/apis/smartcase_apis/engagement_api.dart';

part 'engagement_event.dart';
part 'engagement_state.dart';

class EngagementBloc extends Bloc<EngagementEvent, EngagementState> {
  EngagementBloc() : super(const EngagementState()) {
    on<GetEngagementsEvent>(_mapGetEngagementsEventToState);
    on<GetEngagementEvent>(_mapGetEngagementEventToState);
    on<PostEngagementEvent>(_mapPostEngagementEventToState);
    on<SearchEngagementEvent>(_mapSearchEngagementEventToState);
  }

  Future<FutureOr<void>> _mapGetEngagementsEventToState(
      GetEngagementsEvent event, Emitter<EngagementState> emit) async {
    emit(state.copyWith(status: EngagementStatus.loading));
    await EngagementApi.fetchAll().then((engagements) {
      if (engagements.isNotEmpty) {
        emit(state.copyWith(
            status: EngagementStatus.success, engagements: engagements));
      } else if (engagements.isEmpty) {
        emit(state.copyWith(status: EngagementStatus.noData));
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: EngagementStatus.error));
    });
  }

  Future<FutureOr<void>> _mapGetEngagementEventToState(
      GetEngagementEvent event, Emitter<EngagementState> emit) async {
    emit(state.copyWith(status: EngagementStatus.loading));
    await EngagementApi.fetch(event.engagementId).then((engagement) {
      emit(state.copyWith(
          status: EngagementStatus.success, engagement: engagement));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: EngagementStatus.loading));
    });
  }

  Future<FutureOr<void>> _mapPostEngagementEventToState(
      PostEngagementEvent event, Emitter<EngagementState> emit) async {
    emit(state.copyWith(status: EngagementStatus.loading));
    await EngagementApi.post(event.engagement, event.engagementId)
        .then((engagement) {
      emit(state.copyWith(
          status: EngagementStatus.success, engagement: engagement));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: EngagementStatus.loading));
    });
  }

  Future<FutureOr<void>> _mapSearchEngagementEventToState(
      SearchEngagementEvent event, Emitter<EngagementState> emit) async {
    emit(state.copyWith(status: EngagementStatus.initial));

    var engagements = preloadedEngagements
        .where((smartEngagement) =>
            smartEngagement.engagementType!
                .getName()
                .toLowerCase()
                .contains(event.search.toLowerCase()) ||
            (smartEngagement.cost ?? "")
                .toLowerCase()
                .contains(event.search.toLowerCase()) ||
            ((smartEngagement.doneBy!.isNotEmpty)
                ? smartEngagement.doneBy!.last
                    .getName()
                    .contains(event.search.toLowerCase())
                : false) ||
            (smartEngagement.costDescription ?? "")
                .toLowerCase()
                .contains(event.search.toLowerCase()) ||
            smartEngagement.date!
                .toString()
                .toLowerCase()
                .contains(event.search.toLowerCase()) ||
            smartEngagement.client!
                .getName()
                .toLowerCase()
                .contains(event.search.toLowerCase()))
        .toList();
    if (engagements.isNotEmpty) {
      emit(state.copyWith(
          status: EngagementStatus.success,
          engagements: engagements,
          searchString: event.search));
    } else if (engagements.isEmpty) {
      emit(state.copyWith(
          status: EngagementStatus.notFound, searchString: event.search));
    }
  }

  @override
  void onChange(Change<EngagementState> change) {
    super.onChange(change);
    if (kDebugMode) {
      log("Change: $change");
    }
  }

  @override
  void onEvent(EngagementEvent event) {
    super.onEvent(event);
    if (kDebugMode) {
      log("Event: $event");
    }
  }

  @override
  void onTransition(Transition<EngagementEvent, EngagementState> transition) {
    super.onTransition(transition);
    if (kDebugMode) {
      log("Transition: $transition");
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    if (kDebugMode) {
      log("Error: $error");
      log("StackTrace: $stackTrace");
    }
  }
}
