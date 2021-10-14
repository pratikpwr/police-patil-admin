import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class FiresScreen extends StatelessWidget {
  const FiresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FireRegisterBloc>(context).add(GetFireData());
    return Scaffold(
      appBar: CustomAppBar(
        title: BURNS,
      ),
      body: BlocListener<FireRegisterBloc, FireRegisterState>(
        listener: (context, state) {
          if (state is FireLoadError) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<FireRegisterBloc, FireRegisterState>(
          builder: (context, state) {
            if (state is FireDataLoading) {
              return loading();
            } else if (state is FireDataLoaded) {
              if (state.fireResponse.data!.isEmpty) {
                return noRecordFound();
              } else {
                return SafeArea(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      physics: const BouncingScrollPhysics(),
                      child: FireDataTableWidget(
                          fireList: state.fireResponse.data!)),
                );
              }
            } else if (state is FireLoadError) {
              return somethingWentWrong();
            } else {
              return somethingWentWrong();
            }
          },
        ),
      ),
    );
  }
}

class FireDataTableWidget extends StatelessWidget {
  FireDataTableWidget({Key? key, required this.fireList}) : super(key: key);
  final List<FireData> fireList;

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
                    label:
                        Text("घटनास्थळ", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("आगीचे कारण",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("अंदाजे झालेले नुकसान",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(DATE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(TIME, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(REGISTER_DATE,
                        style: Styles.tableTitleTextStyle())),
              ],
              rows: List<DataRow>.generate(fireList.length, (index) {
                final fireData = fireList[index];
                return DataRow(cells: <DataCell>[
                  DataCell(Text(
                    fireData.address!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    fireData.reason!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    fireData.loss!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    fireData.date!.toIso8601String(),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    fireData.time!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${fireData.ppid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${fireData.psid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    fireData.createdAt!.toIso8601String().substring(0, 10),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}
