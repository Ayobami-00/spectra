part of 'tasks_cubit.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded<T> extends TasksState {
  final T data;
  const TasksLoaded({
    required this.data,
  }) : super();
}

class TasksError extends TasksState {
  final String errorMessage;

  const TasksError(this.errorMessage);
}
