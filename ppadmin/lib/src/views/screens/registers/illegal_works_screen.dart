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
  final _bloc = IllegalRegisterBloc();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<IllegalRegisterBloc>(context).add(GetIllegalData());
    return Scaffold(
      appBar: AppBar(
          title: const Text(ILLEGAL_WORKS), automaticallyImplyLeading: false),
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
                            IllegalDataTableWidget(
                                illegalList: _bloc
                                    .typeWiseData(state.illegalResponse.data!)),
                          ],
                        )),
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
                    illegalData.name!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    illegalData.address!,
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
                    illegalData.createdAt!.toIso8601String().substring(0, 10),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}
