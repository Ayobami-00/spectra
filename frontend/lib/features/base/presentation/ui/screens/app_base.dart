import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_bar.dart';
import '../widgets/app_base_large.dart';
import '../widgets/app_side_menu.dart';
import '../widgets/app_side_menu_item.dart';

class AppBase extends StatefulWidget {
  final StatefulNavigationShell appBaseNavigationShell;
  const AppBase({
    super.key,
    required this.appBaseNavigationShell,
  });

  @override
  State<AppBase> createState() => _AppBaseState();
}

class _AppBaseState extends State<AppBase> {
  final GlobalKey<ScaffoldState> appBaseScaffoldKey = GlobalKey();
  final ValueNotifier<AppSideMenuItemState> _appSideMenuItemState =
      ValueNotifier(const AppSideMenuItemState(
    itemCurrentlyActive: AppConstants.overviewPageDisplayName,
  ));
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _appSideMenuItemState,
      builder: (
        BuildContext context,
        AppSideMenuItemState appSideMenuItemState,
        Widget? child,
      ) {
        return Scaffold(
          key: appBaseScaffoldKey,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(
              80.0,
            ),
            child: CustomAppBar(
              appBaseScaffoldKey: appBaseScaffoldKey,
            ),
          ),
          drawer: Drawer(
            child: AppSideMenu(
              appSideMenuItemState: _appSideMenuItemState,
              appBaseNavigationShell: widget.appBaseNavigationShell,
            ),
          ),
          body: ResponsiveWidget(
            largeScreen: AppBaseLarge(
              appBaseNavigationShell: widget.appBaseNavigationShell,
              appSideMenuItemState: _appSideMenuItemState,
            ),
          ),
        );
      },
    );
  }
}
