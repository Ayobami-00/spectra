import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/widgets/custom_button_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOmSolidButton extends StatelessWidget {
  const CustomOmSolidButton({
    super.key,
    @required this.onPressed,
    @required this.text,
    this.buttonColor,
    this.textColor,
    this.cColor,
    this.isLoading = false,
    this.widthS,
    this.heightS,
    this.fontSize,
  });

  final Function()? onPressed;
  final Color? buttonColor;
  final Color? cColor;
  final double? fontSize;
  final double? heightS;
  final bool isLoading;
  final String? text;
  final Color? textColor;
  final double? widthS;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widthS ?? AppConstants.pageButtonWIdth(context),
        height: heightS ?? AppConstants.pageButtonHeight(context),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ButtonStyle(
            elevation: WidgetStateProperty.all<double>(0),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: cColor ?? AppConstants.appPrimaryColor,
                ),
                borderRadius: BorderRadius.circular(6.0.r),
              ),
            ),
            backgroundColor: WidgetStateProperty.all(
              buttonColor,
            ),
            shadowColor: WidgetStateProperty.all<Color>(AppConstants.appWhite),
          ),
          child: AnimatedContainer(
            curve: Curves.easeInOutCubic,
            padding: isLoading
                ? const EdgeInsets.fromLTRB(10, 10, 10, 10)
                : const EdgeInsets.fromLTRB(0, 10, 0, 10),
            duration: const Duration(milliseconds: 400),
            child: isLoading
                ? ButtonLoadingIndicator(
                    color: buttonColor == AppConstants.appWhite
                        ? AppConstants.appPrimaryColor
                        : null,
                  )
                : Text(
                    text!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: textColor ?? AppConstants.appBlack,
                          fontSize: fontSize,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}
