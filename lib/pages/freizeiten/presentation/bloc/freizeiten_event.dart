import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:equatable/equatable.dart';

abstract class FreizeitenEvent extends Equatable {
  const FreizeitenEvent();
  @override
  List<Object> get props => [];
}

class RefreshFreizeiten extends FreizeitenEvent {
  @override
  List<Object> get props => [];
}

class GettingFreizeit extends FreizeitenEvent {
  final Freizeit freizeit;

  GettingFreizeit(this.freizeit);

  @override
  List<Object> get props => [freizeit];
}
