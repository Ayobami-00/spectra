// ignore_for_file: unused_field

import 'package:frontend/core/api/api_client/index.dart';
import 'package:frontend/features/home/data/data_source/home_data_source.dart';
import 'package:frontend/features/home/data/index.dart';

class HomeDataSourceImpl implements HomeDataSource {
  final FeApiClient _apiClient;
  final String _baseApiUrl;

  HomeDataSourceImpl(
    this._apiClient,
    this._baseApiUrl,
  );
}
