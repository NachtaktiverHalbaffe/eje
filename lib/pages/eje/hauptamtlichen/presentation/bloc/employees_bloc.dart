// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/get_employees.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/get_employee.dart';
import 'package:flutter/foundation.dart';
import './bloc.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final GetEmployees getEmployees;
  final GetEmployee getEmployee;

  EmployeesBloc({
    @required this.getEmployees,
    @required this.getEmployee,
  }) : super(Empty());

  @override
  Stream<EmployeesState> mapEventToState(
    EmployeesEvent event,
  ) async* {
    if (event is RefreshEmployees) {
      print("Triggered Event: RefreshHauptamtliche");
      yield Loading();
      final hauptamtlicheOrFailure = await getEmployees();
      yield hauptamtlicheOrFailure.fold(
        (failure) {
          print("Error");
          return Error(message: failure.getErrorMsg());
        },
        (hauptamtliche) {
          print("Succes. Returning LoadedHauptamtliche");
          return LoadedEmployees(hauptamtliche);
        },
      );
    } else if (event is GettingEmployee) {
      yield Loading();
      final hauptamtlicheOrFailure = await getEmployee(name: event.name);
      yield hauptamtlicheOrFailure.fold(
        (failure) => Error(message: failure.getErrorMsg()),
        (hauptamtlicher) => LoadedEmployee(hauptamtlicher),
      );
    }
  }
}
