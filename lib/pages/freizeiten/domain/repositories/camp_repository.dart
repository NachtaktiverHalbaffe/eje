import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';

abstract class CampRepository {
  Future<Either<Failure, Camp>> getCamp(int id); // Eine Freizeit laden
  Future<Either<Failure, List<Camp>>> getCamps(); // Alle Freizeiten laden
}
