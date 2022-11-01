import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/repositories/employees_repository.dart';
import 'package:hive/hive.dart';

class GetEmployees implements UseCase<List<Employee>> {
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
