import 'package:frontend/core/index.dart';
import 'package:frontend/features/overview/data/index.dart';
import 'package:frontend/features/overview/index.dart';

/// Defines a contract/template for classes impelementing the [OverviewRepo].
abstract class OverviewRepo {
  Future<ApiResult<AnalyticsResponse>> getAnalytics(GetAnalyticsParam params);
}
