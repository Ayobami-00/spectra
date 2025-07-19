import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';

class RevenueInfo extends StatelessWidget {
  final String? title;
  final String? amount;

  const RevenueInfo({super.key, this.title, this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "$title\n",
            style: TextStyle(fontSize: 16, color: AppConstants.appBlack),
          ),
          CustomCountupAnimation(
            begin: 0,
            end: double.tryParse(amount ?? "") ?? 0,
            style: TextStyle(fontSize: 24, color: AppConstants.appBlack),
            duration: const Duration(seconds: 1),
            isCurrency: true,
            decimalDigits: 0,
          )
        ],
      ),
    );
  }
}
