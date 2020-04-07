import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ArbeitsbereicheState extends Equatable {
  const ArbeitsbereicheState();
  @override
  List<Object> get props => [];
}

class Empty extends ArbeitsbereicheState {
  @override
  List<Object> get props => [];
}

class Loading extends ArbeitsbereicheState {
  @override
  List<Object> get props => [];
}

class LoadedArbeitsbereiche extends ArbeitsbereicheState {
  List<Arbeitsbereich> arbeitsbereiche;

  LoadedArbeitsbereiche(this.arbeitsbereiche);

  @override
  List<Object> get props => [arbeitsbereiche];
}

class LoadedArbeitsbereich extends ArbeitsbereicheState{
  Arbeitsbereich arbeitsbereich;

  LoadedArbeitsbereich(this.arbeitsbereich);

  @override
  List<Object> get props => [arbeitsbereich];
}

class Error extends ArbeitsbereicheState {
  String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}