import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class DeathScreen extends StatefulWidget {
  DeathScreen({Key? key}) : super(key: key);

  @override
  State<DeathScreen> createState() => _DeathScreenState();
}

class _DeathScreenState extends State<DeathScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<DeathRegisterBloc>(context).add(GetDeathData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(DEATHS),
        automaticallyImplyLeading: false,
        actions: [
          FilterButton(onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return const DeathFilterDataWidget();
                });
          })
        ],
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
                    label: Text("????????? ?????????????????? ????????? ?????? ?",
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
                    label: Text("????????????", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(AGE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("???????????? ?????????????????? ???????????????",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("?????????????????? ???????????????????????? ????????????",
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
                    deathData.gender ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${deathData.age ?? "-"}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    deathData.foundAddress ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    deathData.causeOfDeath ?? "-",
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
                    showDate(deathData.createdAt),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}

class DeathFilterDataWidget extends StatefulWidget {
  const DeathFilterDataWidget({Key? key}) : super(key: key);

  @override
  _DeathFilterDataWidgetState createState() => _DeathFilterDataWidgetState();
}

class _DeathFilterDataWidgetState extends State<DeathFilterDataWidget> {
  final _bloc = DeathRegisterBloc();
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
                  // TODO: isKnown
                  buildDropButton(
                      value: _bloc.chosenType,
                      items: _bloc.types,
                      hint: "???????????? ???????????????",
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
                        BlocProvider.of<DeathRegisterBloc>(context).add(
                            GetDeathData(
                                type: _bloc.chosenType,
                                isKnown: _bloc.isKnown,
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
