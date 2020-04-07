import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/repositories/arbeitsbereich_repository.dart';
import 'package:meta/meta.dart';

class GetArbeitsbereich implements UseCase<Arbeitsbereich> {
  final ArbeitsbereichRepository repository;

  GetArbeitsbereich(this.repository);

  @override
  Future<Either<Failure, Arbeitsbereich>> call({
    @required String arbeitsbereich,
  }) async {
    return await repository.getArbeitsbereich(arbeitsbereich);
  }
}
