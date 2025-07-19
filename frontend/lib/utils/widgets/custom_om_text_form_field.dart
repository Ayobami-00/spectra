import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOmTextFormField extends StatelessWidget {
  const CustomOmTextFormField({
    super.key,
    this.labelText,
    this.labelStyle,
    this.isDetail,
    this.keyboardType,
    this.obscureText = false,
    this.hintColor,
    this.fillColor,
    this.controller,
    this.borderWidth,
    this.height,
    this.width,
    this.validator,
    this.onSaved,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.prefixIcon,
    this.initialValue,
    this.onChanged,
    this.readOnly = false,
    this.autofocus = false,
    this.inputFormatters,
    this.labelTextFontSize,
    this.cColor,
    this.hintText = "",
    this.hintStyle,
    this.contentPadding,
    this.letterSpacing,
  });

  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool? isDetail;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Color? hintColor;
  final Color? fillColor;
  final TextEditingController? controller;
  final double? borderWidth;
  final double? height;
  final double? width;
  final Function(String)? validator;
  final Function? onSaved;
  final Function? onTap;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function? onFieldSubmitted;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? initialValue;
  final Function? onChanged;
  final bool readOnly;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;

  final double? letterSpacing;

  final double? labelTextFontSize;
  final Color? cColor;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final TextFormField textFormField = TextFormField(
      cursorColor: AppConstants.appPrimaryColor,
      textAlignVertical: TextAlignVertical.center,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged as void Function(String)?,
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted as void Function(String)?,
      autofocus: autofocus,
      style: Theme.of(context).textTheme.labelSmall!.copyWith(
            fontSize: 5.0.sp,
            letterSpacing: letterSpacing,
            color: AppConstants.appSecondaryColor,
            fontWeight: FontWeight.normal,
          ),
      validator: validator as String? Function(String?)?,
      onSaved: onSaved as void Function(String?)?,
      onTap: onTap as void Function()?,
      decoration: InputDecoration(
        helperText: ' ',
        hintText: hintText != "" ? hintText : null,
        hintStyle: hintStyle,
        filled: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppConstants.appErrorColor),
          borderRadius: BorderRadius.circular(10.h),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10.h),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: cColor ?? AppConstants.appPrimaryColor3,
          ),
          borderRadius: BorderRadius.circular(10.h),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: AppConstants.appErrorColor),
          borderRadius: BorderRadius.circular(10.h),
        ),
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 20.0.w),
        labelText: labelText,
        labelStyle: labelStyle ??
            Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontSize: labelTextFontSize ?? 3.sp,
                  color: AppConstants.appSecondaryColor4,
                  fontWeight: FontWeight.normal,
                ),
        errorStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AppConstants.appErrorColor,
            ),
        fillColor: AppConstants.appWhite,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText,
    );

    return SizedBox(
      // height: height ?? 60.0.h,
      width: width ?? AppConstants.textFieldWidth(context),
      height: height ?? AppConstants.textFieldHeight(context),
      child: textFormField,
    );
  }
}
