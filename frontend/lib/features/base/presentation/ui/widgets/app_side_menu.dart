import 'package:frontend/core/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'app_side_menu_item_data.dart';

import 'app_side_menu_item.dart';

class AppSideMenu extends StatefulWidget {
  final ValueNotifier<AppSideMenuItemState> appSideMenuItemState;
  final StatefulNavigationShell appBaseNavigationShell;

  const AppSideMenu({
    super.key,
    required this.appSideMenuItemState,
    required this.appBaseNavigationShell,
  });

  @override
  State<AppSideMenu> createState() => _AppSideMenuState();
}

class _AppSideMenuState extends State<AppSideMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.appWhite,
      padding: EdgeInsets.only(top: 30.0.h),
      child: ListView(
        children: [
          if (ResponsiveWidget.isSmallScreen(context))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 40,
                ),
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
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: appSideMenuItemRoutes
                .map((item) => SideMenuItem(
                    appSideMenuItemState: widget.appSideMenuItemState,
                    itemName: item.name,
                    onTap: () {
                      if (!widget.appSideMenuItemState.value
                          .isActive(item.name)) {
                        widget.appSideMenuItemState.value = widget
                            .appSideMenuItemState.value
                            .copyWith(itemCurrentlyActive: item.name);
                        locator<NavigationService>().goNamed(item.route);
                      }
                    }) as Widget)
                .toList(),
          )
        ],
      ),
    );
  }
}

List<AppSideMenuItemData> appSideMenuItemRoutes = [
  AppSideMenuItemData(AppConstants.overviewPageDisplayName, overviewRoute),
  AppSideMenuItemData(AppConstants.tasksPageDisplayName, tasksRoute),
  AppSideMenuItemData(AppConstants.auditsPageDisplayName, auditsRoute),
];
