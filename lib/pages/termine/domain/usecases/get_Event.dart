// ignore_for_file: file_names
import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';
import 'package:eje/pages/termine/domain/repsoitories/events_repository.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class GetEvent implements UseCase<Event> {
  final EventsRepository repository;

  GetEvent(this.repository);

  @override
  Future<Either<Failure, Event>> call({
    int? id,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.eventsBox);
    final result = await repository.getEvent(id!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
