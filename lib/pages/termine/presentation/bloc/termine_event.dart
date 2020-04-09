import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
  String veranstaltung;
  String dateTime;

  GettingTermin(@required this.veranstaltung, @required this.dateTime);

  @override
  List<Object> get props => [veranstaltung,dateTime];
}