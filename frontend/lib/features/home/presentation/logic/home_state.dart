part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded<T> extends HomeState {
  final T data;
  const HomeLoaded({
    required this.data,
  }) : super();
}

class HomeError extends HomeState {
  final String errorMessage;

  const HomeError(this.errorMessage);
}
