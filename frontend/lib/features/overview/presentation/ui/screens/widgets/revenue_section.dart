import 'package:frontend/features/overview/presentation/ui/screens/widgets/index.dart';
import 'package:flutter/material.dart';

class RevenueSection extends StatelessWidget {
  const RevenueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              color: const Color(0xFFA4A6B3).withOpacity(.1),
              blurRadius: 12)
        ],
        border: Border.all(color: const Color(0xFFA4A6B3), width: .5),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 600,
                  height: 200,
                  child: ReservationGraph(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    RevenueInfo(
                      title: "Today's revenue",
                      amount: "230",
                    ),
                    RevenueInfo(
                      title: "Last 7 days",
                      amount: "1100",
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    RevenueInfo(
                      title: "Last 30 days",
                      amount: "3230",
                    ),
                    RevenueInfo(
                      title: "Last 12 months",
                      amount: "11300",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
