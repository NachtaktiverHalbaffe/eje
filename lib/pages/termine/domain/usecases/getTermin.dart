
import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/domain/repsoitories/termin_repositoy.dart';
import 'package:meta/meta.dart';

class GetTermin implements UseCase<Termin> {
  final TerminRepository repository;

  GetTermin(this.repository);

  @override
  Future<Either<Failure, Termin>> call({
    @required String veranstaltung,
    @required String dateTime,
  }) async {
    return await repository.getTermin(veranstaltung,dateTime);
  }
}
