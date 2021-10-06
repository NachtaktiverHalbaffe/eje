import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/termine/domain/entities/event.dart';
import 'package:eje/pages/termine/domain/repsoitories/events_repository.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class GetEvents implements UseCase<List<Event>> {
  final EventsRepository repository;
  GetEvents({@required this.repository});

  @override
  Future<Either<Failure, List<Event>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.eventsBox);
    final result = await repository.getEvents();
    if (_box.isOpen) {
      await _box.compact();
      await _box.close();
    }
    return result;
  }
}
