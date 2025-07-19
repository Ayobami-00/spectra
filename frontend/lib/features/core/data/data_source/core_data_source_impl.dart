// ignore_for_file: avoid_dynamic_calls, unused_local_variable

import 'package:frontend/core/index.dart';
import 'package:frontend/features/core/data/index.dart';
import 'package:frontend/features/core/domain/index.dart';
import 'package:dartz/dartz.dart';

class CoreDataSourceImpl implements CoreDataSource {
  final _getSuperadminDetails = '/v1/superadmin/';

  // ignore: unused_field
  final FeApiClient _apiClient;
  // ignore: unused_field
  final String _baseApiUrl;

  CoreDataSourceImpl(
    this._apiClient,
    this._baseApiUrl,
  );

  @override
  Future<Option<String>> uploadImageToFirebaseStorage(
    UploadImageParam params,
  ) async {
    return Future.value(optionOf("downloadURL"));
  }

  @override
  Future<SuperadminDetails> getSuperadminDetails() async {
    final response = await _apiClient.get(
      '$_baseApiUrl$_getSuperadminDetails',
    );

    final data = response.data;

    final superadminDetails = SuperadminDetails.fromJson(
        data["data"]["superadmin"] as Map<String, dynamic>);
    return superadminDetails;
  }
}
