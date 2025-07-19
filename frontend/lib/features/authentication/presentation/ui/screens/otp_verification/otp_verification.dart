import 'package:frontend/features/authentication/presentation/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class OtpVerificationPage extends StatefulWidget {
  final String emailAddress;
  final Function(BuildContext contxt)? onOtpVerificationSuccessfull;

  const OtpVerificationPage(
      {super.key,
      required this.emailAddress,
      required this.onOtpVerificationSuccessfull});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  TextEditingController textEditingController = TextEditingController();

  final _signUpPageformKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _confirmOtpButtonLoading = ValueNotifier(false);

  final ValueNotifier<int> _otpCode = ValueNotifier(0);

  @override
  void initState() {
    final bloc = BlocProvider.of<AuthenticationCubit>(context);

    /// Automatically call the api to send otp once you get routed to this page
    bloc.sendOtpLogic(widget.emailAddress).then((value) {
      if (!value) {
        CustomOmAlertDialog.show(context, CustomOmAlertDialogType.error,
            AppConstants.unableToSendOtpErrorMessage);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthenticationCubit>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstants.appPrimaryColor.withOpacity(0.4),
        body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) async {
            if (state is AuthenticationSuccessful) {}
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 709.0,
                    width: 517.0,
                    decoration: BoxDecoration(
                      color: AppConstants.appWhite,
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0.w,
                        vertical: 10.0.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                              key: _signUpPageformKey,
                              child: Column(
                                children: [
                                  Text(
                                    AppConstants.otpVerificationTitleText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppConstants.appBlack,
                                          fontSize: 7.0.sp,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 30.0.h,
                                  ),
                                  Text(
                                    AppConstants.otpVerificationCaptionText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppConstants.appBlack,
                                          fontSize: 5.0.sp,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 50.0.h,
                                  ),
                                  CustomOmPinCodeTextField(
                                    appContext: context,
                                    pastedTextStyle: TextStyle(
                                      color: AppConstants.appSecondaryColor2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    length: 6,
                                    obscureText: true,
                                    obscuringCharacter: '*',
                                    blinkWhenObscuring: true,
                                    validator: Validators.compose([
                                      Validators.required(
                                        AppConstants
                                            .fieldIsRequiredValidatorString,
                                      ),
                                      Validators.minLength(
                                        6,
                                        AppConstants.invaidValueValidatorString,
                                      ),
                                      Validators.maxLength(
                                        6,
                                        AppConstants.invaidValueValidatorString,
                                      ),
                                    ]),
                                    cursorColor: Colors.black,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    enableActiveFill: true,
                                    controller: textEditingController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      signed: true,
                                      decimal: true,
                                    ),
                                    onCompleted: (value) {
                                      _otpCode.value = int.tryParse(value) ?? 0;
                                    },
                                    onChanged: (value) {},
                                  ),
                                  SizedBox(
                                    height: 50.0.h,
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: _confirmOtpButtonLoading,
                                    builder: (
                                      BuildContext context,
                                      bool signUpButtonLoadingValue,
                                      Widget? child,
                                    ) {
                                      return CustomOmSolidButton(
                                        onPressed: () {
                                          _confirmOtpButtonLoading.value = true;
                                          bloc
                                              .verifyOtpLogic(
                                            widget.emailAddress,
                                            _otpCode.value,
                                          )
                                              .then((value) {
                                            if (value.hasError!) {
                                              _confirmOtpButtonLoading.value =
                                                  false;
                                              CustomOmAlertDialog.show(
                                                context,
                                                CustomOmAlertDialogType.error,
                                                value.message!,
                                              );
                                            } else {
                                              widget.onOtpVerificationSuccessfull!(
                                                  context);
                                              _confirmOtpButtonLoading.value =
                                                  false;
                                            }
                                          });
                                        },
                                        isLoading: signUpButtonLoadingValue,
                                        fontSize: 20.0,
                                        textColor: AppConstants.appBlack,
                                        text: AppConstants.confirmText,
                                        buttonColor:
                                            AppConstants.appPrimaryColor,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 30.0.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final bloc =
                                          BlocProvider.of<AuthenticationCubit>(
                                              context);

                                      bloc
                                          .sendOtpLogic(widget.emailAddress)
                                          .then((value) {
                                        if (!value) {
                                          CustomOmAlertDialog.show(
                                              context,
                                              CustomOmAlertDialogType.error,
                                              AppConstants
                                                  .unableToSendOtpErrorMessage);
                                        } else {
                                          CustomOmAlertDialog.show(
                                            context,
                                            CustomOmAlertDialogType.info,
                                            AppConstants
                                                .otpSentSuccessfullyMessage,
                                          );
                                        }
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        AppConstants
                                            .otpVerificationResendOtpText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppConstants.appPrimaryColor,
                                              fontSize: 5.0.sp,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
