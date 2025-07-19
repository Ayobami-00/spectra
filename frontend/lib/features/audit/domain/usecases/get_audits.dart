import 'package:frontend/core/index.dart';
import 'package:frontend/features/audit/index.dart';

class GetAllAudits with UseCases<ApiResult<AuditResponse>, AuditParams> {
  final AuditsRepo _auditsRepo;
  GetAllAudits(
    this._auditsRepo,
  );

  @override
  Future<ApiResult<AuditResponse>> call(AuditParams params) {
    return _auditsRepo.getAllAudits(params);
  }
}
