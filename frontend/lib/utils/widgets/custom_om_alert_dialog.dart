import 'package:frontend/utils/index.dart';
import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CustomOmAlertDialogType {
  info,
  error,
}

class CustomOmAlertDialog {
  static void show(
    BuildContext context,
    CustomOmAlertDialogType type,
    String message,
  ) {
    FlashyFlushbar(
      borderRadius: BorderRadius.all(Radius.circular(6.0.r)),
      leadingWidget: Icon(
        type == CustomOmAlertDialogType.error
            ? Icons.error_outline
            : Icons.info_outline,
        color: type == CustomOmAlertDialogType.error
            ? AppConstants.appErrorColor
            : AppConstants.appPrimaryColor,
        size: 24,
      ),
      backgroundColor: type == CustomOmAlertDialogType.error
          ? AppConstants.appErrorColor
          : AppConstants.appWhite,
      message: message,
      messageStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: type == CustomOmAlertDialogType.error
                ? AppConstants.appWhite
                : AppConstants.appPrimaryColor,
            fontSize: 7.sp,
          ),
      duration: const Duration(seconds: 3),
      trailingWidget: IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.black,
          size: 24,
        ),
        onPressed: () {
          FlashyFlushbar.cancel();
        },
      ),
      isDismissible: false,
    ).show();
  }
}
