import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:frontend/features/audit/index.dart';
import 'package:frontend/utils/index.dart';

class AuditMenuBar extends StatefulWidget {
  const AuditMenuBar({
    Key? key,
  }) : super(key: key);

  @override
  State<AuditMenuBar> createState() => _AuditMenuBarState();
}

class _AuditMenuBarState extends State<AuditMenuBar> {
  bool _obscureValue = false;

  final FocusNode _pageFocus = FocusNode();
  final FocusNode _countFocus = FocusNode();
  final FocusNode _orderByFocus = FocusNode();
  final FocusNode _sortByFocus = FocusNode();
  final FocusNode _filterFieldFocus = FocusNode();
  final FocusNode _filterValueFocus = FocusNode();
  final FocusNode _startAfterFocus = FocusNode();

  final GlobalKey<FormState> passwordValidatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuditsCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 18.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomOmTextFormField(
                    width: 70.h,
                    initialValue: bloc.page,
                    textInputAction: TextInputAction.done,
                    hintText: "Page",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15.h),
                    labelTextFontSize: 5.0.sp,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 5.0.w,
                    ),
                    // controller: _pageController,
                    focusNode: _pageFocus,
                    inputFormatters: [
                      // Denies the user from adding a white space
                      // to the textfield input.
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onFieldSubmitted: (value) {
                      changeFocuNode(
                        from: _pageFocus,
                        to: _countFocus,
                        context: context,
                      );
                    },
                    onChanged: (String? value) {
                      if (value != null) {
                        bloc.page = value.trim();
                      }
                    },
                  ),
                  SizedBox(
                    width: 20.h,
                  ),
                  CustomOmTextFormField(
                    width: 99.h,
                    initialValue: "${bloc.count}",
                    textInputAction: TextInputAction.done,
                    hintText: "Count",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15.h),
                    labelTextFontSize: 5.0.sp,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 5.0.w,
                    ),
                    // controller: _countController,
                    focusNode: _countFocus,
                    inputFormatters: [
                      // Denies the user from adding a white space
                      // to the textfield input.
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onFieldSubmitted: (value) {
                      changeFocuNode(
                        from: _countFocus,
                        to: _orderByFocus,
                        context: context,
                      );
                    },
                    onChanged: (String? value) {
                      if (value != null) {
                        bloc.count = int.parse(value.trim());
                      }
                    },
                  ),
                  SizedBox(
                    width: 20.h,
                  ),
                  CustomOmTextFormField(
                    width: 150.h,
                    initialValue: bloc.orderByValue != null
                        ? "${bloc.orderByValue}"
                        : null,
                    textInputAction: TextInputAction.done,
                    hintText: "Order By Value",
                    labelTextFontSize: 5.0.sp,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15.h),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 5.0.w,
                    ),
                    // controller: _countController,
                    focusNode: _orderByFocus,
                    inputFormatters: [
                      // Denies the user from adding a white space
                      // to the textfield input.
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onFieldSubmitted: (value) {
                      changeFocuNode(
                        from: _orderByFocus,
                        to: _sortByFocus,
                        context: context,
                      );
                    },
                    onChanged: (String? value) {
                      if (value != null) {
                        bloc.orderByValue = value.trim() as String?;
                      }
                    },
                  ),
                  SizedBox(
                    width: 20.h,
                  ),
                  CustomOmTextFormField(
                    width: 150.h,
                    initialValue:
                        bloc.sortByValue != null ? "${bloc.sortByValue}" : null,
                    textInputAction: TextInputAction.done,
                    hintText: "Sort By Value",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15.h),
                    labelTextFontSize: 5.0.sp,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 5.0.w,
                    ),
                    // controller: _countController,
                    focusNode: _sortByFocus,
                    inputFormatters: [
                      // Denies the user from adding a white space
                      // to the textfield input.
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onFieldSubmitted: (value) {
                      changeFocuNode(
                        from: _sortByFocus,
                        to: _filterFieldFocus,
                        context: context,
                      );
                    },
                    onChanged: (String? value) {
                      if (value != null) {
                        bloc.sortByValue = value.trim() as String?;
                      }
                    },
                  ),
                  SizedBox(
                    width: 20.h,
                  ),
                  CustomOmTextFormField(
                    width: 150.h,
                    initialValue:
                        bloc.filterField != null ? "${bloc.filterField}" : null,
                    textInputAction: TextInputAction.done,
                    hintText: "Filter Field",
                    labelTextFontSize: 5.0.sp,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15.h),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 5.0.w,
                    ),
                    // controller: _countController,
                    focusNode: _filterFieldFocus,
                    inputFormatters: [
                      // Denies the user from adding a white space
                      // to the textfield input.
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onFieldSubmitted: (value) {
                      changeFocuNode(
                        from: _filterFieldFocus,
                        to: _filterValueFocus,
                        context: context,
                      );
                    },
                    onChanged: (String? value) {
                      if (value != null) {
                        bloc.filterField = value.trim() as String?;
                      }
                    },
                  ),
                  SizedBox(
                    width: 20.h,
                  ),
                  CustomOmTextFormField(
                    width: 150.h,
                    initialValue:
                        bloc.filterValue != null ? "${bloc.filterValue}" : null,
                    textInputAction: TextInputAction.done,
                    hintText: "Filter Value",
                    labelTextFontSize: 5.0.sp,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15.h),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 5.0.w,
                    ),
                    // controller: _countController,
                    focusNode: _filterValueFocus,
                    inputFormatters: [
                      // Denies the user from adding a white space
                      // to the textfield input.
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onFieldSubmitted: (value) {
                      changeFocuNode(
                        from: _filterValueFocus,
                        to: _filterValueFocus,
                        context: context,
                      );
                    },
                    onChanged: (String? value) {
                      if (value != null) {
                        bloc.filterValue = value.trim() as String?;
                      }
                    },
                  ),
                  SizedBox(
                    width: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
