part of 'kayade_bloc.dart';

abstract class KayadeState extends Equatable {
  const KayadeState();

  @override
  List<Object> get props => [];
}

class KayadeInitial extends KayadeState {}

class KayadeLoading extends KayadeState {}

class KayadeLoaded extends KayadeState {
  final KayadeResponse kayadeResponse;

  const KayadeLoaded(this.kayadeResponse);

  @override
  List<Object> get props => [kayadeResponse];
}

class KayadeLoadError extends KayadeState {
  final String error;

  const KayadeLoadError(this.error);

  @override
  List<Object> get props => [error];
}

class KayadeDataSending extends KayadeState {}

class KayadeDataSent extends KayadeState {
  final String message;

  const KayadeDataSent(this.message);
}

class KayadeDataSendError extends KayadeState {
  final String error;

  const KayadeDataSendError(this.error);
}
