import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/camp_repository.dart';
import 'package:hive/hive.dart';

class CampService {
  final CampRepository repository;

  CampService({required this.repository});

  Future<Either<Failure, Camp>> getCamp({int? id}) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.campsBox);
    final result = await repository.getCamp(id!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }

  Future<Either<Failure, List<Camp>>> getCamps() async {
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
