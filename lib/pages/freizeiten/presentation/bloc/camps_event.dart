import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:equatable/equatable.dart';

abstract class CampEvent extends Equatable {
  const CampEvent();
  @override
  List<Object> get props => [];
}

class RefreshCamps extends CampEvent {
  @override
  List<Object> get props => [];
}

class GettingCamp extends CampEvent {
  final Camp camp;

  GettingCamp(this.camp);

  @override
  List<Object> get props => [camp];
}

class FilteringCamps extends CampEvent {
  @override
  List<Object> get props => [];
}
