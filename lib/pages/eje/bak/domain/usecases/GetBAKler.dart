
import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/bak/domain/repositories/bak_repository.dart';
import 'package:meta/meta.dart';

class GetBAKler implements UseCase<BAKler> {
  final BAKRepository repository;

  GetBAKler(this.repository);

  @override
  Future<Either<Failure, BAKler>> call({
    @required String name,
  }) async {
    return await repository.getBAKler(name);
  }
}
