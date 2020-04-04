import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final SharedPreferences preference;

  GettingPreferences(this.preference);

  @override
  List<Object> get props => [preference];
}