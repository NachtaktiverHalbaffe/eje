import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/einstellungen/domain/entitys/einstellung.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EinstellungenRepositoryImpl implements EinstellungenRepository {
  @override
  Future<Either<Failure, Einstellung>> getPrefrence(String preference) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return Right(new Einstellung(
          preference: preference, state: prefs.getBool(preference)));
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> storePrefrences(
      String preference, bool state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(preference, state);
    if (preference == "nightmode_auto") {
      ThemeMode.system;
    } else if (preference == "nightmode_off") {
      ThemeMode.light;
    } else if (preference == "nightmode_on") {
      ThemeMode.dark;
    }
  }

  @override
  Future<Either<Failure, SharedPreferences>> getPrefrences(SharedPreferences preference) async{
    final prefs = await SharedPreferences.getInstance();
    return Right(prefs);
  }
}
