import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object> get props => [];
}

class Empty extends EmployeesState {
  @override
  List<Object> get props => [];
}

class Loading extends EmployeesState {
  @override
  List<Object> get props => [];
}

class LoadedEmployees extends EmployeesState {
  final List<Employee> hauptamtliche;

  LoadedEmployees(this.hauptamtliche);

  @override
  List<Object> get props => [hauptamtliche];
}

class LoadedEmployee extends EmployeesState {
  final Employee employee;

  LoadedEmployee(this.employee);

  @override
  List<Object> get props => [employee];
}

class Error extends EmployeesState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
