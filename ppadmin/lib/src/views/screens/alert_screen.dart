import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ppadmin/src/views/views.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:shared/shared.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({Key? key}) : super(key: key);

// TODO : will need pagination here
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AlertBloc>(context).add(GetAlerts());
    return Scaffold(
      appBar: CustomAppBar(title: NOTICE),
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
        onPressed: () {},
        child: const Icon(Icons.add, size: 24),
      ),
    );
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
