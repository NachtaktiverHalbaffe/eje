import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:eje/services/usecase.dart';
import 'package:eje/repositories/field_of_work_repository.dart';
import 'package:hive/hive.dart';

class GetFieldOfWork implements Service<FieldOfWork> {
  final FieldOfWorkRepository repository;

  GetFieldOfWork(this.repository);

  @override
  Future<Either<Failure, FieldOfWork>> call({
    String? name,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.fieldOfWorkBox);
    final result = await repository.getFieldOfWork(name!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
