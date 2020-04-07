import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ArbeitsbereicheEvent extends Equatable {
  const ArbeitsbereicheEvent();
  @override
  List<Object> get props => [];
}

class RefreshArbeitsbereiche extends ArbeitsbereicheEvent {
  @override
  List<Object> get props => [];
}

class GettingArbeitsbereich extends ArbeitsbereicheEvent {
  String arbeitsfeld;

  GettingArbeitsbereich(@required this.arbeitsfeld);

  @override
  List<Object> get props => [arbeitsfeld];
}