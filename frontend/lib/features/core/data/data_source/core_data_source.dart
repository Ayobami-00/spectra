import 'package:frontend/features/core/data/index.dart';
import 'package:frontend/features/core/domain/index.dart';
import 'package:dartz/dartz.dart';

/// Defines a contract/template for classes impelementing the [CoreDataSource].
abstract class CoreDataSource {
  Future<Option<String>> uploadImageToFirebaseStorage(UploadImageParam params);
  Future<SuperadminDetails> getSuperadminDetails();
}
