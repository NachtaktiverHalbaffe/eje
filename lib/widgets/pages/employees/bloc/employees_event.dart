import 'package:equatable/equatable.dart';

abstract class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object> get props => [];
}

class RefreshEmployees extends EmployeesEvent {
  @override
  List<Object> get props => [];
}

class GettingEmployee extends EmployeesEvent {
  final String name;

  GettingEmployee(this.name);

  @override
  List<Object> get props => [name];
}
