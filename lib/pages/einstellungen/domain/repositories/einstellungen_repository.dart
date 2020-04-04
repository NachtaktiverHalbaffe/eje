import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/einstellungen/domain/entitys/einstellung.dart';
import 'package:shared_preferences/shared_preferences.dart';
abstract class EinstellungenRepository{
  Future <Either<Failure,SharedPreferences>> getPrefrences(SharedPreferences preference);
  Future <Either<Failure,Einstellung>> getPrefrence(String preference); // Einen Artikel laden
  Future <Either<Failure,void>> storePrefrences(String preference, bool state); // Alle Artike laden
}