import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/database/task/task_model.dart';
import 'package:smart_case/services/apis/smartcase_apis/task_api.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskState()) {
    on<GetTasksEvent>(_mapGetTasksEventToState);
    on<GetTaskEvent>(_mapGetTaskEventToState);
    on<PostTaskEvent>(_mapPostTaskEventToState);
    on<PutTaskEvent>(_mapPutTaskEventToState);
  }

  Future<FutureOr<void>> _mapGetTasksEventToState(
      GetTasksEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.tasksLoading));
    await TaskApi.fetchAll().then((tasks) {
      emit(state.copyWith(status: TaskStatus.tasksSuccess, tasks: tasks));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: TaskStatus.tasksSuccess));
    });
  }

  Future<FutureOr<void>> _mapGetTaskEventToState(
      GetTaskEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.tasksLoading));
    await TaskApi.fetch(event.taskId).then((task) {
      emit(state.copyWith(status: TaskStatus.taskSuccess, task: task));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: TaskStatus.taskSuccess));
    });
  }

  Future<FutureOr<void>> _mapPostTaskEventToState(
      PostTaskEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.tasksLoading));
    await TaskApi.post(event.task, event.taskId).then((task) {
      emit(state.copyWith(status: TaskStatus.taskSuccess, task: task));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: TaskStatus.taskSuccess));
    });
  }

  Future<FutureOr<void>> _mapPutTaskEventToState(
      PutTaskEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.tasksLoading));
    await TaskApi.put(event.task, event.taskId).then((task) {
      emit(state.copyWith(status: TaskStatus.taskSuccess, task: task));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: TaskStatus.taskSuccess));
    });
  }
}
