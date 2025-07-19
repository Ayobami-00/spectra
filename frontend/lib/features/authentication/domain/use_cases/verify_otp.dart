import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/data/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';

class VerifyOtp
    with UseCases<ApiResult<OtpVerificationResponse>, VerifyOtpParam> {
  final AuthenticationRepo _repo;

  VerifyOtp(this._repo);

  @override
  Future<ApiResult<OtpVerificationResponse>> call(VerifyOtpParam params) {
    return _repo.verifyOtp(params);
  }
}
