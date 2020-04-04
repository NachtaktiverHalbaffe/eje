import 'package:eje/pages/einstellungen/domain/entitys/einstellung.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class EinstellungState extends Equatable {
  const EinstellungState();

  @override
  List<Object> get props => [];
}

class Empty extends EinstellungState {
  @override
  List<Object> get props => [];
}

class ChangedPreferences extends EinstellungState{
  final Einstellung einstellung;

  ChangedPreferences(this.einstellung);

  @override
  List<Object> get props => [einstellung];
}

class LoadedPreferences extends EinstellungState{
  final Einstellung einstellung;
  LoadedPreferences(this.einstellung);

  @override
  List<Object> get props => [einstellung];
}

class Error extends EinstellungState {
  final String message;

  //Constructor
  Error({@required this.message});

  @override
  List<Object> get props => [message];
}


