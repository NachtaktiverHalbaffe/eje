import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetPreferences implements UseCase<SharedPreferences> {
  final EinstellungenRepository repository;

  GetPreferences(this.repository);

  @override
  Future<Either<Failure, SharedPreferences>> call() async {
    return await repository.getPrefrences();
  }
}