import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:eje/repositories/field_of_work_repository.dart';
import 'package:hive/hive.dart';

class FieldsOfWorkService {
  final FieldOfWorkRepository repository;

  FieldsOfWorkService({required this.repository});

  Future<Either<Failure, FieldOfWork>> getFieldOfWork({String? name}) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.fieldOfWorkBox);
    final result = await repository.getFieldOfWork(name!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }

  Future<Either<Failure, List<FieldOfWork>>> getFieldsOfWork() async {
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
