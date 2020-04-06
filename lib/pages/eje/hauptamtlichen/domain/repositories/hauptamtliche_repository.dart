import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';

abstract class HauptamtlicheRepository{
  Future <Either<Failure,Hauptamtlicher>> getHauptamtlicher(String name); // Einen Hauptamtlucben laden
  Future <Either<Failure,List <Hauptamtlicher>>> getHauptamtliche(); // Alle Hauptamtlichen laden
}