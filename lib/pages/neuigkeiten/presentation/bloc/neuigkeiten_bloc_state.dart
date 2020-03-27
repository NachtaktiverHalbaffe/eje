import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NeuigkeitenBlocState extends Equatable {
  NeuigkeitenBlocState([List props = const <dynamic>[]]) : super(props);
}

//State wenn keine Neuigkeit vorhanden ist
class Empty extends NeuigkeitenBlocState {}

//State wenn Neuigkeiten geladen werden
class Loading extends NeuigkeitenBlocState {}

// State wenn Neuigkeien fertig geladen sind
class Loaded extends NeuigkeitenBlocState {
  final List<Neuigkeit> neuigkeit;

  //Constructor
  Loaded({@required this.neuigkeit}):super([neuigkeit]);
}

class LoadedDetail extends NeuigkeitenBlocState {
  final Neuigkeit neuigkeit;

  //Constructor
  LoadedDetail({@required this.neuigkeit}):super([neuigkeit]);
}

class Error extends NeuigkeitenBlocState {
  final String message;

  //Constructor
  Error({@required this.message}):super([message]);
}
