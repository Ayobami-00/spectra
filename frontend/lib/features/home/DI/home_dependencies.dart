import 'package:frontend/core/index.dart';
import 'package:frontend/features/home/data/index.dart';
import 'package:frontend/features/home/domain/index.dart';

/// Registers Authentication feature dependencies
void setUpHomeCoreDependencies() {
  // Register usecases dependencies.

  // Register repository dependencies.
  locator.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(
      locator(),
    ),
  );

  // Register datasource dependencies.
  locator.registerLazySingleton<HomeDataSource>(
    () => HomeDataSourceImpl(
      locator(),
      AmConfig.config.baseApiUrl!,
    ),
  );
}
