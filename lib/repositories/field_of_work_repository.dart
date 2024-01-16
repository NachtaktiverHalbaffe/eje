import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/field_of_work.dart';

abstract class FieldOfWorkRepository {
  Future<Either<Failure, FieldOfWork>> getFieldOfWork(
      String arbeitsbereich); // Einen Arbeitsbereich laden
  Future<Either<Failure, List<FieldOfWork>>>
      getFieldsOfWork(); // Alle Arbeitsbereiche laden
}
