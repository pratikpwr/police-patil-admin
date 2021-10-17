import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class CrimesScreen extends StatefulWidget {
  const CrimesScreen({Key? key}) : super(key: key);

  @override
  State<CrimesScreen> createState() => _CrimesScreenState();
}

class _CrimesScreenState extends State<CrimesScreen> {
  final _scrollController = ScrollController();

  final _bloc = CrimeRegisterBloc();

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
              return const Loading();
            } else if (state is CrimeDataLoaded) {
              if (state.crimeResponse.data!.isEmpty) {
                return NoRecordFound();
              } else {
                return SafeArea(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            spacer(),
                            buildDropButton(
                                value: _bloc.value,
                                items: _bloc.types,
                                hint: CHOSE_TYPE,
                                onChanged: (String? value) {
                                  setState(() {
                                    _bloc.value = value;
                                  });
                                }),
                            spacer(),
                            const Divider(
                              height: 1,
                            ),
                            CrimeDataTableWidget(
                                crimeList: _bloc
                                    .typeWiseData(state.crimeResponse.data!)),
                          ],
                        )),
                  ),
                );
              }
            } else if (state is CrimeLoadError) {
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
