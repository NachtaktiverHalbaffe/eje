import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:hive/hive.dart';

class CampsLocalDatasource {
  Future<List<Camp>> getCachedCamps() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.campsBox);

    // load data from cache
    if (_box.isNotEmpty) {
      List<Camp> data = new List.empty(growable: true);
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

  Future<Camp> getCamp(Camp freizeit) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.campsBox);

    // get specific data entry from cache
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Camp camp = _box.getAt(i);
        if (camp == freizeit) {
          return camp;
        }
      }
      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  void cacheCamps(List<Camp> campsToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.campsBox);

    if (_box.isNotEmpty) {
      await _box.clear();
    }
    await _box.addAll(campsToCache);
  }
}