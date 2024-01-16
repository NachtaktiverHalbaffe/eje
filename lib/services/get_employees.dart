import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/employees_repository.dart';
import 'package:eje/services/usecase.dart';
import 'package:hive/hive.dart';

class GetEmployees implements Service<List<Employee>> {
  final EmployeesRepository repository;

  GetEmployees({required this.repository});

  @override
  Future<Either<Failure, List<Employee>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.employeesBox);
    final result = await repository.getEmployees();
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }
}
