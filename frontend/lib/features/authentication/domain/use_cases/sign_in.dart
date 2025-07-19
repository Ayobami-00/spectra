import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:dartz/dartz.dart';

class SignIn with UseCases<ApiResult<Option<Unit>>, SignInParam> {
  final AuthenticationRepo _repo;

  SignIn(this._repo);

  @override
  Future<ApiResult<Option<Unit>>> call(SignInParam params) {
    return _repo.signIn(params);
  }
}
