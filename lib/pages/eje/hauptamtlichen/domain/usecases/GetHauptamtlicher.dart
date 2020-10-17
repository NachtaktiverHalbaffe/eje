import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/repositories/hauptamtliche_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GetHauptamtlicher implements UseCase<Hauptamtlicher> {
  final HauptamtlicheRepository repository;

  GetHauptamtlicher(this.repository);

  @override
  Future<Either<Failure, Hauptamtlicher>> call({
    @required String name,
  }) async {
    Box _box = await Hive.openBox('Hauptamtliche');
    final result = await repository.getHauptamtlicher(name);
    await _box.compact();
    await _box.close();
    return result;
  }
}
