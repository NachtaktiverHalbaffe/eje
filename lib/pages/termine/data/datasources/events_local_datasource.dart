import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';
import 'package:hive/hive.dart';

class EventLocalDatasource {
  Future<List<Event>> getCachedEvents() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.eventsBox);

    // load data from cache
    if (_box.isNotEmpty) {
      List<Event> data = new List.empty(growable: true);
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          data.add(_box.getAt(i));
        }
      }
      return data;
    } else {
      return [];
    }
  }

  Future<Event> getEvent(int id) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.eventsBox);

    // load specific data entry from cache
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Event event = _box.getAt(i);
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
    final Box _box = Hive.box(appConfig.eventsBox);

    if (_box.isNotEmpty) {
      await _box.clear();
    }
    await _box.addAll(eventsToCache);
  }
}
