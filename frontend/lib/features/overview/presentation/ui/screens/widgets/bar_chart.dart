import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReservationGraph extends StatefulWidget {
  const ReservationGraph({super.key});

  @override
  State<ReservationGraph> createState() => _ReservationGraphState();
}

class _ReservationGraphState extends State<ReservationGraph> {
  List<SalesData> data = [];
  List<SalesData> filteredData = [];
  String filter = 'Year';

  @override
  void initState() {
    super.initState();
    data = generateReservationData();
    filteredData = data;
  }

  List<SalesData> generateReservationData() {
    List<SalesData> data = [];
    DateTime startDate = DateTime(2024, 7, 1);
    DateTime endDate = DateTime.now();
    Random random = Random();

    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      data.add(SalesData(date, random.nextDouble() * 500));
    }

    return data;
  }

  void filterData(String filter) {
    setState(() {
      this.filter = filter;
      if (filter == 'Year') {
        filteredData = data; // Show yearly data
      } else if (filter == 'Month') {
        // Filter data by month
        filteredData =
            data.where((d) => d.date.month == DateTime.now().month).toList();
      } else if (filter == 'Week') {
        // Filter data by week
        filteredData = data
            .where((d) => d.date
                .isAfter(DateTime.now().subtract(const Duration(days: 7))))
            .toList();
      } else if (filter == 'Day') {
        // Filter data by day
        filteredData =
            data.where((d) => d.date.day == DateTime.now().day).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // DropdownButton<String>(
            //   value: filter,
            //   items:
            //       <String>['Year', 'Month', 'Week', 'Day'].map((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (newValue) {
            //     filterData(newValue!);
            //   },
            // ),
          ],
        ),
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: const DateTimeAxis(),
            title: const ChartTitle(text: 'No of reservations'),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<dynamic, dynamic>>[
              LineSeries<SalesData, DateTime>(
                dataSource: filteredData,
                xValueMapper: (SalesData sales, _) => sales.date,
                yValueMapper: (SalesData sales, _) => sales.sales,
                name: 'Reservations',
                // dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class SalesData {
  SalesData(this.date, this.sales);
  final DateTime date;
  final double sales;
}
