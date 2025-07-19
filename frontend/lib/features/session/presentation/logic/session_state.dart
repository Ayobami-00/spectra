part of 'session_cubit.dart';

abstract class SessionState {
  const SessionState();

  @override
  List<Object> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionLoaded<T> extends SessionState {
  final T data;
  const SessionLoaded({
    required this.data,
  }) : super();
}

class SessionError extends SessionState {
  final String errorMessage;

  const SessionError(this.errorMessage);
}
