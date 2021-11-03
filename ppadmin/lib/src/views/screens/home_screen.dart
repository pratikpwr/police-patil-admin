import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:ppadmin/src/views/views.dart';
import 'package:shared/shared.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(GetHomeData());
    return Scaffold(
      appBar: AppBar(
          title: const Text("पोलीस पाटील ॲप"),
          automaticallyImplyLeading: false),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            showSnackBar(context, state.error);
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Loading();
            } else if (state is HomeSuccess) {
              return SafeArea(
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Top10PPWidget(
                          pp: state.data.topPP!,
                        ),
                        spacer(height: 24),
                        LatestIllegalWidget(
                            illegalList: state.data.latestIllegal!),
                        spacer(height: 24),
                        LatestWatchWidget(watchList: state.data.latestWatch!),
                        spacer(height: 24),
                        LatestMovementWidget(
                            moveData: state.data.latestMovement!),
                        spacer(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is UsersLoadError) {
              return SomethingWentWrong();
            } else {
              return SomethingWentWrong();
            }
          },
        ),
      ),
    );
  }
}

class LatestMovementWidget extends StatelessWidget {
  LatestMovementWidget({Key? key, required this.moveData}) : super(key: key);
  final List<MovementData> moveData;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CONTAINER_BACKGROUND_COLOR,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            "Latest Halchali",
            style: Styles.titleTextStyle(fontSize: 22),
          ),
          spacer(height: 8),
          Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text(TYPE, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(SUB_TYPE,
                            style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text(PLACE, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text("GPS", style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(DATE, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(IS_ISSUE,
                            style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(ATTENDANCE,
                            style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(MOVEMENT_DESCRIPTION,
                            style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text("हालचालीचा फोटो",
                            style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text("PPID", style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text("PSID", style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(REGISTER_DATE,
                            style: Styles.tableTitleTextStyle())),
                  ],
                  rows: List<DataRow>.generate(moveData.length, (index) {
                    final movementData = moveData[index];
                    return DataRow(cells: <DataCell>[
                      DataCell(Text(
                        movementData.type!,
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        movementData.subtype!,
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        movementData.address ?? "-",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(ViewLocWidget(
                          id: "move${movementData.id!}",
                          lat: movementData.latitude!,
                          long: movementData.longitude!)),
                      DataCell(Text(
                        showDate(movementData.datetime),
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        movementData.issue! == 1 ? YES : NO,
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        "${movementData.attendance ?? "-"}",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(SizedBox(
                        width: 350,
                        child: Text(
                          movementData.description ?? "-",
                          maxLines: 3,
                          style: Styles.tableValuesTextStyle(),
                        ),
                      )),
                      movementData.photo != null
                          ? DataCell(ViewFileWidget(url: movementData.photo!))
                          : noDataInCell(),
                      DataCell(Text(
                        "${movementData.ppid!}",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        "${movementData.psid!}",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        movementData.createdAt!
                            .toIso8601String()
                            .substring(0, 10),
                        style: Styles.tableValuesTextStyle(),
                      )),
                    ]);
                  })),
            ),
          ),
        ],
      ),
    );
  }
}

class Top10PPWidget extends StatelessWidget {
  Top10PPWidget({Key? key, required this.pp}) : super(key: key);
  final List<UserClass> pp;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CONTAINER_BACKGROUND_COLOR,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            "Top 10 Active Police Patil",
            style: Styles.titleTextStyle(fontSize: 22),
          ),
          spacer(height: 8),
          Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text("ID", style: Styles.tableTitleTextStyle())),
                  DataColumn(
                      label: Text(NAME, style: Styles.tableTitleTextStyle())),
                  DataColumn(
                      label: Text("गाव", style: Styles.tableTitleTextStyle())),
                  DataColumn(
                      label:
                          Text("Email", style: Styles.tableTitleTextStyle())),
                  DataColumn(
                      label: Text(PHOTO, style: Styles.tableTitleTextStyle())),
                  DataColumn(
                      label: Text(MOB_NO, style: Styles.tableTitleTextStyle())),
                  DataColumn(
                      label: Text("PSID", style: Styles.tableTitleTextStyle())),
                ],
                rows: List<DataRow>.generate(pp.length, (index) {
                  final user = pp[index];
                  return DataRow(cells: <DataCell>[
                    customTextDataCell("${user.id ?? 0}"),
                    customTextDataCell(user.name ?? "-"),
                    customTextDataCell(user.village ?? "-"),
                    customTextDataCell(user.email ?? "-"),
                    user.photo != null
                        ? DataCell(ViewFileWidget(url: user.photo!))
                        : noDataInCell(),
                    customTextDataCell("${user.mobile ?? 0}"),
                    customTextDataCell("${user.psid ?? 0}"),
                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LatestWatchWidget extends StatelessWidget {
  LatestWatchWidget({Key? key, required this.watchList}) : super(key: key);
  final List<WatchData> watchList;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CONTAINER_BACKGROUND_COLOR,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            "Latest Nigrani Data",
            style: Styles.titleTextStyle(fontSize: 22),
          ),
          spacer(height: 8),
          Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text(TYPE, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(NAME, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text(MOB_NO, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text(PHOTO, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(AADHAR_CARD,
                            style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text(ADDRESS, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(GPS, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(OTHER_INFO,
                            style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text("PPID", style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text("PSID", style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(REGISTER_DATE,
                            style: Styles.tableTitleTextStyle())),
                  ],
                  rows: List<DataRow>.generate(watchList.length, (index) {
                    final watchData = watchList[index];
                    return DataRow(cells: <DataCell>[
                      DataCell(Text(
                        watchData.type!,
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        watchData.name ?? "-",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        "${watchData.mobile ?? "-"}",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      watchData.photo != null
                          ? DataCell(ViewFileWidget(url: watchData.photo!))
                          : noDataInCell(),
                      watchData.aadhar != null
                          ? DataCell(ViewFileWidget(url: watchData.aadhar!))
                          : noDataInCell(),
                      DataCell(Text(
                        watchData.address ?? "-",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(ViewLocWidget(
                          id: "watch${watchData.id!}",
                          lat: watchData.latitude!,
                          long: watchData.longitude!)),
                      DataCell(SizedBox(
                        width: 400,
                        child: Text(
                          watchData.description ?? "-",
                          maxLines: 3,
                          style: Styles.tableValuesTextStyle(),
                        ),
                      )),
                      DataCell(Text(
                        "${watchData.ppid!}",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        "${watchData.psid!}",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        watchData.createdAt!.toIso8601String().substring(0, 10),
                        style: Styles.tableValuesTextStyle(),
                      )),
                    ]);
                  })),
            ),
          ),
        ],
      ),
    );
  }
}

class LatestIllegalWidget extends StatelessWidget {
  LatestIllegalWidget({Key? key, required this.illegalList}) : super(key: key);
  final List<IllegalData> illegalList;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CONTAINER_BACKGROUND_COLOR,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            "Latest Illegal Works",
            style: Styles.titleTextStyle(fontSize: 22),
          ),
          spacer(height: 8),
          Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text(TYPE, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(NAME, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text(ADDRESS, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(GPS, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text(PHOTO, style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text("PPID", style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label:
                            Text("PSID", style: Styles.tableTitleTextStyle())),
                    DataColumn(
                        label: Text(REGISTER_DATE,
                            style: Styles.tableTitleTextStyle())),
                  ],
                  rows: List<DataRow>.generate(illegalList.length, (index) {
                    final illegalData = illegalList[index];
                    return DataRow(cells: <DataCell>[
                      DataCell(Text(
                        illegalData.type!,
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        illegalData.name ?? "-",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        illegalData.address ?? "-",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(ViewLocWidget(
                          id: "illegal${illegalData.id!}",
                          lat: illegalData.latitude!,
                          long: illegalData.longitude!)),
                      illegalData.photo != null
                          ? DataCell(ViewFileWidget(url: illegalData.photo!))
                          : noDataInCell(),
                      DataCell(Text(
                        "${illegalData.ppid!}",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        "${illegalData.psid!}",
                        style: Styles.tableValuesTextStyle(),
                      )),
                      DataCell(Text(
                        illegalData.createdAt!
                            .toIso8601String()
                            .substring(0, 10),
                        style: Styles.tableValuesTextStyle(),
                      )),
                    ]);
                  })),
            ),
          ),
        ],
      ),
    );
  }
}

//              Responsive(
//               desktop: Column(
//                 children: [
//                   Row(
//                     children: const [CrimesGraph(), MovementGraph()],
//                   ),
//                   Row(
//                     children: const [DeathsGraph(), MissingGraph()],
//                   ),
//                   Row(
//                     children: [IllegalLocMap()],
//                   ),
//                 ],
//               ),
//               mobile: Column(
//                 children: const [
//                   CrimesGraph(),
//                   MovementGraph(),
//                   DeathsGraph(),
//                   MissingGraph()
//                 ],
//               ),
//             )
