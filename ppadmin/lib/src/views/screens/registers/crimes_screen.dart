import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class CrimesScreen extends StatelessWidget {
  CrimesScreen({Key? key}) : super(key: key);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CrimeRegisterBloc>(context).add(GetCrimeData());
    return Scaffold(
      appBar: CustomAppBar(
        title: CRIMES,
      ),
      body: BlocListener<CrimeRegisterBloc, CrimeRegisterState>(
        listener: (context, state) {
          if (state is CrimeLoadError) {
            debugPrint(state.message);
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<CrimeRegisterBloc, CrimeRegisterState>(
          builder: (context, state) {
            if (state is CrimeDataLoading) {
              return loading();
            } else if (state is CrimeDataLoaded) {
              return SafeArea(
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      physics: const BouncingScrollPhysics(),
                      child: CrimeDataTableWidget(
                          crimeList: state.crimeResponse.data!)),
                ),
              );
            } else if (state is CrimeLoadError) {
              if (state.message == 'Record Empty') {
                return noRecordFound();
              } else {
                return somethingWentWrong();
              }
            } else {
              return somethingWentWrong();
            }
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (_) {
      //       return const CrimeRegFormScreen();
      //     })).then((value) {
      //       BlocProvider.of<CrimeRegisterBloc>(context).add(GetCrimeData());
      //     });
      //   },
      //   child: const Icon(Icons.add, size: 24),
      // ),
    );
  }
}

class CrimeDataTableWidget extends StatelessWidget {
  CrimeDataTableWidget({Key? key, required this.crimeList}) : super(key: key);
  final List<CrimeData> crimeList;

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
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
                    label: Text("गुन्ह्याचा प्रकार",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("गुन्हा रजिस्टर नंबर",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(DATE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(REGISTER_DATE,
                        style: Styles.tableTitleTextStyle())),
              ],
              rows: List<DataRow>.generate(crimeList.length, (index) {
                final crimeData = crimeList[index];
                return DataRow(cells: <DataCell>[
                  DataCell(Text(
                    crimeData.type!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    crimeData.registerNumber!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    crimeData.date!.toIso8601String(),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${crimeData.ppid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${crimeData.psid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    crimeData.createdAt!.toIso8601String().substring(0, 10),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}
