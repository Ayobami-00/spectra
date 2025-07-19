import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/data/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';
import 'package:dartz/dartz.dart';

class GetUserByUsername with UseCases<ApiResult<Option<User>>, String> {
  final AuthenticationRepo _repo;

  GetUserByUsername(this._repo);

  @override
  Future<ApiResult<Option<User>>> call(String username) {
    return _repo.getUserByUsername(username);
  }
}
