import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
  String name;

  GettingHauptamtlicher(@required this.name);

  @override
  List<Object> get props => [name];
}
