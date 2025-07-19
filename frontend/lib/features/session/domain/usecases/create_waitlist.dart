import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/index.dart';

class CreateWaitlist with UseCases<ApiResult<void>, CreateWaitlistParams> {
  final SessionRepo sessionRepo;

  CreateWaitlist(this.sessionRepo);

  @override
  Future<ApiResult<void>> call(CreateWaitlistParams params) {
    return sessionRepo.createWaitlist(params);
  }
}
