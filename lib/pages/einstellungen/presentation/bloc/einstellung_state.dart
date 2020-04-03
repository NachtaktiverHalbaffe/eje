import 'package:equatable/equatable.dart';

abstract class EinstellungState extends Equatable {
  const EinstellungState();
}

class InitialEinstellungState extends EinstellungState {
  @override
  List<Object> get props => [];
}
