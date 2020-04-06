import 'package:equatable/equatable.dart';

abstract class EinstellungEvent extends Equatable {
  const EinstellungEvent();

  @override
  List<Object> get props => [];
}

class StoringPreferences extends EinstellungEvent{
  final String preference;
  final bool state;

  StoringPreferences(this.preference, this.state);

  @override
  List<Object> get props => [preference, state];
}

class GettingPreferences extends EinstellungEvent{

  @override
  List<Object> get props => [];
}

class GettingPreference extends EinstellungEvent{
  final String preference;
  GettingPreference(this.preference);

  @override
  List<Object> get props => [preference];
}