import 'package:frontend/core/index.dart';
import 'package:frontend/features/audit/index.dart';

/// Defines a contract/template for classes impelementing the [AuditsRepo].
abstract class AuditsRepo {
  Future<ApiResult<AuditResponse>> getAllAudits(AuditParams params);
}
