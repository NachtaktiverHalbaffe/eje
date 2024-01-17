import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/CachedRemoteRepository.dart';
import 'package:hive/hive.dart';

class BakService {
  final CachedRemoteRepository<BAKler, String> repository;

  BakService({required this.repository});

  Future<Either<Failure, List<BAKler>>> getBAK() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.bakBox);
    final result = await repository.getAllElement(appConfig.bakBox);
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }

  Future<Either<Failure, BAKler>> getBAKler({String? name}) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.bakBox);
    final result = await repository.getElement(appConfig.bakBox, name!, "name");
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
