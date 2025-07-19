import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:dartz/dartz.dart';

class SendPasswordResetEmail
    with UseCases<ApiResult<Option<bool>>, PostEmailParam> {
  final AuthenticationRepo _repo;

  SendPasswordResetEmail(this._repo);

  @override
  Future<ApiResult<Option<bool>>> call(PostEmailParam params) {
    return _repo.sendPasswordResetEmail(params);
  }
}
