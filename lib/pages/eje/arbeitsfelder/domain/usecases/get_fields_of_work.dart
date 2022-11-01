import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/field_of_work.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/repositories/field_of_work_repository.dart';
import 'package:hive/hive.dart';

import '../../../../../app_config.dart';

class GetFieldsOfWork implements UseCase<List<FieldOfWork>> {
  final FieldOfWorkRepository repository;

  GetFieldsOfWork({required this.repository});

  @override
  Future<Either<Failure, List<FieldOfWork>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.fieldOfWorkBox);
    final result = await repository.getFieldsOfWork();
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }
}
