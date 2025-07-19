import 'package:frontend/core/index.dart';
import 'package:frontend/features/audit/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../authentication/presentation/listeners/index.dart';

part 'audits_state.dart';

class AuditsCubit extends Cubit<AuditsState> implements OnAppStartLazy {
  GetAllAudits getAllAudits;

  AuditResponse? allAudits;
  int? total;
  String? page = "1";
  int? count = 20;
  String? startAfter;
  String? sortByValue;
  String? filterField;
  String? filterValue;
  String? orderByValue = 'created_at';

  void resetState() {
    total = null;
    page = "1";
    count = 20;
    orderByValue = 'created_at';
    filterValue = null;
    filterField = null;

    sortByValue = null;
    startAfter = null;
  }

  AuditsCubit(
    this.getAllAudits,
  ) : super(AuditsInitial());

  Future<AuditResponse> getAllAuditsLogic() async {
    AuditParams params = AuditParams(
      page: page,
      count: count,
      sortByValue: sortByValue,
      filterField: filterField,
      filterValue: filterValue,
      orderByValue: orderByValue,
      startAfter: startAfter,
    );
    final response = await getAllAudits(params);
    return response.maybeWhen(
      success: (data) {
        allAudits = data;
        return data;
      },
      apiFailure: (exception, _) => AuditResponse.hasError(
        ApiExceptions.getErrorMessage(exception),
      ),
      orElse: () => AuditResponse.hasError(
        AppConstants.defaultErrorMessage,
      ),
    );
  }

  @override
  Future<void> onAppStartLazy() async {
    await getAllAuditsLogic();
  }
}
