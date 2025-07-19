import 'package:frontend/features/overview/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.getWidth(context),
      height: AppConstants.getAppHeight(context),
      child: Expanded(
        child: ListView(
          children: const [
            OverviewCards(),
            RevenueSection(),
          ],
        ),
      ),
    );
  }
}
