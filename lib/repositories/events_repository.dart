import 'package:dartz/dartz.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/models/failures.dart';

abstract class EventsRepository {
  Future<Either<Failure, Event>> getEvent(int id); // Einen Termin laden
  Future<Either<Failure, List<Event>>> getEvents(); // Alle Termine laden
}
