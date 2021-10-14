import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/custom_methods.dart';
import 'package:ppadmin/src/views/views.dart';
import 'package:shared/shared.dart';

class ImpNewsScreen extends StatelessWidget {
  ImpNewsScreen({Key? key}) : super(key: key);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NewsBloc>(context).add(GetNews());
    return Scaffold(
      appBar: CustomAppBar(title: IMP_NEWS),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return Loading();
          } else if (state is NewsLoaded) {
            if (state.newsResponse.data!.isEmpty) {
              return NoRecordFound();
            } else {
              return SafeArea(
                  child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.newsResponse.data!.length,
                    itemBuilder: (context, index) {
                      return NewsDetailsWidget(
                          newsData: state.newsResponse.data![index]);
                    }),
              ));
            }
          } else if (state is NewsLoadError) {
            return SomethingWentWrong();
          } else {
            return SomethingWentWrong();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, size: 24),
      ),
    );
  }
}

class NewsDetailsWidget extends StatelessWidget {
  final NewsData newsData;

  const NewsDetailsWidget({Key? key, required this.newsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (newsData.link != null) {
          launchUrl(newsData.link!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: GREY_BACKGROUND_COLOR),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Todo see doc button
            Text(
              newsData.title!,
              maxLines: 3,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Divider(),
            Text(
              newsData.date!.toIso8601String().substring(0, 10),
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// var ups = [
//   "जप्ती मालाचा प्रकार बेवारस वाहने दागिने गौण खनिज इतर, जप्ती मालाचा प्रकार बेवारस वाहने दागिने गौण खनिज इतर.",
//   "हे हस्तलिखित प्रिंटिंग होणार हातासो ते लिहावे असे आवाहन  करतो व ते आपल्या फोटोसह माझ्या नावाने किंवा शाळेच्या नावाने पोस्टाने किंवा कुरिअर ने पाठवाव्यात",
//   "अवैद्य दारू विक्री करणारे गुटका जुगार मटका चालविणारे इतर जुगार खेळणारे गौण खनिज उत्खनन करणारे वाळू तस्कर",
// ];
