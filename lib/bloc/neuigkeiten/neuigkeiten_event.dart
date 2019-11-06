import 'package:eje/database/neuigkeiten/neuigkeit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NeuigkeitenEvent extends Equatable {
  NeuigkeitenEvent([List props = const []]) : super(props);
}

class LoadNeuigkeiten extends NeuigkeitenEvent {}

class DeleteNeuigkeit extends NeuigkeitenEvent {
  final Neuigkeit neuigkeit;

  DeleteNeuigkeit(this.neuigkeit) : super([neuigkeit]);
}
