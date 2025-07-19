// ignore_for_file: unused_field

import 'package:frontend/core/index.dart';
import 'package:frontend/features/audit/index.dart';

class AuditsRepoImpl extends AuditsRepo {
  final AuditsDataSource _customerDataSource;
  AuditsRepoImpl(
    this._customerDataSource,
  );

  @override
  Future<ApiResult<AuditResponse>> getAllAudits(AuditParams params) {
    return apiInterceptor(
      _customerDataSource.getAllAudits(params),
    );
  }
}
