import 'package:dartz/dartz.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/employees_repository.dart';
import 'package:eje/services/usecase.dart';
import 'package:hive/hive.dart';

import '../../../../../app_config.dart';

class GetEmployee implements Service<Employee> {
  final EmployeesRepository repository;

  GetEmployee(this.repository);

  @override
  Future<Either<Failure, Employee>> call({
    String? name,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.employeesBox);
    final result = await repository.getEmployee(name!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
