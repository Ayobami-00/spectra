part of 'overview_cubit.dart';

abstract class OverviewState extends Equatable {
  const OverviewState();

  @override
  List<Object> get props => [];
}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewLoaded<T> extends OverviewState {
  final T data;
  const OverviewLoaded({
    required this.data,
  }) : super();
}

class OverviewError extends OverviewState {
  final String errorMessage;

  const OverviewError(this.errorMessage);
}
