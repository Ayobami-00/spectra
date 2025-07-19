import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:dartz/dartz.dart';

class UpdateDeviceInfo with UseCases<ApiResult<Option<bool>>, NoParams> {
  final AuthenticationRepo _repo;

  UpdateDeviceInfo(this._repo);

  @override
  Future<ApiResult<Option<bool>>> call(
    NoParams params,
  ) {
    return _repo.updateDeviceInfo();
  }
}
