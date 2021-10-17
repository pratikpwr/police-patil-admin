import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:ppadmin/src/utils/styles.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class ArmsScreen extends StatelessWidget {
  ArmsScreen({Key? key}) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ArmsRegisterBloc>(context).add(GetArmsData());
    return Scaffold(
      appBar: CustomAppBar(
        title: ARMS_COLLECTIONS,
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
              if (state.armsResponse.data.isEmpty) {
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
                      child: ArmsDataTableWidget(
                        armsList: state.armsResponse.data,
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
                  customTextDataCell(armsData.type),
                  customTextDataCell(armsData.name),
                  armsData.aadhar != null
                      ? DataCell(ViewFileWidget(url: armsData.aadhar!))
                      : noDataInCell(),
                  customTextDataCell(armsData.mobile),
                  customTextDataCell(armsData.address),
                  DataCell(ViewLocWidget(
                      id: "arms${armsData.id!}",
                      lat: armsData.latitude!,
                      long: armsData.longitude!)),
                  customTextDataCell(armsData.licenceNumber),
                  customTextDataCell(
                      armsData.validity!.toIso8601String().substring(0, 10)),
                  armsData.licencephoto != null
                      ? DataCell(ViewFileWidget(url: armsData.licencephoto!))
                      : noDataInCell(),
                  customTextDataCell(armsData.ppid),
                  customTextDataCell(armsData.psid),
                  customTextDataCell(
                      armsData.createdAt!.toIso8601String().substring(0, 10)),
                ]);
              }))),
    );
  }
}
