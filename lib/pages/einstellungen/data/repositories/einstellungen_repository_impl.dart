// ignore_for_file: unnecessary_statements

import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/einstellungen/domain/entitys/einstellung.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EinstellungenRepositoryImpl implements EinstellungenRepository {
  @override
  Future<Either<Failure, Einstellung>> getPrefrence(String preference) async {
    try {
      final prefs = GetStorage();
      return Right(new Einstellung(
          preference: preference, state: prefs.read(preference)));
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, GetStorage>> storePrefrences(
      String preference, bool state) async {
    final prefs = GetStorage();
    prefs.write(preference, state);
    if (preference == "nightmode_auto") {
      prefs.write("nightmode_on", false);
      prefs.write("nightmode_off", false);
      ThemeMode.system;
    } else if (preference == "nightmode_off") {
      prefs.write("nightmode_on", false);
      prefs.write("nightmode_auto", false);
      ThemeMode.light;
    } else if (preference == "nightmode_on") {
      prefs.write("nightmode_off", false);
      prefs.write("nightmode_auto", false);
      ThemeMode.dark;
    }
    return Right(prefs);
  }

  @override
  Future<Either<Failure, GetStorage>> getPrefrences() async {
    final prefs = GetStorage();
    return Right(prefs);
  }
}
