import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:ppadmin/src/views/views.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:shared/shared.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AlertBloc>(context).add(GetAlerts());
    return Scaffold(
      appBar:
          AppBar(title: const Text(ALERTS), automaticallyImplyLeading: false),
      body: BlocListener<AlertBloc, AlertState>(listener: (context, state) {
        if (state is AlertLoadError) {
          showSnackBar(context, state.error);
        }
      }, child: BlocBuilder<AlertBloc, AlertState>(
        builder: (context, state) {
          if (state is AlertLoading) {
            return const Loading();
          } else if (state is AlertLoaded) {
            if (state.alertResponse.data!.isEmpty) {
              return NoRecordFound();
            } else {
              return SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    physics: const BouncingScrollPhysics(),
                    child: ListView.builder(
                        itemCount: state.alertResponse.data!.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AlertDetailsWidget(
                            alertData: state.alertResponse.data![index],
                          );
                        })),
              );
            }
          } else if (state is AlertLoadError) {
            return SomethingWentWrong();
          } else {
            return SomethingWentWrong();
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewAlert().then((_) {
            BlocProvider.of<AlertBloc>(context).add(GetAlerts());
          });
        },
        child: const Icon(Icons.add, size: 24),
      ),
    );
  }

  Future<void> _addNewAlert() async {
    final _titleController = TextEditingController();
    final _otherController = TextEditingController();
    final _videoController = TextEditingController();
    final _dateController = TextEditingController();
    String _fileName = "फाईल जोडा";
    File? _file;
    String _photoName = "फोटो जोडा";
    File? _photo;

    return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: BlocListener<AlertBloc, AlertState>(
              listener: (context, state) {
                if (state is AlertDataSendError) {
                  showSnackBar(context, state.error);
                }
                if (state is AlertDataSent) {
                  showSnackBar(context, state.message);
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  children: [
                    spacer(),
                    buildTextField(_titleController, TITLE),
                    spacer(),
                    AttachButton(
                        text: _fileName,
                        onTap: () async {
                          _file = await getFileFromGallery();
                          _fileName = getFileName(_file!.path);
                        }),
                    spacer(),
                    AttachButton(
                        text: _photoName,
                        onTap: () async {
                          _photo = await getFileFromGallery();
                          _photoName = getFileName(_file!.path);
                        }),
                    spacer(),
                    buildTextField(_videoController, "video link"),
                    spacer(),
                    buildTextField(_otherController, "other link"),
                    spacer(),
                    buildDateTextField(
                      context,
                      _dateController,
                      DATE,
                    ),
                    spacer(),
                    CustomButton(
                        text: REGISTER,
                        onTap: () {
                          DateFormat _format = DateFormat("yyyy-MM-dd");
                          final _alertData = AlertData(
                              title: _titleController.text,
                              otherLink: _otherController.text,
                              videoLink: _videoController.text,
                              date: _format.parse(_dateController.text),
                              photo: _photo?.path,
                              file: _file?.path);

                          BlocProvider.of<AlertBloc>(context)
                              .add(AddAlert(_alertData));
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class AlertDetailsWidget extends StatelessWidget {
  final AlertData alertData;

  const AlertDetailsWidget({Key? key, required this.alertData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        if (alertData.otherLink != null) {
          launchUrl(alertData.otherLink!);
        }
      },
      child: Container(
        width: _size.width * 0.35,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: GREY_BACKGROUND_COLOR),
        child: Column(
          children: [
            // Todo see doc button
            // if video then don't show photo
            if (alertData.photo != null && !(alertData.videoLink != null))
              CachedNetworkImage(
                imageUrl: "http://${alertData.photo!}",
                width: _size.width * 0.35 - 32,
                fit: BoxFit.cover,
              ),
            if (alertData.videoLink != null)
              SizedBox(
                  width: _size.width * 0.35 - 32,
                  child: VideoPlayerWidget(videoUrl: alertData.videoLink!)),
            spacer(),
            Text(
              alertData.title!,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Divider(),
            Text(
              alertData.date!.toIso8601String().substring(0, 10),
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? videoId = youtubeUrlToId(videoUrl);
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId!,
      params: YoutubePlayerParams(
        playlist: [videoId],
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    return YoutubePlayerIFrame(
      controller: controller,
      aspectRatio: 16 / 9,
    );
  }
}
