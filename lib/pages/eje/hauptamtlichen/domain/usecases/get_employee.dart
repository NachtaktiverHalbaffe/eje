import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/repositories/employees_repository.dart';
import 'package:hive/hive.dart';

import '../../../../../app_config.dart';

class GetEmployee implements UseCase<Employee> {
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
