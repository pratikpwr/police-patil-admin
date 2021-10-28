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
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.psResponse.data!.length,
                      itemBuilder: (context, index) {
                        return PoliceStationDetailsWidget(
                            ps: state.psResponse.data![index]);
                      }),
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
  const PoliceStationDetailsWidget({Key? key, required this.ps})
      : super(key: key);
  final PoliceStationData ps;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: GREY_BACKGROUND_COLOR),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Police Station Name: ${ps.psname!}",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "Email: ${ps.email!}",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "Address: ${ps.address!}",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
