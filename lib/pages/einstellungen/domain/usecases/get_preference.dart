import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/einstellungen/domain/entitys/einstellung.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';

class GetPreference implements UseCase<Einstellung> {
  final EinstellungenRepository repository;

  GetPreference(this.repository);

  @override
  Future<Either<Failure, Einstellung>> call({
    String? preference,
  }) async {
    return await repository.getPrefrence(preference!);
  }
}
