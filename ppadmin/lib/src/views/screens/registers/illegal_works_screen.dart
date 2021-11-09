import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class IllegalScreen extends StatefulWidget {
  const IllegalScreen({Key? key}) : super(key: key);

  @override
  State<IllegalScreen> createState() => _IllegalScreenState();
}

class _IllegalScreenState extends State<IllegalScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<IllegalRegisterBloc>(context).add(GetIllegalData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ILLEGAL_WORKS),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return const IllegalFilterDataWidget();
                    });
              },
              icon: const Icon(Icons.filter_alt_rounded))
        ],
      ),
      body: BlocListener<IllegalRegisterBloc, IllegalRegisterState>(
        listener: (context, state) {
          if (state is IllegalLoadError) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<IllegalRegisterBloc, IllegalRegisterState>(
          builder: (context, state) {
            if (state is IllegalDataLoading) {
              return const Loading();
            } else if (state is IllegalDataLoaded) {
              if (state.illegalResponse.data!.isEmpty) {
                return NoRecordFound();
              } else {
                return SafeArea(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        physics: const BouncingScrollPhysics(),
                        child: IllegalDataTableWidget(
                            illegalList: state.illegalResponse.data!)),
                  ),
                );
              }
            } else if (state is IllegalLoadError) {
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

class IllegalDataTableWidget extends StatelessWidget {
  IllegalDataTableWidget({Key? key, required this.illegalList})
      : super(key: key);
  final List<IllegalData> illegalList;

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
                    label: Text(NAME, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(ADDRESS, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(GPS, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(PHOTO, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
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
                    showDate(illegalData.createdAt),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}

class IllegalFilterDataWidget extends StatefulWidget {
  const IllegalFilterDataWidget({Key? key}) : super(key: key);

  @override
  _IllegalFilterDataWidgetState createState() =>
      _IllegalFilterDataWidgetState();
}

class _IllegalFilterDataWidgetState extends State<IllegalFilterDataWidget> {
  final _bloc = IllegalRegisterBloc();
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
        height: MediaQuery.of(context).size.height * 0.8,
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
                        BlocProvider.of<IllegalRegisterBloc>(context).add(
                            GetIllegalData(
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
