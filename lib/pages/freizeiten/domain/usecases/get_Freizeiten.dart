import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/freizeiten/domain/repositories/freizeit_repository.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../../../app_config.dart';

class GetFreizeiten implements UseCase<List<Freizeit>> {
  final FreizeitRepository repository;

  GetFreizeiten({@required this.repository});

  @override
  Future<Either<Failure, List<Freizeit>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.campsBox);
    final result = await repository.getFreizeiten();
    if (_box.isOpen) {
      await _box.compact();
      // await _box.close();
    }
    return result;
  }
}
