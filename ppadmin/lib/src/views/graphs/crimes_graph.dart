import 'package:flutter/material.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CrimesGraph extends StatefulWidget {
  const CrimesGraph({Key? key}) : super(key: key);

  @override
  State<CrimesGraph> createState() => _CrimesGraphState();
}

class _CrimesGraphState extends State<CrimesGraph> {
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
            title: ChartTitle(text: CRIMES),
            // Enable legend
            // legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: _tooltipBehavior,
            series: <ColumnSeries<CrimeGraphData, String>>[
              ColumnSeries<CrimeGraphData, String>(
                  color: Colors.red[400],
                  dataSource: <CrimeGraphData>[
                    CrimeGraphData('Jan', 35),
                    CrimeGraphData('Feb', 28),
                    CrimeGraphData('Mar', 34),
                    CrimeGraphData('Apr', 32),
                    CrimeGraphData('May', 40)
                  ],
                  xValueMapper: (CrimeGraphData crimes, _) => crimes.month,
                  yValueMapper: (CrimeGraphData crimes, _) => crimes.count,
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: true))
            ]));
  }
}

class CrimeGraphData {
  String month;
  int count;

  CrimeGraphData(this.month, this.count);
}
