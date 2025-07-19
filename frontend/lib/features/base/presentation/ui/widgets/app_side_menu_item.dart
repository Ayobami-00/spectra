import 'package:frontend/utils/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSideMenuItemState extends Equatable {
  final String? itemCurrentlyHoveredOn;
  final String? itemCurrentlyActive;

  const AppSideMenuItemState(
      {this.itemCurrentlyHoveredOn, this.itemCurrentlyActive});

  bool isHoveredOn(String itemName) => itemCurrentlyHoveredOn == itemName;

  bool isActive(String itemName) => itemCurrentlyActive == itemName;

  AppSideMenuItemState copyWith({
    String? itemCurrentlyHoveredOn,
    String? itemCurrentlyActive,
  }) {
    return AppSideMenuItemState(
      itemCurrentlyHoveredOn:
          itemCurrentlyHoveredOn ?? this.itemCurrentlyHoveredOn,
      itemCurrentlyActive: itemCurrentlyActive ?? this.itemCurrentlyActive,
    );
  }

  @override
  List<Object?> get props => [itemCurrentlyHoveredOn, itemCurrentlyActive];
}

class SideMenuItem extends StatelessWidget {
  final String itemName;
  final Function() onTap;
  final ValueNotifier<AppSideMenuItemState> appSideMenuItemState;

  const SideMenuItem({
    super.key,
    required this.itemName,
    required this.onTap,
    required this.appSideMenuItemState,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isSmallScreen(context)) {
      return VerticalSideMenuItem(
        appSideMenuItemState: appSideMenuItemState,
        itemName: itemName,
        onTap: onTap,
      );
    } else {
      return HorizontalMenuItem(
        appSideMenuItemState: appSideMenuItemState,
        itemName: itemName,
        onTap: onTap,
      );
    }
  }
}

class VerticalSideMenuItem extends StatefulWidget {
  final String itemName;
  final Function()? onTap;
  final ValueNotifier<AppSideMenuItemState> appSideMenuItemState;
  const VerticalSideMenuItem({
    super.key,
    required this.itemName,
    this.onTap,
    required this.appSideMenuItemState,
  });

  @override
  State<VerticalSideMenuItem> createState() => _VerticalSideMenuItemState();
}

class _VerticalSideMenuItemState extends State<VerticalSideMenuItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onTap,
        // if (!isActive(itemName)) itemCurrentlyHoveredOn = itemName;
        onHover: (value) {
          if (value) {
            if (!widget.appSideMenuItemState.value.isActive(widget.itemName)) {
              widget.appSideMenuItemState.value = widget
                  .appSideMenuItemState.value
                  .copyWith(itemCurrentlyHoveredOn: widget.itemName);
            }
          } else {
            if (!widget.appSideMenuItemState.value.isActive(widget.itemName)) {
              widget.appSideMenuItemState.value = widget
                  .appSideMenuItemState.value
                  .copyWith(itemCurrentlyHoveredOn: "not hovering");
            }
          }
        },
        child: Container(
          color: widget.appSideMenuItemState.value.isHoveredOn(widget.itemName)
              ? Colors.black.withOpacity(0.1)
              : Colors.transparent,
          child: Row(
            children: [
              Visibility(
                visible: widget.appSideMenuItemState.value
                        .isHoveredOn(widget.itemName) ||
                    widget.appSideMenuItemState.value.isActive(widget.itemName),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Container(
                  width: 3,
                  height: 72,
                  color: AppConstants.appBlack,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: getIconForSideMenuItem(
                        widget.itemName,
                        widget.appSideMenuItemState,
                      ),
                    ),
                    if (!widget.appSideMenuItemState.value
                        .isActive(widget.itemName))
                      Flexible(
                        child: Text(
                          widget.itemName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppConstants.appBlack.withOpacity(0.4),
                                fontSize: 7.0.sp,
                              ),
                        ),
                      )
                    else
                      Flexible(
                        child: Text(
                          widget.itemName,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppConstants.appPrimaryColor,
                                    fontSize: 7.0.sp,
                                  ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class HorizontalMenuItem extends StatefulWidget {
  final String itemName;
  final Function()? onTap;
  final ValueNotifier<AppSideMenuItemState> appSideMenuItemState;
  const HorizontalMenuItem({
    super.key,
    required this.itemName,
    this.onTap,
    required this.appSideMenuItemState,
  });

  @override
  State<HorizontalMenuItem> createState() => _HorizontalMenuItemState();
}

class _HorizontalMenuItemState extends State<HorizontalMenuItem> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: widget.onTap,
        onHover: (value) {
          if (value) {
            if (!widget.appSideMenuItemState.value.isActive(widget.itemName)) {
              widget.appSideMenuItemState.value = widget
                  .appSideMenuItemState.value
                  .copyWith(itemCurrentlyHoveredOn: widget.itemName);
            }
          } else {
            if (!widget.appSideMenuItemState.value.isActive(widget.itemName)) {
              widget.appSideMenuItemState.value = widget
                  .appSideMenuItemState.value
                  .copyWith(itemCurrentlyHoveredOn: "not hovering");
            }
          }
        },
        child: Container(
          color: widget.appSideMenuItemState.value.isHoveredOn(widget.itemName)
              ? Colors.black.withOpacity(0.1)
              : Colors.transparent,
          child: Row(
            children: [
              Visibility(
                visible: widget.appSideMenuItemState.value
                        .isHoveredOn(widget.itemName) ||
                    widget.appSideMenuItemState.value.isActive(widget.itemName),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Container(
                  width: 6,
                  height: 40,
                  color: AppConstants.appBlack,
                ),
              ),
              SizedBox(width: width / 88),
              Padding(
                padding: const EdgeInsets.all(16),
                child: getIconForSideMenuItem(
                  widget.itemName,
                  widget.appSideMenuItemState,
                ),
              ),
              if (!widget.appSideMenuItemState.value.isActive(widget.itemName))
                Flexible(
                  child: Text(
                    widget.itemName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppConstants.appBlack.withOpacity(0.4),
                          fontSize: 7.0.sp,
                        ),
                  ),
                )
              else
                Flexible(
                  child: Text(
                    widget.itemName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppConstants.appPrimaryColor,
                          fontSize: 7.0.sp,
                        ),
                  ),
                )
            ],
          ),
        ));
  }
}

Widget getIconForSideMenuItem(
  String itemName,
  ValueNotifier<AppSideMenuItemState> appSideMenuItemState,
) {
  switch (itemName) {
    case AppConstants.overviewPageDisplayName:
      return _sideMenuIcon(Icons.trending_up, itemName, appSideMenuItemState);
    case AppConstants.tasksPageDisplayName:
      return _sideMenuIcon(
          Icons.people_outline, itemName, appSideMenuItemState);
    default:
      return _sideMenuIcon(Icons.exit_to_app, itemName, appSideMenuItemState);
  }
}

Widget _sideMenuIcon(
  IconData icon,
  String itemName,
  ValueNotifier<AppSideMenuItemState> appSideMenuItemState,
) {
  if (appSideMenuItemState.value.isActive(itemName)) {
    return Icon(icon, size: 22, color: AppConstants.appPrimaryColor);
  }

  return Icon(
    icon,
    color: appSideMenuItemState.value.isHoveredOn(itemName)
        ? AppConstants.appBlack
        : AppConstants.appBlack.withOpacity(0.3),
  );
}
