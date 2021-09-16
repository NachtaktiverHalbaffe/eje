import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/repositories/arbeitsbereich_repository.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class GetArbeitsbereich implements UseCase<FieldOfWork> {
  final ArbeitsbereichRepository repository;

  GetArbeitsbereich(this.repository);

  @override
  Future<Either<Failure, FieldOfWork>> call({
    @required String arbeitsbereich,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.fieldOfWorkBox);
    final result = await repository.getArbeitsbereich(arbeitsbereich);
    await _box.compact();
    await _box.close();
    return result;
  }
}
