import 'package:frontend/core/index.dart';
import 'package:frontend/features/core/data/index.dart';
import 'package:frontend/features/core/domain/index.dart';

/// Registers Authentication feature dependencies
void setUpCoreCoreDependencies() {
  // Register usecases dependencies.

  locator.registerLazySingleton<GetSuperadminDetails>(
    () => GetSuperadminDetails(locator()),
  );

  locator.registerLazySingleton<UploadImageToFirebaseStorage>(
    () => UploadImageToFirebaseStorage(locator()),
  );

  // Register repository dependencies.
  locator.registerLazySingleton<CoreRepo>(
    () => CoreRepoImpl(
      locator(),
    ),
  );

  // Register datasource dependencies.
  locator.registerLazySingleton<CoreDataSource>(
    () => CoreDataSourceImpl(
      locator(),
      AmConfig.config.baseApiUrl!,
    ),
  );
}
