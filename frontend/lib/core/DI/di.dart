import 'package:frontend/core/index.dart';
import 'package:frontend/features/audit/DI/index.dart';
import 'package:frontend/features/core/DI/index.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:get_it/get_it.dart';

import '../../features/authentication/DI/index.dart';
import '../../features/overview/DI/index.dart';
import '../../features/tasks/DI/index.dart';
import '../../features/session/DI/index.dart';

final GetIt locator = GetIt.I;

/// Sets up DI for core features.
void setupBaseDI({required FeIssuingApiConfig FeIssuingApiConfig}) {
  locator.registerLazySingleton(() => Connectivity());
  locator.registerLazySingleton<InternetConnection>(
    () => InternetConnectionImpl(locator()),
  );
  locator.registerSingleton(FeApiClient(FeIssuingApiConfig));
  locator.registerLazySingleton(() => NavigationService());
}

/// Sets up DI for the whole app based on specific feature dependencies.
void setUpAppLocator() {
  setupBaseDI(
    FeIssuingApiConfig: FeIssuingApiConfig(
      '',
      bearerToken: () async {
        try {
          return "";
        } catch (e) {
          return "";
        }
      },
    ),
  );

  setUpAuthenticationDependencies();
  setUpCoreCoreDependencies();
  setUpOverviewCoreDependencies();
  setUpTasksCoreDependencies();
  setUpAuditsCoreDependencies();
  setUpSessionCoreDependencies();
}
