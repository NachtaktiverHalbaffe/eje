import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/freizeiten/domain/repositories/freizeit_repository.dart';
import 'package:meta/meta.dart';

class GetFreizeit implements UseCase<Freizeit> {
  final FreizeitRepository repository;

  GetFreizeit(this.repository);

  @override
  Future<Either<Failure, Freizeit>> call({
    @required Freizeit freizeit,
  }) async {
    return await repository.getFreizeit(freizeit);
  }
}