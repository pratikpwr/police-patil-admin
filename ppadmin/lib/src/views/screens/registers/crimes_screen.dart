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

  @override
  void initState() {
    BlocProvider.of<CrimeRegisterBloc>(context).add(GetCrimeData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(CRIMES),
        automaticallyImplyLeading: false,
        actions: [
          FilterButton(onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return const CrimeFilterDataWidget();
                });
          })
        ],
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
                        child: CrimeDataTableWidget(
                            crimeList: state.crimeResponse.data!)),
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
                    crimeData.registerNumber ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    showDate(crimeData.date),
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
                    showDate(crimeData.createdAt),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}

class CrimeFilterDataWidget extends StatefulWidget {
  const CrimeFilterDataWidget({Key? key}) : super(key: key);

  @override
  _CrimeFilterDataWidgetState createState() => _CrimeFilterDataWidgetState();
}

class _CrimeFilterDataWidgetState extends State<CrimeFilterDataWidget> {
  final _bloc = CrimeRegisterBloc();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<VillagePSListBloc>(context).add(GetVillagePSList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(32),
        // height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.4,
        child: BlocBuilder<VillagePSListBloc, VillagePSListState>(
          builder: (context, state) {
            if (state is VillagePSListLoading) {
              return const Loading();
            }
            if (state is VillagePSListSuccess) {
              return ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  spacer(),
                  buildDropButton(
                      value: _bloc.chosenType,
                      items: _bloc.types,
                      hint: CHOSE_TYPE,
                      onChanged: (String? value) {
                        setState(() {
                          _bloc.chosenType = value;
                        });
                      }),
                  spacer(),
                  villageSelectDropDown(
                      isPs: true,
                      list: getPSListInString(state.policeStations),
                      selValue: _bloc.psId,
                      onChanged: (value) {
                        _bloc.psId =
                            getPsIDFromPSName(state.policeStations, value!);
                      }),
                  spacer(),
                  villageSelectDropDown(
                      list: getVillageListInString(state.villages),
                      selValue: _bloc.ppId,
                      onChanged: (value) {
                        _bloc.ppId = getPpIDFromVillage(state.villages, value!);
                      }),
                  spacer(),
                  buildDateTextField(context, _fromController, DATE_FROM),
                  spacer(),
                  buildDateTextField(context, _toController, DATE_TO),
                  spacer(),
                  CustomButton(
                      text: APPLY_FILTER,
                      onTap: () {
                        Navigator.pop(context);
                        BlocProvider.of<CrimeRegisterBloc>(context).add(
                            GetCrimeData(
                                type: _bloc.chosenType,
                                ppId: _bloc.ppId,
                                psId: _bloc.psId,
                                fromDate: _fromController.text,
                                toDate: _toController.text));
                      })
                ],
              );
            }
            if (state is VillagePSListFailed) {
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
