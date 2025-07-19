import 'package:frontend/core/api/api_result/api_result.dart';
import 'package:frontend/features/core/data/index.dart';
import 'package:frontend/features/core/domain/index.dart';
import 'package:dartz/dartz.dart';

/// Defines a contract/template for classes impelementing the [CoreRepo].
abstract class CoreRepo {
  Future<ApiResult<Option<String>>> uploadImageToFirebaseStorage(
    UploadImageParam params,
  );
  Future<ApiResult<SuperadminDetails>> getSuperadminDetails();
}
