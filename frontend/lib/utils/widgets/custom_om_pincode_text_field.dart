import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomOmPinCodeTextField extends StatelessWidget {
  final BuildContext appContext;
  final TextStyle pastedTextStyle;
  final int length;
  final bool obscureText;
  final String obscuringCharacter;
  final bool blinkWhenObscuring;
  final String? Function(String?)? validator;
  final Color cursorColor;
  final Duration animationDuration;
  final bool enableActiveFill;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String) onCompleted;
  final Function(String) onChanged;

  const CustomOmPinCodeTextField({
    super.key,
    required this.appContext,
    required this.pastedTextStyle,
    required this.length,
    required this.obscureText,
    required this.obscuringCharacter,
    required this.blinkWhenObscuring,
    required this.validator,
    required this.cursorColor,
    required this.animationDuration,
    required this.enableActiveFill,
    required this.controller,
    required this.keyboardType,
    required this.onCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: appContext,
      pastedTextStyle: pastedTextStyle,
      length: length,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      blinkWhenObscuring: blinkWhenObscuring,
      animationType: AnimationType.fade,
      validator: validator,
      pinTheme: PinTheme(
        activeColor: AppConstants.appPrimaryColor,
        inactiveColor: AppConstants.appSecondaryColor2,
        inactiveFillColor: AppConstants.appWhite,
        activeFillColor: Colors.white,
        selectedColor: AppConstants.appPrimaryColor2,
        selectedFillColor: AppConstants.appWhite,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(15),
        fieldHeight: 50.h,
        fieldWidth: 12.w,
      ),
      cursorColor: cursorColor,
      animationDuration: animationDuration,
      enableActiveFill: enableActiveFill,
      controller: controller,
      keyboardType: keyboardType,
      onCompleted: onCompleted,
      onChanged: onChanged,
      beforeTextPaste: (text) {
        return true;
      },
    );
  }
}
