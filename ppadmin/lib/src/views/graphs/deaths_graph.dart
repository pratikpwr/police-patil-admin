import 'package:flutter/material.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DeathsGraph extends StatefulWidget {
  const DeathsGraph({Key? key}) : super(key: key);

  @override
  State<DeathsGraph> createState() => _DeathsGraphState();
}

class _DeathsGraphState extends State<DeathsGraph> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
        height: 400,
        width: 600,
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(text: DEATHS),
            // Enable legend
            // legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: _tooltipBehavior,
            series: <LineSeries<DeathGraphData, String>>[
              LineSeries<DeathGraphData, String>(
                  color: Colors.deepOrange,
                  dataSource: <DeathGraphData>[
                    DeathGraphData('Jan', 35),
                    DeathGraphData('Feb', 12),
                    DeathGraphData('Mar', 24),
                    DeathGraphData('Apr', 32),
                    DeathGraphData('May', 20)
                  ],
                  xValueMapper: (DeathGraphData crimes, _) => crimes.month,
                  yValueMapper: (DeathGraphData crimes, _) => crimes.count,
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: true))
            ]));
  }
}

class DeathGraphData {
  String month;
  int count;

  DeathGraphData(this.month, this.count);
}
