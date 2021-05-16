import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:hive/hive.dart';

class HauptamtlicheLocalDatasource {
  Box _box;

  List<Hauptamtlicher> getCachedHauptamtliche() {
    Box _box = Hive.box('Hauptamtliche');

    if (_box.isNotEmpty) {
      List<Hauptamtlicher> temp = new List<Hauptamtlicher>();
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          temp.add(_box.getAt(i));
        }
      }
      return temp;
    } else {
      throw CacheException();
    }
  }

  Hauptamtlicher getHauptamtliche(String name) {
    Box _box = Hive.box('Hauptamtliche');

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

  void cacheHauptamtliche(List<Hauptamtlicher> hauptamtlicheToCache) {
    Box _box = Hive.box('Hauptamtliche');
    for (int i = 0; i < hauptamtlicheToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final Hauptamtlicher _hauptamtlicher = _box.getAt(k);
        if (_hauptamtlicher.name == hauptamtlicheToCache[i].name) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(hauptamtlicheToCache[i]);
      }
    }
  }
}
