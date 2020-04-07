import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
  String name;

  GettingBAKler(@required this.name);

  @override
  List<Object> get props => [name];
}