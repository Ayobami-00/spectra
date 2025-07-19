part of 'audits_cubit.dart';

abstract class AuditsState extends Equatable {
  const AuditsState();

  @override
  List<Object> get props => [];
}

class AuditsInitial extends AuditsState {}

class AuditsLoading extends AuditsState {}

class AuditsLoaded<T> extends AuditsState {
  final T data;
  const AuditsLoaded({
    required this.data,
  }) : super();
}

class AuditsError extends AuditsState {
  final AuditResponse errorMessage;

  const AuditsError(this.errorMessage);
}
