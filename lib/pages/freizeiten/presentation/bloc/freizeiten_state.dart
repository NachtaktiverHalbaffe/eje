import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FreizeitenState extends Equatable {
  const FreizeitenState();
  @override
  List<Object> get props => [];
}

class Empty extends FreizeitenState{
  @override
  List<Object> get props => [];
}

class Loading extends FreizeitenState{
  @override
  List<Object> get props => [];
}

class LoadedFreizeiten extends FreizeitenState{
  List<Freizeit> freizeiten;

  LoadedFreizeiten(this.freizeiten);

  @override
  List<Object> get props => [freizeiten];
}

class LoadedFreizeit extends FreizeitenState{
  Freizeit freizeit;

  LoadedFreizeit(this.freizeit);

  @override
  List<Object> get props => [freizeit];
}

class Error extends FreizeitenState{
  String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}