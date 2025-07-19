// ignore_for_file: unused_field

import 'package:frontend/core/api/api_client/index.dart';
import 'package:frontend/features/overview/data/index.dart';
import 'package:frontend/features/overview/domain/params/get_analytics_params.dart';

class OverviewDataSourceImpl implements OverviewDataSource {
  static const _getAnalyticsPath = '/v1/analytics';

  final FeApiClient _apiClient;
  final String _baseApiUrl;

  OverviewDataSourceImpl(
    this._apiClient,
    this._baseApiUrl,
  );

  @override
  Future<AnalyticsResponse> getAnalytics(GetAnalyticsParam params) async {
    final response = await _apiClient.get(
      '$_baseApiUrl$_getAnalyticsPath?analytics_id=${params.analyticsId}',
    );

    return AnalyticsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
