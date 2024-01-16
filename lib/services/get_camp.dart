import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/usecase.dart';
import 'package:eje/repositories/camp_repository.dart';
import 'package:hive/hive.dart';

class GetCamp implements Service<Camp> {
  final CampRepository repository;

  GetCamp(this.repository);

  @override
  Future<Either<Failure, Camp>> call({
    int? id,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.campsBox);
    final result = await repository.getCamp(id!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
