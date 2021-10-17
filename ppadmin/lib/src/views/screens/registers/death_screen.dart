import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class DeathScreen extends StatelessWidget {
  DeathScreen({Key? key}) : super(key: key);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DeathRegisterBloc>(context).add(GetDeathData());
    return Scaffold(
      appBar: CustomAppBar(
        title: DEATHS,
      ),
      body: BlocListener<DeathRegisterBloc, DeathRegisterState>(
        listener: (context, state) {
          if (state is DeathLoadError) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<DeathRegisterBloc, DeathRegisterState>(
          builder: (context, state) {
            if (state is DeathDataLoading) {
              return const Loading();
            } else if (state is DeathDataLoaded) {
              if (state.deathResponse.data!.isEmpty) {
                return NoRecordFound();
              } else {
                return SafeArea(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        physics: const BouncingScrollPhysics(),
                        child: DeathDataTableWidget(
                            deathList: state.deathResponse.data!)),
                  ),
                );
              }
            } else if (state is DeathLoadError) {
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

class DeathDataTableWidget extends StatelessWidget {
  DeathDataTableWidget({Key? key, required this.deathList}) : super(key: key);
  final List<DeathData> deathList;

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
                    label: Text("ओळख पटलेली आहे का ?",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(NAME, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(ADDRESS, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(GPS, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(PHOTO, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("लिंग", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(AGE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("कोठे सापडले ठिकाण",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("मरणाचे प्राथमिक कारण",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(REGISTER_DATE,
                        style: Styles.tableTitleTextStyle())),
              ],
              rows: List<DataRow>.generate(deathList.length, (index) {
                final deathData = deathList[index];
                return DataRow(cells: <DataCell>[
                  DataCell(Text(
                    deathData.isKnown! ? YES : NO,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    deathData.name ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    deathData.address ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(ViewLocWidget(
                      id: "collect${deathData.id!}",
                      lat: deathData.latitude!,
                      long: deathData.longitude!)),
                  deathData.photo != null
                      ? DataCell(ViewFileWidget(url: deathData.photo!))
                      : noDataInCell(),
                  DataCell(Text(
                    deathData.gender!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${deathData.age ?? "-"}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    deathData.foundAddress!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    deathData.causeOfDeath!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  // TODO : date od death
                  DataCell(Text(
                    "${deathData.ppid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${deathData.psid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    deathData.createdAt!.toIso8601String().substring(0, 10),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}
