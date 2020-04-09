import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';

abstract class FreizeitRepository{
  Future <Either<Failure,Freizeit>> getFreizeit(Freizeit freizeit); // Eine Freizeit laden
  Future <Either<Failure,List<Freizeit>>> getFreizeiten(); // Alle Freizeiten laden
}