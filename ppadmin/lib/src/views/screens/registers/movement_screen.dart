import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class MovementScreen extends StatefulWidget {
  const MovementScreen({Key? key}) : super(key: key);

  @override
  State<MovementScreen> createState() => _MovementScreenState();
}

class _MovementScreenState extends State<MovementScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<MovementRegisterBloc>(context).add(GetMovementData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MOVEMENT_REGISTER),
        automaticallyImplyLeading: false,
        actions: [
          FilterButton(onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return const MovementFilterDataWidget();
                });
          })
        ],
      ),
      body: BlocListener<MovementRegisterBloc, MovementRegisterState>(
        listener: (context, state) {
          if (state is MovementLoadError) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<MovementRegisterBloc, MovementRegisterState>(
          builder: (context, state) {
            if (state is MovementDataLoading) {
              return const Loading();
            } else if (state is MovementDataLoaded) {
              if (state.movementResponse.movementData!.isEmpty) {
                return NoRecordFound();
              } else {
                return SafeArea(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        physics: const BouncingScrollPhysics(),
                        child: MovementDataTableWidget(
                            movementList:
                                state.movementResponse.movementData!)),
                  ),
                );
              }
            } else if (state is MovementLoadError) {
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

class MovementDataTableWidget extends StatelessWidget {
  MovementDataTableWidget({Key? key, required this.movementList})
      : super(key: key);
  final List<MovementData> movementList;

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
                    label: Text(TYPE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(SUB_TYPE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(PLACE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("GPS", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(DATE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(IS_ISSUE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label:
                        Text(ATTENDANCE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("हालचालीचा फोटो",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(REGISTER_DATE,
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(MOVEMENT_DESCRIPTION,
                        style: Styles.tableTitleTextStyle())),
              ],
              rows: List<DataRow>.generate(movementList.length, (index) {
                final movementData = movementList[index];
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
                      id: "movement${movementData.id!}",
                      lat: movementData.latitude!,
                      long: movementData.longitude!)),
                  DataCell(Text(
                    showDate(movementData.datetime),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    movementData.issue == 1 ? YES : NO,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${movementData.attendance ?? "-"}",
                    style: Styles.tableValuesTextStyle(),
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
                    showDate(movementData.createdAt),
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
                ]);
              }))),
    );
  }
}

class MovementFilterDataWidget extends StatefulWidget {
  const MovementFilterDataWidget({Key? key}) : super(key: key);

  @override
  _MovementFilterDataWidgetState createState() =>
      _MovementFilterDataWidgetState();
}

class _MovementFilterDataWidgetState extends State<MovementFilterDataWidget> {
  final _bloc = MovementRegisterBloc();
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
                        BlocProvider.of<MovementRegisterBloc>(context).add(
                            GetMovementData(
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
