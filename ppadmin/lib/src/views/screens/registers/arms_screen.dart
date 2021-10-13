import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class ArmsScreen extends StatelessWidget {
  const ArmsScreen({Key? key}) : super(key: key);

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
              return loading();
            } else if (state is ArmsDataLoaded) {
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const BouncingScrollPhysics(),
                  child: ArmsDataTableWidget(
                    armsList: state.armsResponse.data,
                  ),
                ),
              );
            } else if (state is ArmsLoadError) {
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

class ArmsDataTableWidget extends StatelessWidget {
  ArmsDataTableWidget({Key? key, required this.armsList}) : super(key: key);
  final List<ArmsData> armsList;

  final List<String> _columns = [
    TYPE,
    NAME,
    MOB_NO,
    ADDRESS,
    "परवाना क्रमांक",
    "परवान्याची वैधता कालावधी",
    "PPID",
    "PSID",
    REGISTER_DATE,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: [
              DataColumn(
                  label: Text(
                TYPE,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )),
              DataColumn(
                  label: Text(
                NAME,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )),
              DataColumn(
                  label: Text(
                MOB_NO,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )),
              DataColumn(
                  label: Text(
                ADDRESS,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )),
              DataColumn(
                  label: Text(
                "परवाना क्रमांक",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )),
              DataColumn(
                  label: Text(
                "परवान्याची वैधता कालावधी",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )),
              DataColumn(
                  label: Text(
                "PPID",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )),
              DataColumn(
                  label: Text(
                "PSID",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )),
              DataColumn(
                  label: Text(
                REGISTER_DATE,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )),
            ],
            rows: List<DataRow>.generate(armsList.length, (index) {
              final armsData = armsList[index];
              return DataRow(cells: <DataCell>[
                DataCell(Text(
                  armsData.type!,
                  style: GoogleFonts.poppins(fontSize: 14),
                )),
                DataCell(Text(
                  armsData.name!,
                  style: GoogleFonts.poppins(fontSize: 14),
                )),
                DataCell(Text(
                  armsData.mobile!.toString(),
                  style: GoogleFonts.poppins(fontSize: 14),
                )),
                DataCell(Text(
                  armsData.address!,
                  style: GoogleFonts.poppins(fontSize: 14),
                )),
                DataCell(Text(
                  armsData.licenceNumber!,
                  style: GoogleFonts.poppins(fontSize: 14),
                )),
                DataCell(Text(
                  armsData.validity!.toIso8601String().substring(0, 10),
                  style: GoogleFonts.poppins(fontSize: 14),
                )),
                DataCell(Text(
                  "${armsData.ppid!}",
                  style: GoogleFonts.poppins(fontSize: 14),
                )),
                DataCell(Text(
                  "${armsData.psid!}",
                  style: GoogleFonts.poppins(fontSize: 14),
                )),
                DataCell(Text(
                  armsData.createdAt!.toIso8601String().substring(0, 10),
                  style: GoogleFonts.poppins(fontSize: 14),
                )),
              ]);
            })));
  }
}
