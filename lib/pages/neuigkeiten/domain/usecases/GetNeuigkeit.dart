import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GetNeuigkeit implements UseCase<List<Article>> {
  final NeuigkeitenRepository repository;

  GetNeuigkeit(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call({
    @required String titel,
  }) async {
    Box _box = await Hive.openBox('Neuigkeiten');
    Box _box2 = await Hive.openBox('Articles');
    final result = await repository.getNeuigkeit(titel);
    await _box.compact();
    await _box.close();
    await _box2.compact();
    await _box2.close();
    return result;
  }
}
