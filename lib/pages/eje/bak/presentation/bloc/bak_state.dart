import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class BakState extends Equatable {
  const BakState();

  @override
  List<Object> get props => [];
}

class Empty extends BakState {
  @override
  List<Object> get props => [];
}

class Loading extends BakState {
  @override
  List<Object> get props => [];
}

class LoadedBAK extends BakState {
  List<BAKler> bak;

  LoadedBAK(this.bak);

  @override
  List<Object> get props => [bak];
}

class LoadedBAKler extends BakState {
  BAKler bakler;

  LoadedBAKler(this.bakler);

  @override
  List<Object> get props => [bakler];
}

class Error extends BakState {
  String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
