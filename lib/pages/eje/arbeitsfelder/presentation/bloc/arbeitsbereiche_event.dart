import 'package:equatable/equatable.dart';

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
  final String arbeitsfeld;

  GettingArbeitsbereich(this.arbeitsfeld);

  @override
  List<Object> get props => [arbeitsfeld];
}
