import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:hive/hive.dart';

class CampsLocalDatasource {
  Future<List<Camp>> getCachedCamps() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.campsBox);

    // load data from cache
    if (box.isNotEmpty) {
      List<Camp> data = List.empty(growable: true);
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

  Future<Camp> getCamp(Camp freizeit) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.campsBox);

    // get specific data entry from cache
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        Camp camp = box.getAt(i);
        if (camp == freizeit) {
          return camp;
        }
      }
      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheCamps(List<Camp> campsToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.campsBox);

    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(campsToCache);
  }
}
