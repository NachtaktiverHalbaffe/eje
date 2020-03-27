import 'package:equatable/equatable.dart';

abstract class NeuigkeitenBlocState extends Equatable {
  const NeuigkeitenBlocState();
}

class InitialNeuigkeitenBlocState extends NeuigkeitenBlocState {
  @override
  List<Object> get props => [];
}
