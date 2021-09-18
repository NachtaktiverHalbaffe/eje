import 'package:equatable/equatable.dart';

abstract class HauptamtlicheEvent extends Equatable {
  const HauptamtlicheEvent();

  @override
  List<Object> get props => [];
}

class RefreshHauptamtliche extends HauptamtlicheEvent {
  @override
  List<Object> get props => [];
}

class GettingHauptamtlicher extends HauptamtlicheEvent {
  final String name;

  GettingHauptamtlicher(this.name);

  @override
  List<Object> get props => [name];
}
