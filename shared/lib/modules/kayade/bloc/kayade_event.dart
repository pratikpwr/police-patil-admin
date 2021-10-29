part of 'kayade_bloc.dart';

abstract class KayadeEvent extends Equatable {
  const KayadeEvent();

  @override
  List<Object> get props => [];
}

class GetKayade extends KayadeEvent {}

class AddKayade extends KayadeEvent {
  final Map<String, dynamic> kayadeData;

  const AddKayade(this.kayadeData);

  @override
  List<Object> get props => [kayadeData];
}
