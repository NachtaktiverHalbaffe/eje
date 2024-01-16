import 'package:eje/app_config.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/models/exception.dart';
import 'package:hive/hive.dart';

class EventLocalDatasource {
  Future<List<Event>> getCachedEvents() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.eventsBox);

    // load data from cache
    if (box.isNotEmpty) {
      List<Event> data = List.empty(growable: true);
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i) != null) {
          data.add(box.getAt(i));
        }
      }
      return data;
    } else {
      return [];
    }
  }

  Future<Event> getEvent(int id) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.eventsBox);

    // load specific data entry from cache
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        Event event = box.getAt(i);
        if (event.id == id) {
          return event;
        }
      }
      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheEvents(List<Event> eventsToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.eventsBox);

    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(eventsToCache);
  }
}
