import 'package:dartz/dartz.dart';
import 'package:eje/models/einstellung.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/Repository.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SharedPreferencesRepository implements Repository<Einstellung, String> {
  Future<Either<Failure, GetStorage>> storePrefrences(
      String preference, bool state) async {
    final prefs = GetStorage();
    prefs.write(preference, state);
    if (preference == "nightmode_auto") {
      if (state == true) {
        prefs.write("nightmode_on", false);
        prefs.write("nightmode_off", false);
        ThemeMode.system;
      }
    } else if (preference == "nightmode_off") {
      if (state == true) {
        prefs.write("nightmode_on", false);
        prefs.write("nightmode_auto", false);
        ThemeMode.light;
      }
    } else if (preference == "nightmode_on") {
      if (state == true) {
        prefs.write("nightmode_off", false);
        prefs.write("nightmode_auto", false);
        ThemeMode.dark;
      }
    }
    return Right(prefs);
  }

  Future<Either<Failure, GetStorage>> getPrefrences() async {
    final prefs = GetStorage();
    return Right(prefs);
  }

  @override
  Future<Either<Failure, List<Einstellung>>> getAllElements(String boxKey) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Einstellung>> getElement(
      String boxKey, String elementId) async {
    try {
      final prefs = GetStorage();
      return Right(
          Einstellung(preference: elementId, state: prefs.read(elementId)));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
