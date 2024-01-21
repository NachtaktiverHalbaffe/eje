import 'package:equatable/equatable.dart';

abstract class FieldsOfWorkEvent extends Equatable {
  const FieldsOfWorkEvent();
  @override
  List<Object> get props => [];
}

class RefreshFieldsOfWork extends FieldsOfWorkEvent {
  @override
  List<Object> get props => [];
}

class GettingFieldOfWork extends FieldsOfWorkEvent {
  final String name;

  GettingFieldOfWork(this.name);

  @override
  List<Object> get props => [name];
}

class GetCachedEvents extends FieldsOfWorkEvent {}
