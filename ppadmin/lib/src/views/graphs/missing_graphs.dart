import 'package:flutter/material.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MissingGraph extends StatefulWidget {
  const MissingGraph({Key? key}) : super(key: key);

  @override
  State<MissingGraph> createState() => _MissingGraphState();
}

class _MissingGraphState extends State<MissingGraph> {
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
            title: ChartTitle(text: MISSING),
            // Enable legend
            // legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: _tooltipBehavior,
            series: <ColumnSeries<MissingGraphData, String>>[
              ColumnSeries<MissingGraphData, String>(
                  name: MISSING,
                  color: Colors.yellow[700],
                  dataSource: <MissingGraphData>[
                    MissingGraphData('Jan', 14),
                    MissingGraphData('Feb', 43),
                    MissingGraphData('Mar', 21),
                    MissingGraphData('Apr', 12),
                    MissingGraphData('May', 56)
                  ],
                  xValueMapper: (MissingGraphData crimes, _) => crimes.month,
                  yValueMapper: (MissingGraphData crimes, _) => crimes.count,
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: true))
            ]));
  }
}

class MissingGraphData {
  String month;
  int count;

  MissingGraphData(this.month, this.count);
}
