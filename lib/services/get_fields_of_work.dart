import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:eje/services/usecase.dart';
import 'package:eje/repositories/field_of_work_repository.dart';
import 'package:hive/hive.dart';

import '../../../../../app_config.dart';

class GetFieldsOfWork implements Service<List<FieldOfWork>> {
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
