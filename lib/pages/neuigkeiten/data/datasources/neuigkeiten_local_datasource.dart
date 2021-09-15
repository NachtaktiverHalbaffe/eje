import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class NeuigkeitenLocalDatasource {
  Future<List<Neuigkeit>> getCachedNeuigkeiten() async {
    // Load appconfig
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.newsBox);

    // Load local data
    if (_box.isNotEmpty) {
      List<Neuigkeit> data = new List.empty(growable: true);
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          data.add(_box.getAt(i));
        }
      }
      if (data.isNotEmpty) {
        data.sort((a, b) => a.published.compareTo(b.published));
      }
      return data;
    } else {
      throw CacheException();
    }
  }

  /* Future<Neuigkeit> getNeuigkeit(String titel) async {
    Box _box = await Hive.openBox('Neuigkeiten');
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Neuigkeit temp = _box.getAt(i);
        if (temp.titel == titel) {
          Hive.box('Neuigkeiten').compact();
          Hive.box('Neuigkeiten').close();
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }*/

  void cacheNeuigkeiten(List<Neuigkeit> neuigkeitenToCache) async {
    // Load appconfig
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.newsBox);

    // Check for each news if it already exists, if not save it to cache
    for (int i = 0; i < neuigkeitenToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final Neuigkeit _neuigkeit = _box.getAt(k);
        if (_neuigkeit.titel == neuigkeitenToCache[i].titel) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(neuigkeitenToCache[i]);
      }
    }
  }
}
