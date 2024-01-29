import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<GetHomesEvent>(_mapGetHomesEventToState);
    on<GetHomeEvent>(_mapGetHomeEventToState);
    on<PostHomeEvent>(_mapPostHomeEventToState);
    on<PutHomeEvent>(_mapPutHomeEventToState);
  }

  Future<FutureOr<void>> _mapGetHomesEventToState(
      GetHomesEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.filesLoading));
    try {
      emit(state.copyWith(status: HomeStatus.filesSuccess));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(status: HomeStatus.filesSuccess));
    }
  }

  Future<FutureOr<void>> _mapGetHomeEventToState(
      GetHomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.filesLoading));
    try {
      emit(state.copyWith(status: HomeStatus.filesSuccess));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(status: HomeStatus.filesSuccess));
    }
  }

  Future<FutureOr<void>> _mapPostHomeEventToState(
      PostHomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.filesLoading));
    try {
      emit(state.copyWith(status: HomeStatus.filesSuccess));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(status: HomeStatus.filesSuccess));
    }
  }

  Future<FutureOr<void>> _mapPutHomeEventToState(
      PutHomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.filesLoading));
    try {
      emit(state.copyWith(status: HomeStatus.filesSuccess));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(status: HomeStatus.filesSuccess));
    }
  }
}
