import 'package:frontend/core/index.dart';
import 'package:frontend/features/authentication/domain/index.dart';

class SignOut with UseCases<ApiResult<void>, NoParams> {
  final AuthenticationRepo _repo;

  SignOut(this._repo);

  @override
  Future<ApiResult<void>> call(NoParams params) {
    return _repo.signOut();
  }
}
