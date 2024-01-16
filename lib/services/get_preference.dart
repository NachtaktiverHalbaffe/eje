import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/usecase.dart';
import 'package:eje/models/einstellung.dart';
import 'package:eje/repositories/einstellungen_repository.dart';

class GetPreference implements Service<Einstellung> {
  final EinstellungenRepository repository;

  GetPreference(this.repository);

  @override
  Future<Either<Failure, Einstellung>> call({
    String? preference,
  }) async {
    return await repository.getPrefrence(preference!);
  }
}
