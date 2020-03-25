import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';
import 'package:flutter/foundation.dart';

class GetNeuigkeit implements UseCase<Neuigkeit> {
  final NeuigkeitenRespository repository;

  GetNeuigkeit(this.repository);

  @override
  Future<Either<Failure, Neuigkeit>> call({
    @required String titel,
  }) async {
    return await repository.getNeuigkeit(titel);
  }
}