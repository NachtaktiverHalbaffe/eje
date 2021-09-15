import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';

import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:hive/hive.dart';

class ArbeitsbereicheLocalDatasource {
  Future<List<Arbeitsbereich>> getCachedArbeitsbereiche() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.fieldOfWorkBox);

    //Load all field of works from cache
    if (_box.isNotEmpty) {
      List<Arbeitsbereich> data = new List.empty(growable: true);
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

  Future<Arbeitsbereich> getArbeitsbereich(String arbeitsfeld) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.fieldOfWorkBox);

    // Load specific field of work
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Arbeitsbereich temp = _box.getAt(i);
        if (temp.arbeitsfeld == arbeitsfeld) {
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheBAK(List<Arbeitsbereich> arbeitsbereicheToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.fieldOfWorkBox);

    // cache field of work if not already cached
    for (int i = 0; i < arbeitsbereicheToCache.length; i++) {
      for (int k = 0; k < _box.length; k++) {
        final Arbeitsbereich _arbeitsbereich = _box.getAt(k);
        if (_arbeitsbereich.arbeitsfeld ==
            arbeitsbereicheToCache[i].arbeitsfeld) {
          _box.deleteAt(k);
        }
      }
      _box.add(arbeitsbereicheToCache[i]);
    }
  }
}
