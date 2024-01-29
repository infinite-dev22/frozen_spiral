part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class GetTasksEvent extends TaskEvent {
}

class GetTaskEvent extends TaskEvent {
  final int taskId;

  GetTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class PostTaskEvent extends TaskEvent {
  final Map<String, dynamic> task;
  final int taskId;

  PostTaskEvent(this.task, this.taskId);

  @override
  List<Object?> get props => [taskId, task];
}

class PutTaskEvent extends TaskEvent {
  final int taskId;
  final Map<String, dynamic> task;

  PutTaskEvent(
      this.taskId,
      this.task,
      );

  @override
  List<Object?> get props => [taskId, task];
}

class DeleteTaskEvent extends TaskEvent {
  final int taskId;

  DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
