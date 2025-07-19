import 'package:frontend/features/overview/data/index.dart';
import 'package:frontend/features/overview/domain/index.dart';

/// Defines a contract/template for classes impelementing the [OverviewDataSource].
abstract class OverviewDataSource {
  Future<AnalyticsResponse> getAnalytics(GetAnalyticsParam params);
}
