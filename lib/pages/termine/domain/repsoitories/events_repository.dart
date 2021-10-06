import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/termine/domain/entities/event.dart';

abstract class EventsRepository {
  Future<Either<Failure, Event>> getEvent(int id); // Einen Termin laden
  Future<Either<Failure, List<Event>>> getEvents(); // Alle Termine laden
}
