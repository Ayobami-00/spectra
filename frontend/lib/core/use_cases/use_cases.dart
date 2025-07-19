import 'package:equatable/equatable.dart';

///[Future].
mixin UseCases<T, Params> {
  Future<T> call(Params params);
}

///[Streams].
mixin StreamUseCases<T, Params> {
  Stream<T> call(Params params);
}

///[NoParams]
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
