import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:ppadmin/src/views/views.dart';
import 'package:shared/shared.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class KayadeScreen extends StatefulWidget {
  const KayadeScreen({Key? key}) : super(key: key);

  @override
  State<KayadeScreen> createState() => _KayadeScreenState();
}

class _KayadeScreenState extends State<KayadeScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<KayadeBloc>(context).add(GetKayade());
    return Scaffold(
        appBar:
            AppBar(title: const Text(LAWS), automaticallyImplyLeading: false),
        body: BlocListener<KayadeBloc, KayadeState>(listener: (context, state) {
          if (state is KayadeLoadError) {
            showSnackBar(context, state.error);
          }
        }, child: BlocBuilder<KayadeBloc, KayadeState>(
          builder: (context, state) {
            if (state is KayadeLoading) {
              return const Loading();
            } else if (state is KayadeLoaded) {
              if (state.kayadeResponse.data!.isEmpty) {
                return NoRecordFound();
              } else {
                return SafeArea(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      physics: const BouncingScrollPhysics(),
                      child: ListView.builder(
                          itemCount: state.kayadeResponse.data!.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            KayadeData kayadeData =
                                state.kayadeResponse.data![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 32),
                                      primary: GREY_BACKGROUND_COLOR,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Text(
                                    kayadeData.title!,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () async {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return PDFViewScreen(
                                          kayadeData: kayadeData);
                                    }));
                                  }),
                            );
                          })),
                );
              }
            } else if (state is KayadeLoadError) {
              if (state.error == 'Record Empty') {
                return NoRecordFound();
              } else {
                return SomethingWentWrong();
              }
            } else {
              return SomethingWentWrong();
            }
          },
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addNewKayade().then((_) {
              BlocProvider.of<KayadeBloc>(context).add(GetKayade());
            });
          },
          child: const Icon(Icons.add, size: 24),
        ));
  }

  Future<void> _addNewKayade() async {
    final _titleController = TextEditingController();
    String _fileName = "फाईल जोडा";
    File? _file;
    return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: BlocListener<KayadeBloc, KayadeState>(
              listener: (context, state) {
                if (state is KayadeDataSendError) {
                  showSnackBar(context, state.error);
                }
                if (state is KayadeDataSent) {
                  showSnackBar(context, state.message);
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  children: [
                    spacer(),
                    buildTextField(_titleController, "कायद्याचे नाव"),
                    spacer(),
                    AttachButton(
                        text: _fileName,
                        onTap: () async {
                          _file = await getFileFromGallery();
                          _fileName = getFileName(_file!.path);
                        }),
                    spacer(),
                    CustomButton(
                        text: "कायदा जोडा",
                        onTap: () {
                          final _kayadeData = KayadeData(
                              title: _titleController.text, file: _file?.path);

                          BlocProvider.of<KayadeBloc>(context)
                              .add(AddKayade(_kayadeData));
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class PDFViewScreen extends StatelessWidget {
  const PDFViewScreen({Key? key, required this.kayadeData}) : super(key: key);
  final KayadeData kayadeData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        width: MediaQuery.of(context).size.width * 0.40,
        child: Column(
          children: [
            Text(
              kayadeData.title!,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            SfPdfViewer.network("http://${kayadeData.file!}"),
          ],
        ));
  }
}
