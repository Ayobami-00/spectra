import 'dart:math';

import 'package:frontend/features/audit/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RightChildTimeline extends StatelessWidget {
  final Log step;

  const RightChildTimeline({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    double? minHeight = 60.0;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 8),
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: step.actorName,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
                TextSpan(
                  text: '  ${step.action}',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        // fontSize: 30,
                      ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class LeftChildTimeline extends StatelessWidget {
  final Log step;

  const LeftChildTimeline({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(step.createdAt! * 1000);
    String formattedDate = DateFormat('kk:mm').format(dateTime);

    Color? textColor = auditLogsUiAttributes(step).textColor;

    return Padding(
      padding: const EdgeInsets.only(right: 29),
      child: Text(
        formattedDate,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
      ),
    );
  }
}
