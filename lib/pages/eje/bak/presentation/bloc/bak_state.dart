import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:equatable/equatable.dart';

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
  final List<BAKler> bak;

  LoadedBAK(this.bak);

  @override
  List<Object> get props => [bak];
}

class LoadedBAKler extends BakState {
  final BAKler bakler;

  LoadedBAKler(this.bakler);

  @override
  List<Object> get props => [bakler];
}

class Error extends BakState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
