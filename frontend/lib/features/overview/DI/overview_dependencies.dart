import 'package:frontend/core/index.dart';
import 'package:frontend/features/overview/data/index.dart';
import 'package:frontend/features/overview/domain/index.dart';

/// Registers Authentication feature dependencies
void setUpOverviewCoreDependencies() {
  // Register usecases dependencies.
  locator.registerLazySingleton(() => GetAnalytics(locator()));

  // Register repository dependencies.
  locator.registerLazySingleton<OverviewRepo>(
    () => OverviewRepoImpl(
      locator(),
    ),
  );

  // Register datasource dependencies.
  locator.registerLazySingleton<OverviewDataSource>(
    () => OverviewDataSourceImpl(
      locator(),
      AmConfig.config.baseApiUrl!,
    ),
  );
}
