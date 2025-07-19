import 'package:frontend/features/audit/index.dart';
import 'package:frontend/features/audit/presentation/ui/widgets/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:frontend/utils/widgets/custom_button_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AuditLog extends StatefulWidget {
  const AuditLog({super.key});

  @override
  State<AuditLog> createState() => _AuditsState();
}

class _AuditsState extends State<AuditLog> {
  final tableController = PagedDataTableController<String, Log>();

  @override
  void initState() {
    // final params = AuditParams();
    super.initState();
  }

  final ValueNotifier<Future<AuditResponse>> _auditLogsResponse =
      ValueNotifier(Future.value(AuditResponse.initial()));

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  Future<AuditResponse> _getAllAudits(AuditsCubit bloc) async {
    _isLoading.value = true;
    final res = await bloc.getAllAuditsLogic();
    _isLoading.value = false;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final auditBloc = BlocProvider.of<AuditsCubit>(context);
    return SizedBox(
      width: AppConstants.getWidth(context),
      height: AppConstants.getAppHeight(context),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AuditMenuBar(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 100.h,
                ),
                child: Builder(builder: (context) {
                  return ValueListenableBuilder(
                      valueListenable: _isLoading,
                      builder: (context, value, child) {
                        return CustomOmSolidButton(
                          isLoading: value,
                          onPressed: () {
                            _auditLogsResponse.value = _getAllAudits(auditBloc);
                          },
                          text: "Submit",
                          fontSize: 15.h,
                          widthS: 70.h,
                          heightS: 40.h,
                          buttonColor: AppConstants.appPrimaryColor,
                        );
                      });
                }),
              ),
            ],
          ),
          Expanded(
            child: PagedDataTableTheme(
                data: PagedDataTableThemeData(
                  chipTheme: ChipThemeData(
                    backgroundColor: AppConstants.appPrimaryColor,
                    selectedColor: Colors.blue,
                    disabledColor: Colors.grey,
                    padding: const EdgeInsets.all(8),
                    shape: const StadiumBorder(),
                    labelStyle:
                        Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                    secondaryLabelStyle:
                        Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                  ),
                  backgroundColor: Colors.grey[100]!,
                  selectedRow: AppConstants.appPrimaryColor,
                  // filterBarHeight: 50.h,
                  headerTextStyle:
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                  cellTextStyle:
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                  footerTextStyle:
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                ),
                child: Theme(
                  data: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSeed(
                        seedColor: AppConstants.appPrimaryColor),
                  ),
                  child: ValueListenableBuilder(
                      valueListenable: _auditLogsResponse,
                      builder: (
                        BuildContext builder,
                        Future<AuditResponse> response,
                        Widget? child,
                      ) {
                        _auditLogsResponse.value = _getAllAudits(auditBloc);
                        return FutureBuilder(
                            future: response,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data.status != "initial") {
                                final data = snapshot.data as AuditResponse;

                                if (!data.hasError) {
                                  final auditTrails =
                                      data.data!.logs as List<Log>;
                                  return GroupedListView<Log, DateTime>(
                                    elements: auditTrails,
                                    groupBy: (m) {
                                      DateTime dateTime =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              m.createdAt! * 1000);

                                      return DateTime(
                                        dateTime.year,
                                        dateTime.month,
                                        dateTime.day,
                                      );
                                    },
                                    order: GroupedListOrder.DESC,
                                    groupSeparatorBuilder:
                                        (DateTime groupbyvalue) {
                                      return Padding(
                                        padding: EdgeInsets.only(top: 32),
                                        child: SizedBox(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateFormat(DateFormat.YEAR)
                                                            .format(
                                                                groupbyvalue) ==
                                                        "${DateTime.now().year}"
                                                    ? DateFormat(DateFormat
                                                            .MONTH_DAY)
                                                        .format(groupbyvalue)
                                                    : DateFormat(DateFormat
                                                            .YEAR_MONTH_DAY)
                                                        .format(groupbyvalue),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      letterSpacing: 0.40,
                                                      color:
                                                          HexColor('#2F2F2F'),
                                                    ),
                                              ),
                                              const Divider()
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    indexedItemBuilder:
                                        (context, value, index) {
                                      final Log trail = value;
                                      final IndicatorStyle indicator =
                                          _indicatorStyleCheckpoint(trail);
                                      final righChild =
                                          RightChildTimeline(step: trail);

                                      Widget? leftChild;
                                      if (trail.id != null) {
                                        leftChild =
                                            LeftChildTimeline(step: trail);
                                      }

                                      return TimelineTile(
                                        alignment: TimelineAlign.manual,
                                        isFirst: index == 0,
                                        isLast: index == auditTrails.length - 1,
                                        lineXY: 0.09,
                                        indicatorStyle: indicator,
                                        startChild: leftChild,
                                        endChild: righChild,
                                        hasIndicator: true,
                                        beforeLineStyle: LineStyle(
                                          color: auditLogsUiAttributes(trail)
                                              .iconColor!,
                                          thickness: 3,
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Container(
                                    width: 100.h,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          20), // Adjust this value to make the corners more or less rounded
                                    ),
                                    child: Text(
                                      "${data.message}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                  );
                                }
                              } else {
                                return ButtonLoadingIndicator(
                                  color: AppConstants.appBlack,
                                );
                                // return Shimmer.fromColors(
                                //   baseColor: AppConstants.appShimmerBaseColor,
                                //   highlightColor:
                                //       AppConstants.appShimmerHighlightColor,
                                //   child: TimelineTile(
                                //     alignment: TimelineAlign.manual,
                                //     isFirst: true,
                                //     isLast: true,
                                //     lineXY: 0.09,
                                //     hasIndicator: true,
                                //     beforeLineStyle: const LineStyle(
                                //       color: Colors.green,
                                //       thickness: 8,
                                //     ),
                                //   ),
                                // );
                              }
                            });
                      }),
                )),
          ),
        ],
      ),
    );
  }

  IndicatorStyle _indicatorStyleCheckpoint(Log step) {
    AutitLogAttributes attributes = auditLogsUiAttributes(step);
    double iconSize = 10.0;

    return IndicatorStyle(
      width: iconSize * 2,
      height: iconSize * 2,
      indicator: Container(
        decoration: BoxDecoration(
          color: attributes.backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Center(
          child: Icon(
            attributes.icon,
            color: attributes.iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
