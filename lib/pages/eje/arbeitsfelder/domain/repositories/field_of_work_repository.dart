import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/field_of_work.dart';

abstract class FieldOfWorkRepository {
  Future<Either<Failure, FieldOfWork>> getFieldOfWork(
      String arbeitsbereich); // Einen Arbeitsbereich laden
  Future<Either<Failure, List<FieldOfWork>>>
      getFieldsOfWork(); // Alle Arbeitsbereiche laden
}
