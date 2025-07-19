import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/index.dart';

/// Registers Authentication feature dependencies
void setUpSessionCoreDependencies() {
  // Register usecases dependencies.
  locator.registerLazySingleton(() => CreateSession(locator()));

  // Register repository dependencies.
  locator.registerLazySingleton<SessionRepo>(
    () => SessionRepoImpl(
      locator(),
    ),
  );

  // Register datasource dependencies.
  locator.registerLazySingleton<SessionDataSource>(
    () => SessionDataSourceImpl(
      locator(),
      AmConfig.config.baseApiUrl!,
      AmConfig.config.assistantApiUrl!,
      AmConfig.config.assistantApiKey!,
      AmConfig.config.assistantSuperadminApiEmail!,
      AmConfig.config.assistantSuperadminApiPassword!,
    ),
  );

  // Register new usecase
  locator.registerLazySingleton(() => GetSessionMessages(locator()));

  // Register WebSocket service
  locator.registerLazySingleton(() => WebSocketService(
        AmConfig.config.wsUrl!,
      ));

  // Register new usecase
  locator.registerLazySingleton(() => CreateSessionToken(locator()));

  // Register CreateWaitlist usecase
  locator.registerLazySingleton(() => CreateWaitlist(locator()));

  // Update SessionCubit registration
  locator.registerFactory(
    () => SessionCubit(
      locator(), // CreateSession
      locator(), // CreateMessage
      locator(), // GetSessionMessages
      locator(), // WebSocketService
      locator(), // CreateSessionToken
      locator(), // CreateWaitlist
    ),
  );

  locator.registerLazySingleton(() => CreateMessage(locator()));
}
