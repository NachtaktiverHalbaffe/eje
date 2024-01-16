import 'package:dartz/dartz.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/failures.dart';

abstract class EmployeesRepository {
  Future<Either<Failure, Employee>> getEmployee(
      String name); // Einen Hauptamtlucben laden
  Future<Either<Failure, List<Employee>>>
      getEmployees(); // Alle Hauptamtlichen laden
}
