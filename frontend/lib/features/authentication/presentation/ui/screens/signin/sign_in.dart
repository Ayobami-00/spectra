import 'package:frontend/features/authentication/presentation/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:frontend/core/index.dart';

import 'dart:math' as math;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obscureValue = true;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final GlobalKey<FormState> passwordValidatorKey = GlobalKey();

  final ValueNotifier<bool> _signInButtonLoading = ValueNotifier(false);

  final _signInPageformKey = GlobalKey<FormState>();

  void _togglePasswordSufficIcon() {
    setState(() {
      _obscureValue = !_obscureValue;
    });
  }

  void _handleSignIn(AuthenticationCubit bloc) {
    if (_signInPageformKey.currentState!.validate()) {
      bloc.onOtpVerificationSuccessfull = (BuildContext context) {
        bloc.signInLogic().then((value) {
          if (value is bool) {
            Future.delayed(
              const Duration(milliseconds: 2000),
              () {
                locator<NavigationService>().goNamed(
                  homeRoute,
                );
              },
            );
          } else if (value is String) {
            CustomOmAlertDialog.show(
                context, CustomOmAlertDialogType.error, value);

            locator<NavigationService>().goNamed(
              signInRoute,
            );
          }
        });
      };
      locator<NavigationService>().goNamed(otpVerificationRoute,
          queryParameters: {"emailAddress": bloc.signInEmail!});
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthenticationCubit>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstants.appPrimaryColor.withOpacity(0.4),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
            80.0,
          ),
          child: Container(
            width: AppConstants.getWidth(context),
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Image.asset(
                        AppConstants.appLogoImagePath,
                      ),
                    ),
                    SizedBox(
                      width: 0.5.w,
                    ),
                    Text(
                      AppConstants.appName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                letterSpacing: 0.03.sp,
                                fontSize: 23.0,
                                fontWeight: FontWeight.w700,
                              ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomOmSolidButton(
                    onPressed: () =>
                        locator<NavigationService>().goNamed(registerRoute),
                    isLoading: false,
                    fontSize: 20.0,
                    textColor: AppConstants.appBlack,
                    text: AppConstants.signUpText,
                    buttonColor: AppConstants.appPrimaryColor,
                    widthS: ResponsiveWidget.isSmallScreen(context)
                        ? 90.0.w
                        : 25.0.w,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0.w,
                      vertical: 10.0.h,
                    ),
                    child: Column(
                      children: [
                        Form(
                            key: _signInPageformKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 16.0.h,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    AppConstants.signInText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: AppConstants.appBlack,
                                          fontSize: 10.0.sp,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0.h,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    AppConstants.signInCaptionText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppConstants.appBlack,
                                          fontSize: 5.0.sp,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50.0.h,
                                ),
                                CustomOmTextFormField(
                                  initialValue: bloc.signInEmail,
                                  textInputAction: TextInputAction.done,
                                  labelText: AppConstants.workEmailText,
                                  labelTextFontSize: 5.0.sp,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.0.w,
                                  ),
                                  // controller: _emailController,
                                  focusNode: _emailFocus,
                                  inputFormatters: [
                                    // Denies the user from adding a white space
                                    // to the textfield input.
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')),
                                  ],
                                  validator: Validators.compose([
                                    Validators.patternRegExp(
                                      AppConstants.validAppEmailRegex,
                                      AppConstants
                                          .invaidEmailValueValidatorString,
                                    ),
                                  ]),
                                  onFieldSubmitted: (value) {
                                    changeFocuNode(
                                      from: _emailFocus,
                                      to: _passwordFocus,
                                      context: context,
                                    );
                                  },
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      bloc.signInEmail = value.trim();
                                    }
                                  },
                                ),
                                CustomOmTextFormField(
                                  textInputAction: TextInputAction.done,
                                  // controller: _pass,
                                  focusNode: _passwordFocus,
                                  labelText: AppConstants.passwordText,
                                  labelTextFontSize: 5.0.sp,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.0.w,
                                  ),
                                  suffixIcon: Transform(
                                    // Flips the icon to look like the one
                                    // we have currently in the design.
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: GestureDetector(
                                      onTap: _togglePasswordSufficIcon,
                                      child: !_obscureValue
                                          ? const CustomOmTexFieldEyeCloseWidget()
                                          : const CustomOmTexFieldEyeOpenWidget(),
                                    ),
                                  ),
                                  validator: Validators.compose([
                                    Validators.required(
                                      AppConstants
                                          .fieldIsRequiredValidatorString,
                                    ),
                                    Validators.minLength(
                                      AppConstants.defaultPasswordLength,
                                      AppConstants
                                          .invalidPasswordValidatorString,
                                    ),
                                  ]),
                                  obscureText: _obscureValue,
                                  onChanged: (String value) {
                                    bloc.signInPassword = value.trim();
                                  },
                                ),
                                SizedBox(
                                  height: 30.0.h,
                                ),
                                ValueListenableBuilder(
                                  valueListenable: _signInButtonLoading,
                                  builder: (
                                    BuildContext context,
                                    bool signUpButtonLoadingValue,
                                    Widget? child,
                                  ) {
                                    return CustomOmSolidButton(
                                      onPressed: () => _handleSignIn(bloc),
                                      isLoading: signUpButtonLoadingValue,
                                      fontSize: 20.0,
                                      textColor: AppConstants.appBlack,
                                      text: AppConstants.signInText,
                                      buttonColor: AppConstants.appPrimaryColor,
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 30.0.h,
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: AppConstants.signInNewToBridgecardText
                                        .padRight(19),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 5.0.sp,
                                        ),
                                    children: [
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () =>
                                              locator<NavigationService>()
                                                  .goNamed(registerRoute),
                                          child: Text(
                                            AppConstants.signUpText,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppConstants
                                                      .appPrimaryColor,
                                                  fontSize: 5.0.sp,
                                                ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0.h,
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
