import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:ppadmin/src/views/views.dart';
import 'package:shared/shared.dart';

class PoliceStationScreen extends StatefulWidget {
  const PoliceStationScreen({Key? key}) : super(key: key);

  @override
  State<PoliceStationScreen> createState() => _PoliceStationScreenState();
}

class _PoliceStationScreenState extends State<PoliceStationScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PoliceStationBloc>(context).add(GetPoliceStation());
    return Scaffold(
      appBar: AppBar(
          title: const Text("POLICE STATIONS"),
          automaticallyImplyLeading: false),
      body: BlocListener<PoliceStationBloc, PoliceStationState>(
        listener: (context, state) {
          if (state is PoliceStationLoadError) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<PoliceStationBloc, PoliceStationState>(
          builder: (context, state) {
            if (state is PoliceStationDataLoading) {
              return const Loading();
            } else if (state is PoliceStationDataLoaded) {
              if (state.psResponse.data!.isEmpty) {
                return NoRecordFound();
              } else {
                return SafeArea(
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const BouncingScrollPhysics(),
                  child: PoliceStationDetailsWidget(ps: state.psResponse.data!),
                ));
              }
            } else if (state is PoliceStationLoadError) {
              return SomethingWentWrong();
            } else {
              return SomethingWentWrong();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewPoliceStation().then((_) {
            BlocProvider.of<PoliceStationBloc>(context).add(GetPoliceStation());
          });
        },
        child: const Icon(Icons.add, size: 24),
      ),
    );
  }

  Future<void> _addNewPoliceStation() async {
    final _nameController = TextEditingController();
    final _passwordController = TextEditingController();
    final _emailController = TextEditingController();

    return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: BlocListener<PoliceStationBloc, PoliceStationState>(
              listener: (context, state) {
                if (state is PoliceStationDataSendError) {
                  showSnackBar(context, state.error);
                  Navigator.pop(context);
                }
                if (state is PoliceStationDataSent) {
                  showSnackBar(context, state.message);
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  children: [
                    spacer(),
                    buildTextField(_nameController, NAME),
                    spacer(),
                    buildTextField(_emailController, "Email"),
                    spacer(),
                    buildTextField(_passwordController, ADDRESS),
                    spacer(),
                    CustomButton(
                        text: REGISTER,
                        onTap: () {
                          final psData = PoliceStationData(
                              psname: _nameController.text,
                              address: _passwordController.text,
                              email: _emailController.text,
                              latitude: 0.00,
                              longitude: 0.00);
                          BlocProvider.of<PoliceStationBloc>(context)
                              .add(AddPoliceStation(psData: psData));
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class PoliceStationDetailsWidget extends StatelessWidget {
  PoliceStationDetailsWidget({Key? key, required this.ps}) : super(key: key);
  final List<UserClass> ps;
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
            DataColumn(label: Text("ID", style: Styles.tableTitleTextStyle())),
            DataColumn(label: Text(NAME, style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text("Email", style: Styles.tableTitleTextStyle())),
            DataColumn(
                label: Text("Role", style: Styles.tableTitleTextStyle())),
          ],
          rows: List<DataRow>.generate(ps.length, (index) {
            final user = ps[index];
            return DataRow(cells: <DataCell>[
              customTextDataCell("${user.id ?? 0}"),
              customTextDataCell(user.name ?? "-"),
              customTextDataCell(user.email ?? "-"),
              customTextDataCell(user.role ?? "-"),
            ]);
          }),
        ),
      ),
    );
  }
}
