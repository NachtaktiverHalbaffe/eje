import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/einstellungen/domain/entitys/einstellung.dart';
abstract class EinstellungenRepository{
  Future <Either<Failure,Einstellung>> getPrefrences(String preference); // Einen Artikel laden
  Future <Either<Failure,void>> storePrefrences(String preference, bool state); // Alle Artike laden
}