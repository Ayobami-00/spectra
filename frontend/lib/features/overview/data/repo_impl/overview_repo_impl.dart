// ignore_for_file: unused_field

import 'package:frontend/core/api/index.dart';
import 'package:frontend/features/overview/data/data_source/overview_data_source.dart';
import 'package:frontend/features/overview/data/models/analytics_response.dart';
import 'package:frontend/features/overview/domain/params/get_analytics_params.dart';
import 'package:frontend/features/overview/domain/repositories/overview_repo.dart';

class OverviewRepoImpl extends OverviewRepo {
  final OverviewDataSource _overviewDataSource;
  OverviewRepoImpl(
    this._overviewDataSource,
  );

  @override
  Future<ApiResult<AnalyticsResponse>> getAnalytics(GetAnalyticsParam params) {
    return apiInterceptor(
      _overviewDataSource.getAnalytics(params),
    );
  }
}
