import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';

abstract class EmployeesRepository {
  Future<Either<Failure, Employee>> getEmployee(
      String name); // Einen Hauptamtlucben laden
  Future<Either<Failure, List<Employee>>>
      getEmployees(); // Alle Hauptamtlichen laden
}
