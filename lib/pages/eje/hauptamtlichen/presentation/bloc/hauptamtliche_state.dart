import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class HauptamtlicheState extends Equatable {
  const HauptamtlicheState();

  @override
  List<Object> get props => [];
}

class Empty extends HauptamtlicheState {
  @override
  List<Object> get props => [];
}

class Loading extends HauptamtlicheState {
  @override
  List<Object> get props => [];
}

class LoadedHauptamtliche extends HauptamtlicheState {
  final List<Hauptamtlicher> hauptamtliche;

  LoadedHauptamtliche(this.hauptamtliche);

  @override
  List<Object> get props => [hauptamtliche];
}

class LoadedHauptamtlicher extends HauptamtlicheState {
  final Hauptamtlicher hauptamtlicher;

  LoadedHauptamtlicher(this.hauptamtlicher);

  @override
  List<Object> get props => [hauptamtlicher];
}

class Error extends HauptamtlicheState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
