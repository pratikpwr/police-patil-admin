import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:ppadmin/src/utils/styles.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class ArmsScreen extends StatefulWidget {
  const ArmsScreen({Key? key}) : super(key: key);

  @override
  State<ArmsScreen> createState() => _ArmsScreenState();
}

class _ArmsScreenState extends State<ArmsScreen> {
  final _scrollController = ScrollController();
  final _bloc = ArmsRegisterBloc();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ArmsRegisterBloc>(context).add(GetArmsData());
    return Scaffold(
      appBar: AppBar(
        title: const Text(ARMS_COLLECTIONS),
        automaticallyImplyLeading: false,
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
                          ArmsDataTableWidget(
                            armsList:
                                _bloc.typeWiseData(state.armsResponse.data),
                          ),
                        ],
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
                    "${armsData.psid ?? "-"}",
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
