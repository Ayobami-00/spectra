import 'package:flutter/material.dart';

class SideSheet {
  static Future<dynamic> left({
    required Widget body,
    required BuildContext context,
    double? width,
    String barrierLabel = "Side Sheet",
    bool barrierDismissible = true,
    Color barrierColor = const Color(0xFF66000000),
    double sheetBorderRadius = 0,
    Color sheetColor = Colors.white,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) async {
    dynamic data = await _showSheetSide(
      body: body,
      width: width,
      rightSide: false,
      context: context,
      barrierLabel: barrierLabel,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      sheetBorderRadius: sheetBorderRadius,
      sheetColor: sheetColor,
      transitionDuration: transitionDuration,
    );
    if (data == null) return '';

    return data;
  }

  static Future<dynamic> right(
      {required Widget body,
      required BuildContext context,
      double? width,
      String barrierLabel = "Side Sheet",
      bool barrierDismissible = true,
      Color barrierColor = const Color(0xFF66000000),
      double sheetBorderRadius = 0,
      Color sheetColor = Colors.white,
      Duration transitionDuration = const Duration(milliseconds: 300)}) async {
    dynamic data = await _showSheetSide(
      body: body,
      width: width,
      rightSide: true,
      context: context,
      barrierLabel: barrierLabel,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      sheetBorderRadius: sheetBorderRadius,
      sheetColor: sheetColor,
      transitionDuration: transitionDuration,
    );
    if (data == null) return '';

    return data;
  }

  static _showSheetSide({
    required Widget body,
    required bool rightSide,
    double? width,
    required BuildContext context,
    required String barrierLabel,
    required bool barrierDismissible,
    required Color barrierColor,
    required double sheetBorderRadius,
    required Color sheetColor,
    required Duration transitionDuration,
  }) {
    BorderRadius borderRadius = BorderRadius.only(
      topLeft: rightSide ? Radius.circular(sheetBorderRadius) : Radius.zero,
      bottomLeft: rightSide ? Radius.circular(sheetBorderRadius) : Radius.zero,
      topRight: !rightSide ? Radius.circular(sheetBorderRadius) : Radius.zero,
      bottomRight:
          !rightSide ? Radius.circular(sheetBorderRadius) : Radius.zero,
    );

    return showGeneralDialog(
      barrierLabel: barrierLabel,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: (rightSide ? Alignment.centerRight : Alignment.centerLeft),
          child: Material(
            elevation: 15,
            color: Colors.transparent,
            borderRadius: borderRadius,
            child: Container(
                decoration: BoxDecoration(
                    color: sheetColor, borderRadius: borderRadius),
                height: double.infinity,
                width: width ?? MediaQuery.of(context).size.width / 1.4,
                child: body),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween(
                  begin: Offset((rightSide ? 1 : -1), 0),
                  end: const Offset(0, 0))
              .animate(animation1),
          child: child,
        );
      },
    );
  }
}
