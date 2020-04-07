
import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';

abstract class BAKRepository{
  Future <Either<Failure,BAKler>> getBAKler(String name); // Einen BAKlerladen
  Future <Either<Failure,List<BAKler>>> getBAK(); // Alle BAKler laden
}