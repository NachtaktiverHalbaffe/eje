import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/einstellungen/domain/entitys/einstellung.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';
import 'package:meta/meta.dart';

class GetPreferences implements UseCase<Einstellung> {
  final EinstellungenRepository repository;

  GetPreferences(this.repository);

  @override
  Future<Either<Failure, Einstellung>> call({
    @required String preference,
  }) async {
    return await repository.getPrefrences(preference);
  }
}