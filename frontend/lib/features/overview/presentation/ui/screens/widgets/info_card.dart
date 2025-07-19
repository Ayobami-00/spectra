import 'package:frontend/features/overview/data/index.dart';
import 'package:frontend/features/overview/presentation/logic/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isLoading;
  final Function() onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BlocProvider.of<OverviewCubit>(context)
          .getAnalyticsLogic(title.toLowerCase()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Expanded(
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 140,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 6),
                    color: const Color(0xFFA4A6B3).withOpacity(.1),
                    blurRadius: 12,
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: snapshot.connectionState == ConnectionState.waiting
                  ? Shimmer.fromColors(
                      baseColor: AppConstants.appShimmerBaseColor,
                      highlightColor: AppConstants.appShimmerHighlightColor,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                color: AppConstants.appPrimaryColor,
                                height: 5,
                              ))
                            ],
                          ),
                          Expanded(child: Container()),
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "$title\n",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppConstants.appBlack),
                                ),
                                TextSpan(
                                  text: " ",
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: AppConstants.appBlack),
                                ),
                              ])),
                          Expanded(child: Container()),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              color: AppConstants.appPrimaryColor,
                              height: 5,
                            ))
                          ],
                        ),
                        Expanded(child: Container()),
                        Padding(
                          padding: EdgeInsets.only(top: 30.0.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "$title\n",
                                style: TextStyle(
                                    fontSize: 16, color: AppConstants.appBlack),
                              ),
                              CustomCountupAnimation(
                                begin: 0,
                                end: (snapshot.data as AnalyticsResponse)
                                        .data
                                        ?.total
                                        .toDouble() ??
                                    0,
                                style: TextStyle(
                                    fontSize: 40, color: AppConstants.appBlack),
                                duration: const Duration(seconds: 1),
                              )
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
