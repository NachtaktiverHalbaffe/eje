import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';

abstract class ArbeitsbereichRepository {
  Future<Either<Failure, FieldOfWork>> getArbeitsbereich(
      String arbeitsbereich); // Einen Arbeitsbereich laden
  Future<Either<Failure, List<FieldOfWork>>>
      getArbeitsbereiche(); // Alle Arbeitsbereiche laden
}
