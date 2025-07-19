part of 'core_cubit.dart';

abstract class CoreState extends Equatable {
  const CoreState();

  @override
  List<Object> get props => [];
}

class CoreInitial extends CoreState {}

class CoreLoading extends CoreState {}


class CoreAccountsStatusLoading extends CoreState {}

class CoreAccountsBalanceLoading extends CoreState {}

class CoreLoaded<T> extends CoreState {
  final T data;
  const CoreLoaded({
    required this.data,
  }) : super();
}



class CoreImageUploadLoaded<T> extends CoreState {
  final T data;
  const CoreImageUploadLoaded({
    required this.data,
  }) : super();
}

class CoreAccountsStatusLoaded<T> extends CoreState {
  final T data;
  const CoreAccountsStatusLoaded({
    required this.data,
  }) : super();
}

class CoreAccountsBalanceLoaded<T> extends CoreState {
  final T data;
  const CoreAccountsBalanceLoaded({
    required this.data,
  }) : super();
}

class CoreError extends CoreState {
  final String errorMessage;

  const CoreError(this.errorMessage);
}



class CoreAccountsStatusError extends CoreState {
  final String errorMessage;

  const CoreAccountsStatusError(this.errorMessage);
}

class CoreAccountsBalanceError extends CoreState {
  final String errorMessage;

  const CoreAccountsBalanceError(this.errorMessage);
}
