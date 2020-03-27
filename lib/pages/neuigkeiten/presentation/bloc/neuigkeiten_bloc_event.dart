import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeit.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NeuigkeitenBlocEvent extends Equatable {
  NeuigkeitenBlocEvent([List props = const <dynamic>[]]) : super(props);
}

// Zeige ganzen Artikel wenn Button geklicket wird
class GetNeuigkeitDetails extends NeuigkeitenBlocEvent {
  final String titel;

  //Constructor
  GetNeuigkeitDetails(this.titel) : super([titel]);
}

// Refreshe Neuigkeiten, wenn Liste zum refresen runter gezogen wird
class RefreshNeuigkeiten extends NeuigkeitenBlocEvent {}
