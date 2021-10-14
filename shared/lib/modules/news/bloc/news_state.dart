part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final NewsResponse newsResponse;

  const NewsLoaded(this.newsResponse);

  @override
  List<Object> get props => [newsResponse];
}

class NewsLoadError extends NewsState {
  final String error;

  const NewsLoadError(this.error);

  @override
  List<Object> get props => [error];
}

class NewsDataSending extends NewsState {}

class NewsDataSent extends NewsState {
  final String message;

  const NewsDataSent(this.message);
}

class NewsDataSendError extends NewsState {
  final String error;

  const NewsDataSendError(this.error);
}
