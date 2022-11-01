import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/freizeiten/domain/repositories/camp_repository.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class GetCamps implements UseCase<List<Camp>> {
  final CampRepository repository;

  GetCamps({required this.repository});

  @override
  Future<Either<Failure, List<Camp>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.campsBox);
    final result = await repository.getCamps();
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
