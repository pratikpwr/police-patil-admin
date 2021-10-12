import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:shared/shared.dart';

import '../../views.dart';

class IllegalScreen extends StatelessWidget {
  const IllegalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<IllegalRegisterBloc>(context).add(GetIllegalData());
    return Scaffold(
      appBar: CustomAppBar(
        title: ILLEGAL_WORKS,
      ),
      body: BlocListener<IllegalRegisterBloc, IllegalRegisterState>(
        listener: (context, state) {
          if (state is IllegalLoadError) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<IllegalRegisterBloc, IllegalRegisterState>(
          builder: (context, state) {
            if (state is IllegalDataLoading) {
              return loading();
            } else if (state is IllegalDataLoaded) {
              return SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    physics: const BouncingScrollPhysics(),
                    child: ListView.builder(
                        itemCount: state.illegalResponse.data!.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return IllegalDetailWidget(
                            illegalData: state.illegalResponse.data![index],
                          );
                        })),
              );
            } else if (state is IllegalLoadError) {
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (_) {
      //       return const IllegalWorksFormScreen();
      //     })).then((value) {
      //       BlocProvider.of<IllegalRegisterBloc>(context).add(GetIllegalData());
      //     });
      //   },
      //   child: const Icon(Icons.add, size: 24),
      // ),
    );
  }
}

class IllegalDetailWidget extends StatelessWidget {
  const IllegalDetailWidget({Key? key, required this.illegalData})
      : super(key: key);
  final IllegalData illegalData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: GREY_BACKGROUND_COLOR),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              illegalData.type!,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500),
            ),
            const Divider(),
            Text(
              illegalData.name!,
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            Text(
              illegalData.address!,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
