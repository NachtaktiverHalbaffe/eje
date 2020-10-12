import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/Article.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';
import 'package:flutter/material.dart';

class GetNeuigkeit implements UseCase<List<Article>> {
  final NeuigkeitenRepository repository;

  GetNeuigkeit(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call({
    @required String titel,
  }) async {
    return await repository.getNeuigkeit(titel);
  }
}
