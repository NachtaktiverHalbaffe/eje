import 'package:equatable/equatable.dart';

abstract class TermineEvent extends Equatable {
  const TermineEvent();

  @override
  List<Object> get props => [];
}

class RefreshTermine extends TermineEvent {
  @override
  List<Object> get props => [];
}

class GettingTermin extends TermineEvent {
  final String veranstaltung;
  final String dateTime;

  GettingTermin(this.veranstaltung, this.dateTime);

  @override
  List<Object> get props => [veranstaltung, dateTime];
}
