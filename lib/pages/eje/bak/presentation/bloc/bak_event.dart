import 'package:equatable/equatable.dart';

abstract class BakEvent extends Equatable {
  const BakEvent();

  @override
  List<Object> get props => [];
}

class RefreshBAK extends BakEvent {
  @override
  List<Object> get props => [];
}

class GettingBAKler extends BakEvent {
  final String name;

  GettingBAKler(this.name);

  @override
  List<Object> get props => [name];
}
