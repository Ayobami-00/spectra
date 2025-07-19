import 'package:frontend/core/index.dart';
import 'package:frontend/features/overview/data/index.dart';
import 'package:frontend/features/overview/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'overview_state.dart';

class OverviewCubit extends Cubit<OverviewState> {
  OverviewCubit(
    this.getAnalytics,
  ) : super(OverviewInitial());

  GetAnalytics getAnalytics;

  Future<AnalyticsResponse> getAnalyticsLogic(
    String analyticsId,
  ) async {
    final response = await getAnalytics(GetAnalyticsParam(
      analyticsId: analyticsId,
    ));
    return response.maybeWhen(
      success: (data) => data,
      apiFailure: (exception, _) => AnalyticsResponse.hasError(
        ApiExceptions.getErrorMessage(exception),
      ),
      orElse: () => AnalyticsResponse.hasError(
        AppConstants.defaultErrorMessage,
      ),
    );
  }
}
