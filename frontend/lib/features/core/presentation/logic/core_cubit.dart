import 'package:frontend/core/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:bloc/bloc.dart';
import 'package:frontend/features/authentication/presentation/index.dart';
import 'package:frontend/features/core/domain/index.dart';
import 'package:equatable/equatable.dart';

part 'core_state.dart';

class CoreCubit extends Cubit<CoreState>
    implements OnAppStartLazy, OnAppStartPriority, OnAppLogout {
  UploadImageToFirebaseStorage uploadImageToFirebaseStorage;
  GetSuperadminDetails getSuperadminDetails;

  CoreCubit(
    this.uploadImageToFirebaseStorage,
    this.getSuperadminDetails,
  ) : super(CoreInitial());

  String? superadminEmail;
  String? superadminCompanyName;

  Future<bool> uploadImageToFirebaseStorageLogic(
    UploadImageParam params,
  ) async {
    final response = await uploadImageToFirebaseStorage(params);
    return response.maybeWhen(
      success: (data) => data.fold(
        () => false,
        (value) {
          return true;
        },
      ),
      apiFailure: (exception, _) => false,
      orElse: () => false,
    );
  }

  Future getSuperadminDetailsLogic() async {
    emit(CoreLoading());
    final _ = NoParams();
    final response = await getSuperadminDetails(_);
    return response.maybeWhen(
      success: (data) async {
        superadminEmail = data.email;
        superadminCompanyName = data.companyName;
        emit(CoreLoaded(data: data));
        return data;
      },
      apiFailure: (exception, _) =>
          emit(CoreError(ApiExceptions.getErrorMessage(exception))),
      orElse: () => emit(const CoreError(AppConstants.defaultErrorMessage)),
    );
  }

  @override
  Future<void> onAppStartLazy() async {
    return Future.value();
  }

  @override
  Future<void> onAppStartPriority() async {
    await getSuperadminDetailsLogic();
  }

  @override
  Future<void> onAppLogout() {
    return Future.value();
  }
}
