// ignore_for_file: file_names
import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/usecase.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/repositories/events_repository.dart';
import 'package:hive/hive.dart';

class GetEvents implements Service<List<Event>> {
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
