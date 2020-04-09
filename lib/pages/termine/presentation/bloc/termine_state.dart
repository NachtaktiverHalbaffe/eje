import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TermineState extends Equatable {
  const TermineState();
  @override
  List<Object> get props => [];
}

class Empty extends TermineState{
  @override
  List<Object> get props => [];
}

class Loading extends TermineState{
  @override
  List<Object> get props => [];
}

class LoadedTermine extends TermineState{
  List<Termin> termine;

  LoadedTermine(this.termine);

  @override
  List<Object> get props => [termine];
}

class LoadedTermin extends TermineState{
  Termin termin;

  LoadedTermin(this.termin);

  @override
  List<Object> get props => [termin];
}

class Error extends TermineState{
  String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}