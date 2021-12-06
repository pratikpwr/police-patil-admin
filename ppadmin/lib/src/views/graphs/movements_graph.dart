import 'package:flutter/material.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/views/views.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MovementGraph extends StatefulWidget {
  MovementGraph({Key? key}) : super(key: key);

  @override
  State<MovementGraph> createState() => _MovementGraphState();
}

class _MovementGraphState extends State<MovementGraph> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
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
                  title: ChartTitle(text: MOVEMENTS),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: _tooltipBehavior,
                  series: <LineSeries<MovementGraphData, String>>[
                    LineSeries<MovementGraphData, String>(
                        name: "राजकीय",
                        color: Colors.orange,
                        dataSource: <MovementGraphData>[
                          MovementGraphData('Jan', 35),
                          MovementGraphData('Feb', 28),
                          MovementGraphData('Mar', 34),
                          MovementGraphData('Apr', 32),
                          MovementGraphData('May', 40)
                        ],
                        xValueMapper: (MovementGraphData crimes, _) =>
                            crimes.month,
                        yValueMapper: (MovementGraphData crimes, _) =>
                            crimes.count,
                        // Enable data label
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true)),
                    LineSeries<MovementGraphData, String>(
                        name: "धार्मिक",
                        color: Colors.red,
                        dataSource: <MovementGraphData>[
                          MovementGraphData('Jan', 23),
                          MovementGraphData('Feb', 39),
                          MovementGraphData('Mar', 14),
                          MovementGraphData('Apr', 42),
                          MovementGraphData('May', 30)
                        ],
                        xValueMapper: (MovementGraphData crimes, _) =>
                            crimes.month,
                        yValueMapper: (MovementGraphData crimes, _) =>
                            crimes.count,
                        // Enable data label
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true)),
                    LineSeries<MovementGraphData, String>(
                        name: "जातीय",
                        color: Colors.blue,
                        dataSource: <MovementGraphData>[
                          MovementGraphData('Jan', 13),
                          MovementGraphData('Feb', 23),
                          MovementGraphData('Mar', 28),
                          MovementGraphData('Apr', 22),
                          MovementGraphData('May', 36)
                        ],
                        xValueMapper: (MovementGraphData crimes, _) =>
                            crimes.month,
                        yValueMapper: (MovementGraphData crimes, _) =>
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

class MovementGraphData {
  String month;
  int count;

  MovementGraphData(this.month, this.count);
}
