import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class SocialPlaceScreen extends StatefulWidget {
  const SocialPlaceScreen({Key? key}) : super(key: key);

  @override
  State<SocialPlaceScreen> createState() => _SocialPlaceScreenState();
}

class _SocialPlaceScreenState extends State<SocialPlaceScreen> {
  final _scrollController = ScrollController();

  // final _bloc = PublicPlaceRegisterBloc();

  @override
  void initState() {
    BlocProvider.of<PublicPlaceRegisterBloc>(context).add(GetPublicPlaceData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SOCIAL_PLACES),
        automaticallyImplyLeading: false,
        actions: [
          FilterButton(onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return const PublicPlaceFilterDataWidget();
                });
          })
        ],
      ),
      body: BlocListener<PublicPlaceRegisterBloc, PublicPlaceRegisterState>(
        listener: (context, state) {
          if (state is PublicPlaceLoadError) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<PublicPlaceRegisterBloc, PublicPlaceRegisterState>(
          builder: (context, state) {
            if (state is PublicPlaceDataLoading) {
              return const Loading();
            } else if (state is PublicPlaceDataLoaded) {
              if (state.placeResponse.data!.isEmpty) {
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
                            PlaceDataTableWidget(
                                placeList: state.placeResponse.data!),
                          ],
                        )),
                  ),
                );
              }
            } else if (state is PublicPlaceLoadError) {
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

class PlaceDataTableWidget extends StatelessWidget {
  PlaceDataTableWidget({Key? key, required this.placeList}) : super(key: key);
  final List<PlaceData> placeList;

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
                    label: Text("महत्त्वाचे स्थळ",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(PLACE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(GPS, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(PHOTO, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("सीसीटीव्ही बसवला आहे का ?",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("काही वाद आहेत का ?",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("वादाचे कारण",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("वादाची सद्यस्थिती",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("गुन्हा दाखल आहे का ?",
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(REGISTER_DATE,
                        style: Styles.tableTitleTextStyle())),
              ],
              rows: List<DataRow>.generate(placeList.length, (index) {
                final placeData = placeList[index];
                return DataRow(cells: <DataCell>[
                  DataCell(Text(
                    placeData.place!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    placeData.address ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(ViewLocWidget(
                      id: "social${placeData.id!}",
                      lat: placeData.latitude!,
                      long: placeData.longitude!)),
                  placeData.photo != null
                      ? DataCell(ViewFileWidget(url: placeData.photo!))
                      : noDataInCell(),
                  DataCell(Text(
                    placeData.isCCTV! ? YES : NO,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    placeData.isIssue! ? YES : NO,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    placeData.issueReason ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    placeData.issueCondition ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    placeData.isCrimeRegistered! ? YES : NO,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${placeData.ppid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${placeData.psid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    showDate(placeData.createdAt),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}

class PublicPlaceFilterDataWidget extends StatefulWidget {
  const PublicPlaceFilterDataWidget({Key? key}) : super(key: key);

  @override
  _PublicPlaceFilterDataWidgetState createState() =>
      _PublicPlaceFilterDataWidgetState();
}

class _PublicPlaceFilterDataWidgetState
    extends State<PublicPlaceFilterDataWidget> {
  final _bloc = PublicPlaceRegisterBloc();
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
                      items: _bloc.placeTypes,
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
                        BlocProvider.of<PublicPlaceRegisterBloc>(context).add(
                            GetPublicPlaceData(
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
