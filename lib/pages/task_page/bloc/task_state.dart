part of 'task_bloc.dart';

enum TaskStatus {
  initial,
  taskSuccess,
  tasksSuccess,
  taskError,
  tasksError,
  taskLoading,
  tasksLoading,
  selected,
  taskNoData,
  tasksNoData,
}

extension TaskStatusX on TaskStatus {
  bool get isInitial => this == TaskStatus.initial;

  bool get taskIsSuccess => this == TaskStatus.taskSuccess;

  bool get tasksIsSuccess => this == TaskStatus.tasksSuccess;

  bool get taskIsError => this == TaskStatus.taskError;

  bool get tasksIsError => this == TaskStatus.tasksError;

  bool get taskIsLoading => this == TaskStatus.taskLoading;

  bool get tasksIsLoading => this == TaskStatus.tasksLoading;

  bool get taskIsNoData => this == TaskStatus.taskNoData;

  bool get tasksIsNoData => this == TaskStatus.tasksNoData;
}

@immutable
class TaskState extends Equatable {
  final List<SmartTask>? tasks;
  final SmartTask? task;
  final TaskStatus? status;
  final int? idSelected;

  const TaskState({
    List<SmartTask>? tasks,
    this.task,
    this.status = TaskStatus.initial,
    this.idSelected = 0,
  }) : tasks = tasks ?? const [];

  @override
  List<Object?> get props => [
    tasks,
    task,
    status,
    idSelected,
  ];

  TaskState copyWith({
    List<SmartTask>? tasks,
    SmartTask? task,
    TaskStatus? status,
    int? idSelected,
  }) {
    return TaskState(
      tasks: tasks,
      task: task,
      status: status,
      idSelected: idSelected,
    );
  }
}

class TaskInitial extends TaskState {
  @override
  List<Object> get props => [];
}

class TasksInitial extends TaskState {
  @override
  List<Object> get props => [];
}

class TaskLoading extends TaskState {}

class TasksLoading extends TaskState {}

class TaskSuccessful extends TaskState {
  @override
  List<Object?> get props => [];
}

class TasksSuccessful extends TaskState {
  @override
  List<Object?> get props => [];
}

class TaskError extends TaskState {}

class TasksError extends TaskState {}

class TaskNoData extends TaskState {}

class TasksNoData extends TaskState {}

