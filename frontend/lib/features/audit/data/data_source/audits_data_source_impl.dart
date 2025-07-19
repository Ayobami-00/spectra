// ignore_for_file: unused_field

import 'package:frontend/core/api/api_client/index.dart';
import 'package:frontend/features/audit/index.dart';

class AuditsDataSourceImpl implements AuditsDataSource {
  static const _getAllAuditsPath = '/v1/audits';
  final FeApiClient _apiClient;
  final String _baseApiUrl;

  AuditsDataSourceImpl(
    this._apiClient,
    this._baseApiUrl,
  );

  @override
  Future<AuditResponse> getAllAudits(AuditParams params) async {
    String url =
        '$_baseApiUrl$_getAllAuditsPath/${params.page}?order_by_value=${params.orderByValue}&count=${params.count}';
    if (params.startAfter != null) {
      url = "$url&start_after=${params.startAfter}";
    }
    if (params.sortByValue != null) {
      url = "$url&sort_by_value=${params.sortByValue}";
    }
    if (params.filterField != null) {
      url =
          "$url&filter_field=${params.filterField}&filter_value=${params.filterValue}";
    }
    // if (params.operator != null) {
    //   url = "$url&operator=${params.operator}";
    // }
    final response = await _apiClient.get(
      url,
    );
    print(response);

    return AuditResponse.fromMap(
      response.data as Map<String, dynamic>,
    );
  }
}
