import 'package:eje/app_config.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/exception.dart';
import 'package:hive/hive.dart';

class BAKLocalDatasource {
  Future<List<BAKler>> getCachedBAK() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    Box box = Hive.box(appConfig.bakBox);

    // load data from cache
    if (box.isNotEmpty) {
      List<BAKler> data = List.empty(growable: true);
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i) != null) {
          data.add(box.getAt(i));
        }
      }
      return data;
    } else {
      throw CacheException();
    }
  }

  Future<BAKler> getBAKler(String name) async {
    final appConfig = await AppConfig.loadConfig();
    Box box = Hive.box(appConfig.bakBox);

    // load specific data entry from cache
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        BAKler temp = box.getAt(i);
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
    Box box = Hive.box(appConfig.bakBox);

    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(bakToCache);
  }
}
