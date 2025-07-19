import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:dartz/dartz.dart';

class SendOtp with UseCases<ApiResult<Option<bool>>, PostEmailParam> {
  final AuthenticationRepo _repo;

  SendOtp(this._repo);

  @override
  Future<ApiResult<Option<bool>>> call(PostEmailParam params) {
    return _repo.sendOtp(params);
  }
}
