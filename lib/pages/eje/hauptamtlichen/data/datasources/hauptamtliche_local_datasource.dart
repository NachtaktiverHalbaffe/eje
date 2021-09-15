import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:hive/hive.dart';

class HauptamtlicheLocalDatasource {
  Future<List<Hauptamtlicher>> getCachedHauptamtliche() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.employeesBox);

    // load data from cache
    if (_box.isNotEmpty) {
      List<Hauptamtlicher> data = new List.empty(growable: true);
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

  Future<Hauptamtlicher> getHauptamtliche(String name) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.employeesBox);

    // load specific data entry from cache
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Hauptamtlicher temp = _box.getAt(i);
        if (temp.name == name) {
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheHauptamtliche(List<Hauptamtlicher> hauptamtlicheToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.employeesBox);

    // cache data if not already cached
    for (int i = 0; i < hauptamtlicheToCache.length; i++) {
      for (int k = 0; k < _box.length; k++) {
        final Hauptamtlicher _hauptamtlicher = _box.getAt(k);
        if (_hauptamtlicher.name == hauptamtlicheToCache[i].name) {
          _box.deleteAt(k);
        }
      }
      _box.add(hauptamtlicheToCache[i]);
    }
  }
}
