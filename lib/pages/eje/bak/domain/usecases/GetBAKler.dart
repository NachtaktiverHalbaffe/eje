import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/bak/domain/repositories/bak_repository.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class GetBAKler implements UseCase<BAKler> {
  final BAKRepository repository;

  GetBAKler(this.repository);

  @override
  Future<Either<Failure, BAKler>> call({
    @required String name,
  }) async {
    Box _box = await Hive.openBox('BAK');
    final result = await repository.getBAKler(name);
    await _box.compact();
    await _box.close();
    return result;
  }
}
