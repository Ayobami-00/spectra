import 'package:frontend/features/core/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> appBaseScaffoldKey;

  const CustomAppBar({
    super.key,
    required this.appBaseScaffoldKey,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final coreBloc = BlocProvider.of<CoreCubit>(context);
    return Container(
      width: AppConstants.getWidth(context),
      padding: EdgeInsets.only(
        right: 20.0.w,
        left: 5.0.w,
        top: 10.0.h,
        bottom: 10.0.h,
      ),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          !ResponsiveWidget.isSmallScreen(context)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50.0.h,
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
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                              ),
                    )
                  ],
                )
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    widget.appBaseScaffoldKey.currentState?.openDrawer();
                  },
                ),
          FutureBuilder(
            future: coreBloc.getSuperadminDetailsLogic(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (coreBloc.superadminCompanyName != null &&
                  coreBloc.superadminEmail != null) {
                return Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppConstants.appPrimaryColor.withOpacity(.5),
                          borderRadius: BorderRadius.circular(30)),
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                AppConstants.appPrimaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          backgroundColor:
                              AppConstants.appPrimaryColor.withOpacity(0.2),
                          child: Icon(
                            Icons.person_outline,
                            color: AppConstants.appBlack,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          coreBloc.superadminCompanyName ?? AppConstants.nA,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppConstants.appBlack,
                                    fontSize: 4.0.sp,
                                  ),
                        ),
                        Text(
                          coreBloc.superadminEmail ?? AppConstants.nA,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppConstants.appBlack,
                                    fontSize: 4.0.sp,
                                  ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              if (snapshot.hasData) {
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppConstants.appPrimaryColor.withOpacity(.5),
                          borderRadius: BorderRadius.circular(30)),
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                AppConstants.appPrimaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          backgroundColor:
                              AppConstants.appPrimaryColor.withOpacity(0.2),
                          child: Icon(
                            Icons.person_outline,
                            color: AppConstants.appBlack,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          coreBloc.superadminCompanyName ?? AppConstants.nA,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppConstants.appBlack,
                                    fontSize: 4.0.sp,
                                  ),
                        ),
                        Text(
                          coreBloc.superadminEmail ?? AppConstants.nA,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppConstants.appBlack,
                                    fontSize: 4.0.sp,
                                  ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return Shimmer.fromColors(
                baseColor: AppConstants.appShimmerBaseColor,
                highlightColor: AppConstants.appShimmerHighlightColor,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppConstants.appPrimaryColor.withOpacity(.5),
                          borderRadius: BorderRadius.circular(30)),
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                AppConstants.appPrimaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          backgroundColor:
                              AppConstants.appPrimaryColor.withOpacity(0.2),
                          child: Icon(
                            Icons.person_outline,
                            color: AppConstants.appBlack,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: AppConstants.appShimmerBaseColor,
                          height: 10.0.h,
                          width: 20.w,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          color: AppConstants.appShimmerBaseColor,
                          height: 10.0.h,
                          width: 40.w,
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
