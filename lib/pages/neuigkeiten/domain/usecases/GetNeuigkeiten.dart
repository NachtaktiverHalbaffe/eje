import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class GetNeuigkeiten implements UseCase<List<Neuigkeit>> {
  final NeuigkeitenRepository repository;

  GetNeuigkeiten(this.repository);

  @override
  Future<Either<Failure, List<Neuigkeit>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.newsBox);
    final result = await repository.getNeuigkeiten();
    await _box.compact();
    await _box.close();
    return result;
  }
}
