import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_termine.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';
import 'package:hive/hive.dart';

class EventLocalDatasource {
  Future<List<Event>> getCachedEvents() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.eventsBox);
    testdataTermine(_box);

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
      throw CacheException();
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

  void cacheEvents(List<Event> eventsToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.eventsBox);

    // cache data if not already cached
    for (int i = 0; i < eventsToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final Event _termin = _box.getAt(k);
        if (_termin == eventsToCache[i]) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(eventsToCache[i]);
      }
    }
  }
}
