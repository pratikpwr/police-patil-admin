import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/news/models/news_model.dart';
import 'package:shared/modules/news/resources/news_repository.dart';
import 'package:dio/dio.dart';

part 'news_event.dart';

part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial());

  final _newsRepository = NewsRepository();

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is GetNews) {
      yield NewsLoading();
      try {
        Response _response = await _newsRepository.getNews();
        if (_response.data["error"] == null) {
          final _news = NewsResponse.fromJson(_response.data);
          yield NewsLoaded(_news);
        } else {
          yield NewsLoadError(_response.data["error"].toString());
        }
      } catch (err) {
        yield NewsLoadError(err.toString());
      }
    }
    if (event is AddNews) {
      try {
        Response _response =
            await _newsRepository.addNewsData(newsData: event.newsData);

        if (_response.data["message"] != null) {
          yield NewsDataSent(_response.data["message"]);
        } else {
          yield NewsDataSendError(_response.data["error"]);
        }
      } catch (err) {
        yield NewsDataSendError(err.toString());
      }
    }
  }
}
