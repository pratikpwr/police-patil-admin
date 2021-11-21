import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class MissingScreen extends StatefulWidget {
  MissingScreen({Key? key}) : super(key: key);

  @override
  State<MissingScreen> createState() => _MissingScreenState();
}

class _MissingScreenState extends State<MissingScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<MissingRegisterBloc>(context).add(GetMissingData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MISSING),
        automaticallyImplyLeading: false,
        actions: [
          FilterButton(onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return const MissingFilterDataWidget();
                });
          })
        ],
      ),
      body: BlocListener<MissingRegisterBloc, MissingRegisterState>(
        listener: (context, state) {
          if (state is MissingLoadError) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<MissingRegisterBloc, MissingRegisterState>(
          builder: (context, state) {
            if (state is MissingDataLoading) {
              return const Loading();
            } else if (state is MissingDataLoaded) {
              if (state.missingResponse.data!.isEmpty) {
                return NoRecordFound();
              } else {
                return SafeArea(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        physics: const BouncingScrollPhysics(),
                        child: MissingDataTableWidget(
                            missingList: state.missingResponse.data!)),
                  ),
                );
              }
            } else if (state is MissingLoadError) {
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

class MissingDataTableWidget extends StatelessWidget {
  MissingDataTableWidget({Key? key, required this.missingList})
      : super(key: key);
  final List<MissingData> missingList;

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
                    label: Text("१८ वर्षावरील आहे का ?",
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
                    label:
                        Text(AADHAR_CARD, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("लिंग", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(AGE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("मिसिंग झाल्याची तारीख",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(REGISTER_DATE,
                        style: Styles.tableTitleTextStyle())),
              ],
              rows: List<DataRow>.generate(missingList.length, (index) {
                final missingData = missingList[index];
                return DataRow(cells: <DataCell>[
                  DataCell(Text(
                    missingData.isAdult! ? YES : NO,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    missingData.name ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    missingData.address ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(ViewLocWidget(
                      id: "collect${missingData.id!}",
                      lat: missingData.latitude!,
                      long: missingData.longitude!)),
                  missingData.photo != null
                      ? DataCell(ViewFileWidget(url: missingData.photo!))
                      : noDataInCell(),
                  missingData.aadhar != null
                      ? DataCell(ViewFileWidget(url: missingData.aadhar!))
                      : noDataInCell(),
                  DataCell(Text(
                    missingData.gender ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${missingData.age ?? "-"}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    showDate(missingData.missingDate),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${missingData.ppid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${missingData.psid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    showDate(missingData.createdAt),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}

class MissingFilterDataWidget extends StatefulWidget {
  const MissingFilterDataWidget({Key? key}) : super(key: key);

  @override
  _MissingFilterDataWidgetState createState() =>
      _MissingFilterDataWidgetState();
}

class _MissingFilterDataWidgetState extends State<MissingFilterDataWidget> {
  final _bloc = MissingRegisterBloc();
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
                      hint: "लिंग निवडा",
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
                        BlocProvider.of<MissingRegisterBloc>(context).add(
                            GetMissingData(
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
