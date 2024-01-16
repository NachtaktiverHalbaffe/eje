import 'package:dartz/dartz.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/usecase.dart';
import 'package:eje/repositories/camp_repository.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class GetCamps implements Service<List<Camp>> {
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
