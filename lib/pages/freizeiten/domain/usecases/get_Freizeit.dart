import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/freizeiten/domain/repositories/freizeit_repository.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class GetFreizeit implements UseCase<Freizeit> {
  final FreizeitRepository repository;

  GetFreizeit(this.repository);

  @override
  Future<Either<Failure, Freizeit>> call({
    @required Freizeit freizeit,
  }) async {
    Box _box = await Hive.openBox('Freizeiten');
    final result = await repository.getFreizeit(freizeit);
    await _box.compact();
    await _box.close();
    return result;
  }
}
