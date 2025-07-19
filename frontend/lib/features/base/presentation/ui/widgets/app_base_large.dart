import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'app_side_menu.dart';
import 'app_side_menu_item.dart';

class AppBaseLarge extends StatefulWidget {
  final ValueNotifier<AppSideMenuItemState> appSideMenuItemState;
  final StatefulNavigationShell appBaseNavigationShell;

  const AppBaseLarge({
    super.key,
    required this.appSideMenuItemState,
    required this.appBaseNavigationShell,
  });

  @override
  State<AppBaseLarge> createState() => _AppBaseLargeState();
}

class _AppBaseLargeState extends State<AppBaseLarge> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: AppSideMenu(
          appBaseNavigationShell: widget.appBaseNavigationShell,
          appSideMenuItemState: widget.appSideMenuItemState,
        )),
        Expanded(
          flex: 5,
          child: Container(
            padding: EdgeInsets.only(top: 100.h),
            child: widget.appBaseNavigationShell,
          ),
        )
      ],
    );
  }
}
