import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:hive/hive.dart';

class BAKLocalDatasource {
  Future<List<BAKler>> getCachedBAK() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    Box _box = Hive.box(appConfig.bakBox);

    // load data from cache
    if (_box.isNotEmpty) {
      List<BAKler> data = new List.empty(growable: true);
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

  Future<BAKler> getBAKler(String name) async {
    final appConfig = await AppConfig.loadConfig();
    Box _box = Hive.box(appConfig.bakBox);

    // load specific data entry from cache
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        BAKler temp = _box.getAt(i);
        if (temp.name == name) {
          return temp;
        }
      }
      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  void cacheBAK(List<BAKler> bakToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    Box _box = Hive.box(appConfig.bakBox);

    // cache data if not already cached
    for (int i = 0; i < bakToCache.length; i++) {
      for (int k = 0; k < _box.length; k++) {
        final BAKler _bakler = _box.getAt(k);
        if (_bakler.name == bakToCache[i].name) {
          _box.deleteAt(k);
        }
      }
      _box.add(bakToCache[i]);
    }
  }
}
