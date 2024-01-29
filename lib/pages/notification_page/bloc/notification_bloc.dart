import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/database/local/notifications.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<GetNotificationsEvent>(_mapGetNotificationsEventToState);
    on<GetNotificationEvent>(_mapGetNotificationEventToState);
    on<PostNotificationEvent>(_mapPostNotificationEventToState);
    on<PutNotificationEvent>(_mapPutNotificationEventToState);
  }

  Future<FutureOr<void>> _mapGetNotificationsEventToState(
      GetNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(status: NotificationStatus.notificationsLoading));
    try {
      emit(state.copyWith(status: NotificationStatus.notificationsSuccess));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(status: NotificationStatus.notificationsSuccess));
    }
  }

  Future<FutureOr<void>> _mapGetNotificationEventToState(
      GetNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(status: NotificationStatus.notificationsLoading));
    try {
      emit(state.copyWith(status: NotificationStatus.notificationsSuccess));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(status: NotificationStatus.notificationsSuccess));
    }
  }

  Future<FutureOr<void>> _mapPostNotificationEventToState(
      PostNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(status: NotificationStatus.notificationsLoading));
    try {
      emit(state.copyWith(status: NotificationStatus.notificationsSuccess));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(status: NotificationStatus.notificationsSuccess));
    }
  }

  Future<FutureOr<void>> _mapPutNotificationEventToState(
      PutNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(status: NotificationStatus.notificationsLoading));
    try {
      emit(state.copyWith(status: NotificationStatus.notificationsSuccess));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(status: NotificationStatus.notificationsSuccess));
    }
  }
}
