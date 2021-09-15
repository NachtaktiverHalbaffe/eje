import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_termine.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:hive/hive.dart';

class TermineLocalDatasource {
  Future<List<Termin>> getCachedTermine() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.eventsBox);
    testdata_termine(_box);

    // load data from cache
    if (_box.isNotEmpty) {
      List<Termin> data = new List.empty(growable: true);
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

  Future<Termin> getTermin(String veranstaltung, String dateTime) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.eventsBox);

    // load specific data entry from cache
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Termin event = _box.getAt(i);
        if (event.veranstaltung == veranstaltung && event.datum == dateTime) {
          return event;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheTermine(List<Termin> termineToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.eventsBox);

    // cache data if not already cached
    for (int i = 0; i < termineToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final Termin _termin = _box.getAt(k);
        if (_termin == termineToCache[i]) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(termineToCache[i]);
      }
    }
  }
}
