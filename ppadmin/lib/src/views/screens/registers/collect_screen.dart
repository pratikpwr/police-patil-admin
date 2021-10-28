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
  final _bloc = CollectRegisterBloc();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CollectRegisterBloc>(context).add(GetCollectionData());
    return Scaffold(
      appBar: AppBar(
          title: const Text(COLLECTION_REGISTER),
          automaticallyImplyLeading: false),
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
                            CollectDataTableWidget(
                              collectList: _bloc.typeWiseData(
                                  state.collectionResponse.collectData!),
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
                    label:
                        Text(OTHER_INFO, style: Styles.tableTitleTextStyle())),
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
              rows: List<DataRow>.generate(collectList.length, (index) {
                final collectData = collectList[index];
                return DataRow(cells: <DataCell>[
                  DataCell(Text(
                    collectData.type!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    collectData.address!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(ViewLocWidget(
                      id: "collect${collectData.id!}",
                      lat: collectData.latitude!,
                      long: collectData.longitude!)),
                  collectData.photo != null
                      ? DataCell(ViewFileWidget(url: collectData.photo!))
                      : noDataInCell(),
                  DataCell(SizedBox(
                    width: 400,
                    child: Text(
                      collectData.description!,
                      maxLines: 3,
                      style: Styles.tableValuesTextStyle(),
                    ),
                  )),
                  DataCell(Text(
                    collectData.date!.toIso8601String().substring(0, 10),
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
                    collectData.createdAt!.toIso8601String().substring(0, 10),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}
