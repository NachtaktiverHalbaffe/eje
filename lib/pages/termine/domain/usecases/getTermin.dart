import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/domain/repsoitories/termin_repositoy.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../../../app_config.dart';

class GetTermin implements UseCase<Termin> {
  final TerminRepository repository;

  GetTermin(this.repository);

  @override
  Future<Either<Failure, Termin>> call({
    @required String veranstaltung,
    @required String dateTime,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.eventsBox);
    final result = await repository.getTermin(veranstaltung, dateTime);
    await _box.compact();
    await _box.close();
    return result;
  }
}
