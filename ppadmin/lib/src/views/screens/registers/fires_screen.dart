import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class FiresScreen extends StatefulWidget {
  FiresScreen({Key? key}) : super(key: key);

  @override
  State<FiresScreen> createState() => _FiresScreenState();
}

class _FiresScreenState extends State<FiresScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<FireRegisterBloc>(context).add(GetFireData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(BURNS),
        automaticallyImplyLeading: false,
        actions: [
          FilterButton(onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return const FireFilterDataWidget();
                });
          })
        ],
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
              return const Loading();
            } else if (state is FireDataLoaded) {
              if (state.fireResponse.data!.isEmpty) {
                return NoRecordFound();
              } else {
                return SafeArea(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        physics: const BouncingScrollPhysics(),
                        child: FireDataTableWidget(
                            fireList: state.fireResponse.data!)),
                  ),
                );
              }
            } else if (state is FireLoadError) {
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
                    label: Text(GPS, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(PHOTO, style: Styles.tableTitleTextStyle())),
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
                    fireData.address ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(ViewLocWidget(
                      id: "collect${fireData.id!}",
                      lat: fireData.latitude!,
                      long: fireData.longitude!)),
                  fireData.photo != null
                      ? DataCell(ViewFileWidget(url: fireData.photo!))
                      : noDataInCell(),
                  DataCell(Text(
                    fireData.reason ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    fireData.loss ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    showDate(fireData.date),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    fireData.time ?? "-",
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
                    showDate(fireData.createdAt),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}

class FireFilterDataWidget extends StatefulWidget {
  const FireFilterDataWidget({Key? key}) : super(key: key);

  @override
  _FireFilterDataWidgetState createState() => _FireFilterDataWidgetState();
}

class _FireFilterDataWidgetState extends State<FireFilterDataWidget> {
  final _bloc = FireRegisterBloc();
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
                        BlocProvider.of<FireRegisterBloc>(context).add(
                            GetFireData(
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
