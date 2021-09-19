import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/repositories/hauptamtliche_repository.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class GetHauptamtliche implements UseCase<List<Hauptamtlicher>> {
  final HauptamtlicheRepository repository;

  GetHauptamtliche({@required this.repository});

  @override
  Future<Either<Failure, List<Hauptamtlicher>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.employeesBox);
    final result = await repository.getHauptamtliche();
    if (_box.isOpen) {
      await _box.compact();
      await _box.close();
    }
    return result;
  }
}
