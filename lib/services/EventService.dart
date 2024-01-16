import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/events_repository.dart';
import 'package:hive/hive.dart';

class EventService {
  final EventsRepository repository;

  EventService({required this.repository});

  Future<Either<Failure, Event>> getEvent({int? id}) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.eventsBox);
    final result = await repository.getEvent(id!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }

  Future<Either<Failure, List<Event>>> getEvents() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.eventsBox);
    final result = await repository.getEvents();
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }
}
