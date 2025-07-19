import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/index.dart';

class GetSessionMessages with UseCases<ApiResult<List<Message>>, String> {
  final SessionRepo sessionRepo;

  GetSessionMessages(this.sessionRepo);

  @override
  Future<ApiResult<List<Message>>> call(String params) {
    return sessionRepo.getSessionMessages(params);
  }
}
