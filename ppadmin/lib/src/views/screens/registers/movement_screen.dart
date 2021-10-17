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
  final _bloc = MovementRegisterBloc();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MovementRegisterBloc>(context).add(GetMovementData());
    return Scaffold(
      appBar: CustomAppBar(
        title: MOVEMENT_REGISTER,
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
                            MovementDataTableWidget(
                                movementList: _bloc.typeWiseData(
                                    state.movementResponse.movementData!)),
                          ],
                        )),
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
                    label: Text(DATE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(IS_ISSUE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label:
                        Text(ATTENDANCE, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(MOVEMENT_DESCRIPTION,
                        style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PPID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text("PSID", style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(REGISTER_DATE,
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
                    movementData.address!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    movementData.datetime!.toIso8601String(),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    movementData.issue! == 1 ? YES : NO,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    movementData.attendance!.toString(),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(SizedBox(
                    width: 350,
                    child: Text(
                      movementData.description!,
                      maxLines: 3,
                      style: Styles.tableValuesTextStyle(),
                    ),
                  )),
                  DataCell(Text(
                    "${movementData.ppid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${movementData.psid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    movementData.createdAt!.toIso8601String().substring(0, 10),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}
