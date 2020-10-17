import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_arbeitsbereiche.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:hive/hive.dart';

class ArbeitsbereicheLocalDatasource {
  Box _box;

  List<Arbeitsbereich> getCachedArbeitsbereiche() {
    Box _box = Hive.box('Arbeitsbereiche');
    testdata_arbeitsbereiche(_box);
    if (_box.isNotEmpty) {
      List<Arbeitsbereich> temp = new List<Arbeitsbereich>();
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

  Arbeitsbereich getArbeitsbereich(String arbeitsfeld) {
    Box _box = Hive.box('Arbeitsbereiche');
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

  void cacheBAK(List<Arbeitsbereich> arbeitsbereicheToCache) {
    _box = Hive.box('Arbeitsbereiche');
    for (int i = 0; i < arbeitsbereicheToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final Arbeitsbereich _arbeitsbereich = _box.getAt(k);
        if (_arbeitsbereich.arbeitsfeld ==
            arbeitsbereicheToCache[i].arbeitsfeld) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(arbeitsbereicheToCache[i]);
      }
    }
  }
}
