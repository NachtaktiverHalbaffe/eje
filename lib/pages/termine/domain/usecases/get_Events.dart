import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';
import 'package:eje/pages/termine/domain/repsoitories/events_repository.dart';
import 'package:hive/hive.dart';

class GetEvents implements UseCase<List<Event>> {
  final EventsRepository repository;
  GetEvents({required this.repository});

  @override
  Future<Either<Failure, List<Event>>> call() async {
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
