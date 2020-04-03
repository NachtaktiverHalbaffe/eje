import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/einstellungen/domain/entitys/einstellung.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';
import 'package:meta/meta.dart';

class SetPreferences implements UseCase<Einstellung> {
  final EinstellungenRepository repository;

  SetPreferences(this.repository);

  @override
  Future<Either<Failure, Einstellung>> call({
    @required String preference,
    @required bool state,
  }) async {
    return await repository.storePrefrences(preference, state);
  }
}