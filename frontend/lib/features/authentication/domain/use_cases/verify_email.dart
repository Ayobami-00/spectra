import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/data/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';

class VerifyEmail
    with UseCases<ApiResult<EmailVerificationResponse>, PostEmailParam> {
  final AuthenticationRepo _repo;

  VerifyEmail(this._repo);

  @override
  Future<ApiResult<EmailVerificationResponse>> call(PostEmailParam params) {
    return _repo.verifyEmail(params);
  }
}
