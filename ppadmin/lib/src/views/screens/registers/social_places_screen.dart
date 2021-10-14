import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class SocialPlaceScreen extends StatelessWidget {
   SocialPlaceScreen({Key? key}) : super(key: key);
  final _scrollController  =ScrollController();
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PublicPlaceRegisterBloc>(context).add(GetPublicPlaceData());
    return Scaffold(
      appBar: CustomAppBar(
        title: SOCIAL_PLACES,
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
              return Loading();
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
                        child: PlaceDataTableWidget(
                            placeList: state.placeResponse.data!)),
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
                    placeData.address!,
                    style: Styles.tableValuesTextStyle(),
                  )),
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
                    placeData.createdAt!.toIso8601String().substring(0, 10),
                    style: Styles.tableValuesTextStyle(),
                  )),
                ]);
              }))),
    );
  }
}
