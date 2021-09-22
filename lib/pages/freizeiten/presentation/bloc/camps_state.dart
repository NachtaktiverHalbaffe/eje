import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CampState extends Equatable {
  const CampState();
  @override
  List<Object> get props => [];
}

class Empty extends CampState {
  @override
  List<Object> get props => [];
}

class Loading extends CampState {
  @override
  List<Object> get props => [];
}

class LoadedCamps extends CampState {
  final List<Camp> freizeiten;

  LoadedCamps(this.freizeiten);

  @override
  List<Object> get props => [freizeiten];
}

class LoadedCamp extends CampState {
  final Camp freizeit;

  LoadedCamp(this.freizeit);

  @override
  List<Object> get props => [freizeit];
}

class Error extends CampState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
