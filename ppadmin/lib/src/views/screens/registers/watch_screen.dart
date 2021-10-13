import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class WatchScreen extends StatelessWidget {
  WatchScreen({Key? key}) : super(key: key);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WatchRegisterBloc>(context).add(GetWatchData());
    return Scaffold(
      appBar: CustomAppBar(
        title: WATCH_REGISTER,
      ),
      body: BlocListener<WatchRegisterBloc, WatchRegisterState>(
        listener: (context, state) {
          if (state is WatchLoadError) {
            showSnackBar(context, state.message.substring(0, 200));
          }
        },
        child: BlocBuilder<WatchRegisterBloc, WatchRegisterState>(
          builder: (context, state) {
            if (state is WatchDataLoading) {
              return loading();
            } else if (state is WatchDataLoaded) {
              return SafeArea(
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      physics: const BouncingScrollPhysics(),
                      child: WatchDataTableWidget(
                          watchList: state.watchResponse.data!)),
                ),
              );
            } else if (state is WatchLoadError) {
              if (state.message == 'Record Empty') {
                return noRecordFound();
              } else {
                return somethingWentWrong();
              }
            } else {
              return somethingWentWrong();
            }
          },
        ),
      ),
    );
  }
}

class WatchDataTableWidget extends StatelessWidget {
  WatchDataTableWidget({Key? key, required this.watchList}) : super(key: key);
  final List<WatchData> watchList;

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
                    label: Text(MOB_NO, style: Styles.tableTitleTextStyle())),
                DataColumn(
                    label: Text(ADDRESS, style: Styles.tableTitleTextStyle())),
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
              rows: List<DataRow>.generate(watchList.length, (index) {
                final watchData = watchList[index];
                return DataRow(cells: <DataCell>[
                  DataCell(Text(
                    watchData.type!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    watchData.name!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    watchData.mobile!.toString(),
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    watchData.address!,
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(SizedBox(
                    width: 400,
                    child: Text(
                      watchData.description!,
                      maxLines: 3,
                      style: Styles.tableValuesTextStyle(),
                    ),
                  )),
                  DataCell(Text(
                    "${watchData.ppid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    "${watchData.psid!}",
                    style: Styles.tableValuesTextStyle(),
                  )),
                  DataCell(Text(
                    watchData.createdAt!.toIso8601String().substring(0, 10),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}
