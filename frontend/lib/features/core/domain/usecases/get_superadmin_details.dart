import 'package:frontend/core/index.dart';
import 'package:frontend/features/core/data/index.dart';
import 'package:frontend/features/core/domain/index.dart';

class GetSuperadminDetails
    with UseCases<ApiResult<SuperadminDetails>, NoParams> {
  final CoreRepo _repo;

  GetSuperadminDetails(this._repo);

  @override
  Future<ApiResult<SuperadminDetails>> call(NoParams params) {
    return _repo.getSuperadminDetails();
  }
}
