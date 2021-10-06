// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/usecases/get_field_of_work.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/usecases/get_fields_of_work.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class FieldsOfWorkBloc extends Bloc<FieldsOfWorkEvent, FieldOfWorkState> {
  final GetFieldsOfWork getFieldsOfWork;
  final GetFieldOfWork getFieldOfWork;

  FieldsOfWorkBloc({
    @required this.getFieldOfWork,
    @required this.getFieldsOfWork,
  }) : super(Empty());

  @override
  Stream<FieldOfWorkState> mapEventToState(
    FieldsOfWorkEvent event,
  ) async* {
    if (event is RefreshFieldsOfWork) {
      print("Triggered Event: RefreshArbeitsbereiche");
      yield Loading();
      final fieldsOfWorkOrFailure = await getFieldsOfWork();
      yield fieldsOfWorkOrFailure.fold(
        (failure) {
          print("Error");
          return Error(message: failure.getErrorMsg());
        },
        (arbeitsbereiche) {
          print("Succes. Returning LoadedArbeitsbereiche");
          return LoadedFieldsOfWork(arbeitsbereiche);
        },
      );
    } else if (event is GettingFieldOfWork) {
      yield Loading();
      final fieldOfWorkOrFailure = await getFieldOfWork(name: event.name);
      yield fieldOfWorkOrFailure.fold(
        (failure) => Error(message: failure.getErrorMsg()),
        (arbeitsfeld) => LoadedFieldOfWork(arbeitsfeld),
      );
    }
  }
}
