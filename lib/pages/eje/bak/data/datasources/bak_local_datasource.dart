import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/bak/domain/entitys/bakler.dart';
import 'package:hive/hive.dart';

class BAKLocalDatasource {
  Future<List<BAKler>> getCachedBAK() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    Box _box = Hive.box(appConfig.bakBox);

    // load data from cache
    if (_box.isNotEmpty) {
      List<BAKler> data = List.empty(growable: true);
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

  Future<void> cacheBAK(List<BAKler> bakToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    Box _box = Hive.box(appConfig.bakBox);

    if (_box.isNotEmpty) {
      await _box.clear();
    }
    await _box.addAll(bakToCache);
  }
}
