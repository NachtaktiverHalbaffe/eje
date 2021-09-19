import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

class SetPreferences implements UseCase<GetStorage> {
  final EinstellungenRepository repository;

  SetPreferences(this.repository);

  @override
  Future<Either<Failure, GetStorage>> call({
    @required String preference,
    @required bool state,
  }) async {
    return await repository.storePrefrences(preference, state);
  }
}
