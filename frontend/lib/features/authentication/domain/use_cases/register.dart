import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:dartz/dartz.dart';

class Register with UseCases<ApiResult<Option<Unit>>, RegisterParam> {
  final AuthenticationRepo _repo;

  Register(this._repo);

  @override
  Future<ApiResult<Option<Unit>>> call(
    RegisterParam params,
  ) {
    return _repo.register(params);
  }
}
