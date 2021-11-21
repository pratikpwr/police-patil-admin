import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';
import '../../views.dart';

class ArmsScreen extends StatefulWidget {
  const ArmsScreen({Key? key}) : super(key: key);

  @override
  State<ArmsScreen> createState() => _ArmsScreenState();
}

class _ArmsScreenState extends State<ArmsScreen> {
  final _scrollController = ScrollController();

  // final _bloc = ArmsRegisterBloc();

  @override
  void initState() {
    BlocProvider.of<ArmsRegisterBloc>(context).add(GetArmsData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ARMS_COLLECTIONS),
        automaticallyImplyLeading: false,
        actions: [
          FilterButton(onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return const ArmsFilterDataWidget();
                });
          })
        ],
      ),
      body: BlocListener<ArmsRegisterBloc, ArmsRegisterState>(
        listener: (context, state) {
          if (state is ArmsLoadError) {
            debugPrint(state.message);
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<ArmsRegisterBloc, ArmsRegisterState>(
          builder: (context, state) {
            if (state is ArmsDataLoading) {
              return const Loading();
            } else if (state is ArmsDataLoaded) {
              if (state.armsResponse.data!.isEmpty) {
                return NoRecordFound();
              } else {
                return SafeArea(
                  child: Scrollbar(
                    controller: _scrollController,
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      physics: const BouncingScrollPhysics(),
                      child:
                          ArmsDataTableWidget(armsList: state.armsResponse.data!
                              // _bloc.typeWiseData(state.armsResponse.data!),
                              ),
                    ),
                  ),
                );
              }
            } else if (state is ArmsLoadError) {
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

class ArmsDataTableWidget extends StatelessWidget {
  ArmsDataTableWidget({Key? key, required this.armsList}) : super(key: key);
  final List<ArmsData> armsList;

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
                    label:
                        Text(AADHAR_CARD, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(MOB_NO, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(ADDRESS, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("GPS", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("परवाना क्रमांक",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("परवान्याची वैधता कालावधी",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("परवान्याचा फोटो",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(REGISTER_DATE,
                        style: Styles.tableTitleTextStyle())),
              ],
              rows: List<DataRow>.generate(armsList.length, (index) {
                final armsData = armsList[index];
                return DataRow(cells: <DataCell>[
                  DataCell(Text(
                    armsData.type ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    armsData.name ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  armsData.aadhar != null
                      ? DataCell(ViewFileWidget(url: armsData.aadhar!))
                      : noDataInCell(),
                  DataCell(Text(
                    "${armsData.mobile ?? "-"}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    armsData.address ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(ViewLocWidget(
                      id: "arms${armsData.id!}",
                      lat: armsData.latitude!,
                      long: armsData.longitude!)),
                  DataCell(Text(
                    armsData.licenceNumber ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    showDate(armsData.validity),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  armsData.licencephoto != null
                      ? DataCell(ViewFileWidget(url: armsData.licencephoto!))
                      : noDataInCell(),
                  DataCell(Text(
                    "${armsData.ppid ?? "-"}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${armsData.psid ?? "-"}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    showDate(armsData.createdAt),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}

class ArmsFilterDataWidget extends StatefulWidget {
  const ArmsFilterDataWidget({Key? key}) : super(key: key);

  @override
  _ArmsFilterDataWidgetState createState() => _ArmsFilterDataWidgetState();
}

class _ArmsFilterDataWidgetState extends State<ArmsFilterDataWidget> {
  final _bloc = ArmsRegisterBloc();
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
                        BlocProvider.of<ArmsRegisterBloc>(context).add(
                            GetArmsData(
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

/*TextDropdownFormField(
                  //   controller: _dropController,
                  //   options: getVillageListInString(state.villages),
                  //   decoration: const InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       suffixIcon: Icon(
                  //         Icons.arrow_drop_down,
                  //         color: PRIMARY_COLOR,
                  //       ),
                  //       labelText: 'Village'),
                  //   dropdownHeight: 200,
                  //   onChanged: (value) {
                  //     _bloc.ppId = getPpIDFromVillage(
                  //         state.villages, _dropController.toString());
                  //     print(_dropController.toString());
                  //   },
                  // ), */
