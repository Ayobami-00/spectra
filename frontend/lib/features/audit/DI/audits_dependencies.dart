import 'package:frontend/core/index.dart';
import 'package:frontend/features/audit/data/index.dart';
import 'package:frontend/features/audit/domain/index.dart';

/// Registers Authentication feature dependencies
void setUpAuditsCoreDependencies() {
  // Register usecases dependencies.
  locator.registerLazySingleton(() => GetAllAudits(locator()));

  // Register repository dependencies.
  locator.registerLazySingleton<AuditsRepo>(
    () => AuditsRepoImpl(
      locator(),
    ),
  );

  // Register datasource dependencies.
  locator.registerLazySingleton<AuditsDataSource>(
    () => AuditsDataSourceImpl(
      locator(),
      AmConfig.config.baseApiUrl!,
    ),
  );
}
