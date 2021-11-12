import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/freizeiten/domain/repositories/camp_repository.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class GetCamp implements UseCase<Camp> {
  final CampRepository repository;

  GetCamp(this.repository);

  @override
  Future<Either<Failure, Camp>> call({
    @required int id,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.campsBox);
    final result = await repository.getCamp(id);
    if (_box.isOpen) {
      await _box.compact();
      // await _box.close();
    }
    return result;
  }
}
