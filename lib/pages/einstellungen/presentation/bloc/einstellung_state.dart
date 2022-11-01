import 'package:eje/pages/einstellungen/domain/entitys/einstellung.dart';
import 'package:equatable/equatable.dart';

abstract class EinstellungState extends Equatable {
  const EinstellungState();

  @override
  List<Object> get props => [];
}

class Empty extends EinstellungState {
  @override
  List<Object> get props => [];
}

class LoadedPreference extends EinstellungState {
  final Einstellung einstellung;

  LoadedPreference(this.einstellung);

  @override
  List<Object> get props => [einstellung];
}

class ChangedPreferences extends EinstellungState {
  @override
  List<Object> get props => [];
}

class LoadedPreferences extends EinstellungState {
  @override
  List<Object> get props => [];
}

class Error extends EinstellungState {
  final String message;
  //Constructor
  Error({required this.message});

  @override
  List<Object> get props => [message];
}
