import 'package:frontend/core/index.dart';
import 'package:frontend/features/core/domain/index.dart';
import 'package:dartz/dartz.dart';

class UploadImageToFirebaseStorage
    with UseCases<ApiResult<Option<String>>, UploadImageParam> {
  final CoreRepo _repo;

  UploadImageToFirebaseStorage(this._repo);

  @override
  Future<ApiResult<Option<String>>> call(UploadImageParam params) {
    return _repo.uploadImageToFirebaseStorage(params);
  }
}
