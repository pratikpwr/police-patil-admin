import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final _scrollController = ScrollController();

  // final _bloc = CollectRegisterBloc();

  @override
  void initState() {
    BlocProvider.of<CollectRegisterBloc>(context).add(GetCollectionData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(COLLECTION_REGISTER),
        automaticallyImplyLeading: false,
        actions: [
          FilterButton(onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return const CollectFilterDataWidget();
                });
          })
        ],
      ),
      body: BlocListener<CollectRegisterBloc, CollectRegisterState>(
        listener: (context, state) {
          if (state is CollectionLoadError) {
            debugPrint(state.message);
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<CollectRegisterBloc, CollectRegisterState>(
          builder: (context, state) {
            if (state is CollectionDataLoading) {
              return const Loading();
            } else if (state is CollectionDataLoaded) {
              if (state.collectionResponse.collectData!.isEmpty) {
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
                            CollectDataTableWidget(
                              collectList:
                                  state.collectionResponse.collectData!,
                            ),
                          ],
                        )),
                  ),
                );
              }
            } else if (state is CollectionLoadError) {
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

class CollectDataTableWidget extends StatelessWidget {
  CollectDataTableWidget({Key? key, required this.collectList})
      : super(key: key);
  final List<CollectionData> collectList;

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
                    label: Text(PLACE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(GPS, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(PHOTO, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(DATE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(REGISTER_DATE,
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label:
                        Text(OTHER_INFO, style: Styles.tableTitleTextStyle())),
              ],
              rows: List<DataRow>.generate(collectList.length, (index) {
                final collectData = collectList[index];
                return DataRow(cells: <DataCell>[
                  DataCell(Text(
                    collectData.type!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    collectData.address ?? "-",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(ViewLocWidget(
                      id: "collect${collectData.id!}",
                      lat: collectData.latitude!,
                      long: collectData.longitude!)),
                  collectData.photo != null
                      ? DataCell(ViewFileWidget(url: collectData.photo!))
                      : noDataInCell(),
                  DataCell(Text(
                    showDate(collectData.date),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${collectData.ppid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${collectData.psid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    showDate(collectData.createdAt),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(SizedBox(
                    width: 400,
                    child: Text(
                      collectData.description ?? "-",
                      maxLines: 3,
                      style: Styles.tableValuesTextStyle(),
                    ),
                  )),
                ]);
              }))),
    );
  }
}

class CollectFilterDataWidget extends StatefulWidget {
  const CollectFilterDataWidget({Key? key}) : super(key: key);

  @override
  _CollectFilterDataWidgetState createState() =>
      _CollectFilterDataWidgetState();
}

class _CollectFilterDataWidgetState extends State<CollectFilterDataWidget> {
  final _bloc = CollectRegisterBloc();
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
                        BlocProvider.of<CollectRegisterBloc>(context).add(
                            GetCollectionData(
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
