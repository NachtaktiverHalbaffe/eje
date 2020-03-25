import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:equatable/equatable.dart';

abstract class NeuigkeitenState extends Equatable {
  NeuigkeitenState([List props = const []]) : super(props);
}

class NeuigkeitenLoading extends NeuigkeitenState {}

class NeuigkeitenLoaded extends NeuigkeitenState {
  final List<Neuigkeit> neuigkeiten;

  NeuigkeitenLoaded(this.neuigkeiten) : super([neuigkeiten]);
}
