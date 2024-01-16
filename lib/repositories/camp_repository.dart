import 'package:dartz/dartz.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/models/failures.dart';

abstract class CampRepository {
  Future<Either<Failure, Camp>> getCamp(int id); // Eine Freizeit laden
  Future<Either<Failure, List<Camp>>> getCamps(); // Alle Freizeiten laden
}
