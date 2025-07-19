import 'package:flutter/material.dart';

import 'package:frontend/features/audit/data/index.dart';
import 'package:frontend/utils/constants.dart';

class AutitLogAttributes {
  Color? iconColor;
  IconData? icon;
  Color? backgroundColor;
  Color? textColor;
  AutitLogAttributes({
    this.iconColor,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });
}

AutitLogAttributes auditLogsUiAttributes(Log step) {
  Color? iconColor;
  IconData? icon;
  Color? backgroundColor;
  Color textColor = AppConstants.appMenuTextColor;
  if (step.action!.contains("CREATE")) {
    iconColor = AppConstants.appPrimaryColor;
    backgroundColor = AppConstants.appSecondaryColor;
    icon = Icons.create;
    textColor = AppConstants.appPrimaryColor;
  } else if (step.action!.contains("UPDATE")) {
    iconColor = AppConstants.appPasswordValidateSuccesss;
    backgroundColor = AppConstants.appSecondaryColor;
    icon = Icons.update;
    textColor = AppConstants.appPasswordValidateSuccesss;
  } else if (step.action!.contains("DELETE")) {
    iconColor = AppConstants.splashScreenBackgroundRed;
    backgroundColor = AppConstants.appSecondaryColor;
    icon = Icons.delete;
    textColor = AppConstants.splashScreenBackgroundRed;
  }
  return AutitLogAttributes(
    iconColor: iconColor,
    icon: icon,
    backgroundColor: backgroundColor,
    textColor: textColor,
  );
}
