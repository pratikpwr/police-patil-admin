part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetNews extends NewsEvent {}

class AddNews extends NewsEvent {
  final NewsData newsData;

  const AddNews(this.newsData);

  @override
  List<Object> get props => [newsData];
}
