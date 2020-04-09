import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
  Freizeit freizeit;

  GettingFreizeit(@required this.freizeit);

  @override
  List<Object> get props => [freizeit];
}