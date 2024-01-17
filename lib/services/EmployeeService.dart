import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/CachedRemoteRepository.dart';
import 'package:hive/hive.dart';

class EmployeeService {
  final CachedRemoteRepository<Employee, String> repository;

  EmployeeService({required this.repository});

  Future<Either<Failure, Employee>> getEmployee({String? name}) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.employeesBox);
    final result =
        await repository.getElement(appConfig.employeesBox, name!, "name");
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }

  Future<Either<Failure, List<Employee>>> getEmployees() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.employeesBox);
    final result = await repository.getAllElement(appConfig.employeesBox);
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }
}
