import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/data/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:dartz/dartz.dart';

class GetSignedInUser with UseCases<ApiResult<Option<User>>, NoParams> {
  final AuthenticationRepo _repo;

  GetSignedInUser(this._repo);

  @override
  Future<ApiResult<Option<User>>> call(NoParams params) {
    return _repo.getSignedInUser();
  }
}
