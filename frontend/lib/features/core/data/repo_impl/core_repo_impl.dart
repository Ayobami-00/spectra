import 'package:frontend/core/index.dart';
import 'package:frontend/features/core/data/index.dart';
import 'package:frontend/features/core/domain/index.dart';
import 'package:dartz/dartz.dart';

class CoreRepoImpl extends CoreRepo {
  final CoreDataSource _coreDataSource;
  CoreRepoImpl(
    this._coreDataSource,
  );

  @override
  Future<ApiResult<Option<String>>> uploadImageToFirebaseStorage(
    UploadImageParam params,
  ) {
    return apiInterceptor(
      _coreDataSource.uploadImageToFirebaseStorage(params),
    );
  }

  @override
  Future<ApiResult<SuperadminDetails>> getSuperadminDetails() {
    return apiInterceptor(_coreDataSource.getSuperadminDetails());
  }
}
