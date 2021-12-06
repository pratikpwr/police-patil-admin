import 'package:flutter/material.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/views/views.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DeathsGraph extends StatefulWidget {
  DeathsGraph({Key? key}) : super(key: key);

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
        width: double.infinity,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FilterButton(onTap: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return const FilterDataWidget();
                    });
              }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: ILLEGAL_WORKS),
                  // Enable legend
                  // legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: _tooltipBehavior,
                  series: <ColumnSeries<DeathGraphData, String>>[
                    ColumnSeries<DeathGraphData, String>(
                        name: ILLEGAL_WORKS,
                        color: Colors.deepOrange,
                        dataSource: <DeathGraphData>[
                          DeathGraphData('Jan', 23),
                          DeathGraphData('Feb', 12),
                          DeathGraphData('Mar', 21),
                          DeathGraphData('Apr', 32),
                          DeathGraphData('May', 18),
                          DeathGraphData('Jun', 29),
                          DeathGraphData('Jul', 12),
                          DeathGraphData('Aug', 27),
                          DeathGraphData('Sep', 22),
                          DeathGraphData('Oct', 9)
                        ],
                        xValueMapper: (DeathGraphData crimes, _) =>
                            crimes.month,
                        yValueMapper: (DeathGraphData crimes, _) =>
                            crimes.count,
                        // Enable data label
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true))
                  ]),
            ),
          ],
        ));
  }
}

class DeathGraphData {
  String month;
  int count;

  DeathGraphData(this.month, this.count);
}
