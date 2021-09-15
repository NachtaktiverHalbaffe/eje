import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/domain/repsoitories/termin_repositoy.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class GetTermine implements UseCase<List<Termin>> {
  final TerminRepository repository;

  GetTermine({@required this.repository});

  @override
  Future<Either<Failure, List<Termin>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.eventsBox);
    final result = await repository.getTermine();
    await _box.compact();
    await _box.close();
    return result;
  }
}
