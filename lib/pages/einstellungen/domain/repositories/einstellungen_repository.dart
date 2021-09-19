import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/einstellungen/domain/entitys/einstellung.dart';
import 'package:get_storage/get_storage.dart';

abstract class EinstellungenRepository {
  Future<Either<Failure, GetStorage>> getPrefrences();
  Future<Either<Failure, Einstellung>> getPrefrence(
      String preference); // Einen Artikel laden
  Future<Either<Failure, void>> storePrefrences(
      String preference, bool state); // Alle Artike laden
}
