import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/data/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:dartz/dartz.dart';

class GetUserByEmail with UseCases<ApiResult<Option<User>>, String> {
  final AuthenticationRepo _repo;

  GetUserByEmail(this._repo);

  @override
  Future<ApiResult<Option<User>>> call(String email) {
    return _repo.getUserByEmail(email);
  }
}
