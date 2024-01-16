import 'package:eje/models/field_of_work.dart';
import 'package:equatable/equatable.dart';

abstract class FieldOfWorkState extends Equatable {
  const FieldOfWorkState();
  @override
  List<Object> get props => [];
}

class Empty extends FieldOfWorkState {
  @override
  List<Object> get props => [];
}

class Loading extends FieldOfWorkState {
  @override
  List<Object> get props => [];
}

class LoadedFieldsOfWork extends FieldOfWorkState {
  final List<FieldOfWork> fieldsOfWork;

  LoadedFieldsOfWork(this.fieldsOfWork);

  @override
  List<Object> get props => [fieldsOfWork];
}

class LoadedFieldOfWork extends FieldOfWorkState {
  final FieldOfWork fieldOfWork;

  LoadedFieldOfWork(this.fieldOfWork);

  @override
  List<Object> get props => [fieldOfWork];
}

class Error extends FieldOfWorkState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
