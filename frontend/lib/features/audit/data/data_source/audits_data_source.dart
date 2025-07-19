import 'package:frontend/features/audit/index.dart';

/// Defines a contract/template for classes impelementing the [AuditsDataSource].
abstract class AuditsDataSource {
  Future<AuditResponse> getAllAudits(AuditParams params);
}
