
import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';

abstract class TerminRepository{
  Future <Either<Failure,Termin>> getTermin(String name, String dateTime); // Einen Termin laden
  Future <Either<Failure,List<Termin>>> getTermine(); // Alle Termine laden
}