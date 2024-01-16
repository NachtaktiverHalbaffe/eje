import 'package:dartz/dartz.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/failures.dart';

abstract class BAKRepository {
  Future<Either<Failure, BAKler>> getBAKler(String name); // Einen BAKlerladen
  Future<Either<Failure, List<BAKler>>> getBAK(); // Alle BAKler laden
}
