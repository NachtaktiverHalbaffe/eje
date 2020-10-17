import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';
import 'package:hive/hive.dart';

class GetNeuigkeiten implements UseCase<List<Neuigkeit>> {
  final NeuigkeitenRepository repository;

  GetNeuigkeiten(this.repository);

  @override
  Future<Either<Failure, List<Neuigkeit>>> call() async {
    Box _box = await Hive.openBox('Neuigkeiten');
    final result = await repository.getNeuigkeiten();
    await _box.compact();
    await _box.close();
    return result;
  }
}
