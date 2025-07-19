import 'package:frontend/core/index.dart';
import 'package:frontend/features/overview/data/index.dart';
import 'package:frontend/features/overview/index.dart';

class GetAnalytics
    with UseCases<ApiResult<AnalyticsResponse>, GetAnalyticsParam> {
  final OverviewRepo _repo;

  GetAnalytics(this._repo);

  @override
  Future<ApiResult<AnalyticsResponse>> call(GetAnalyticsParam params) {
    return _repo.getAnalytics(params);
  }
}
