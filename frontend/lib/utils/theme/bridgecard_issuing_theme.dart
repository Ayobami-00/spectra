import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData lightTheme(BuildContext? context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: AppConstants.appPrimaryColor,
      ),
      primaryColor: AppConstants.appPrimaryColor,
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: AppConstants.appSecondaryColor),
      scaffoldBackgroundColor: HexColor("#FFFFFF"),
      fontFamily: 'GTWalsheimPro', //3
      buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        buttonColor: AppConstants.appPrimaryColor,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppConstants.appBlack,
          fontSize: (AppConstants.getWidth(context!) * 0.08) +
              AppConstants.getUserPreferredFont(context),
          fontFamily: 'GTWalsheimPro',
          fontWeight: FontWeight.w500,
        ),
        displayMedium: TextStyle(
          color: AppConstants.appBlack,
          fontSize: (AppConstants.getWidth(context) * 0.08) +
              AppConstants.getUserPreferredFont(context),
          fontFamily: 'GTWalsheimPro',
          fontWeight: FontWeight.w500,
        ),
        displaySmall: TextStyle(
          color: AppConstants.appBlack,
          fontSize: (AppConstants.getWidth(context) * 0.06) +
              AppConstants.getUserPreferredFont(context),
          fontFamily: 'GTWalsheimPro',
          fontWeight: FontWeight.w400,
          letterSpacing: -0.03,
        ),
        bodyLarge: TextStyle(
          color: AppConstants.appBlack,
          fontSize: (AppConstants.getWidth(context) * 0.06) +
              AppConstants.getUserPreferredFont(context),
          fontFamily: 'GTWalsheimPro',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: AppConstants.appBlack,
          fontSize: (AppConstants.getWidth(context) * 0.035) +
              AppConstants.getUserPreferredFont(context),
          fontFamily: 'GTWalsheimPro',
          fontWeight: FontWeight.w400,
        ),
        labelSmall: TextStyle(
          color: AppConstants.appBlack,
          fontSize: (AppConstants.getWidth(context) * 0.033) +
              AppConstants.getUserPreferredFont(context),
          fontFamily: 'GTWalsheimPro',
          fontWeight: FontWeight.w300,
          letterSpacing: -0.03,
        ),
        labelLarge: TextStyle(
          color: AppConstants.appBlack,
          fontSize: (AppConstants.getWidth(context) * 0.025) +
              AppConstants.getUserPreferredFont(context),
          fontFamily: 'GTWalsheimPro',
          fontWeight: FontWeight.w200,
        ),
        titleMedium: TextStyle(
          color: AppConstants.appBlack,
          fontSize: (AppConstants.getWidth(context) * 0.022) +
              AppConstants.getUserPreferredFont(context),
          fontFamily: 'GTWalsheimPro',
          fontWeight: FontWeight.w300,
          letterSpacing: -0.03,
        ),
      ),
    );
  }
}
