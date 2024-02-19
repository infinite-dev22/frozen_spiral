import 'dart:async';

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
      emit(state.copyWith(
          status: EngagementStatus.success, engagements: engagements));
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
            smartEngagement.cost!
                .toLowerCase()
                .contains(event.search.toLowerCase()) ||
            smartEngagement.doneBy!.last
                .getName()
                .contains(event.search.toLowerCase()) ||
            smartEngagement.costDescription!
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
          status: EngagementStatus.success, engagements: engagements));
    } else if (engagements.isNotEmpty) {
      emit(state.copyWith(
          status: EngagementStatus.notFound, searchString: event.search));
    }
  }
}
