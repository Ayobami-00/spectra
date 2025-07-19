import 'package:frontend/features/overview/presentation/ui/screens/widgets/index.dart';
import 'package:flutter/material.dart';

class OverviewCards extends StatelessWidget {
  const OverviewCards({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              InfoCard(
                title: "Staffs",
                value: "7",
                isLoading: true,
                onTap: () {},
              ),
              SizedBox(
                width: width / 64,
              ),
              InfoCard(
                title: "Tasks",
                value: "17",
                isLoading: true,
                onTap: () {},
              ),
              SizedBox(
                width: width / 64,
              ),
              InfoCard(
                title: "Inventory",
                value: "3",
                isLoading: true,
                onTap: () {},
              ),
              SizedBox(
                width: width / 64,
              ),
              InfoCard(
                title: "Restautants",
                value: "32",
                isLoading: true,
                onTap: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              InfoCard(
                title: "Lanes",
                value: "711",
                isLoading: true,
                onTap: () {},
              ),
              SizedBox(
                width: width / 64,
              ),
              InfoCard(
                title: "Games",
                value: "223321",
                isLoading: true,
                onTap: () {},
              ),
              SizedBox(
                width: width / 64,
              ),
              InfoCard(
                title: "Website Visits",
                value: "100000000",
                isLoading: true,
                onTap: () {},
              ),
              SizedBox(
                width: width / 64,
              ),
              InfoCard(
                title: "Bowling Leagues",
                value: "32",
                isLoading: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
