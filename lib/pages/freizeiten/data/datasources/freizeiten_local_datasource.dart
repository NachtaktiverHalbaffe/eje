import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_freizeiten.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:hive/hive.dart';

class FreizeitenLocalDatasource {
  Future<List<Freizeit>> getCachedFreizeiten() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.campsBox);
    testdataFreizeiten(_box);

    // load data from cache
    if (_box.isNotEmpty) {
      List<Freizeit> data = new List.empty(growable: true);
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

  Future<Freizeit> getFreizeit(Freizeit freizeit) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.campsBox);

    // get specific data entry from cache
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Freizeit camp = _box.getAt(i);
        if (camp == freizeit) {
          return camp;
        }
      }
      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  void cacheFreizeiten(List<Freizeit> freizeitenToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.campsBox);

    // cache data if not already cached
    for (int i = 0; i < freizeitenToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final Freizeit _freizeit = _box.getAt(k);
        if (_freizeit == freizeitenToCache[i]) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(freizeitenToCache[i]);
      }
    }
  }
}
