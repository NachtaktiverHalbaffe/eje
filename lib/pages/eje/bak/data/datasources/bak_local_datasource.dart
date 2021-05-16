import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:hive/hive.dart';

class BAKLocalDatasource {
  Box _box;

  List<BAKler> getCachedBAK() {
    Box _box = Hive.box('BAK');

    if (_box.isNotEmpty) {
      List<BAKler> temp = new List<BAKler>();
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

  BAKler getBAKler(String name) {
    Box _box = Hive.box('Hauptamtliche');

    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        BAKler temp = _box.getAt(i);
        if (temp.name == name) {
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheBAK(List<BAKler> bakToCache) {
    Box _box = Hive.box('BAK');
    for (int i = 0; i < bakToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final BAKler _bakler = _box.getAt(k);
        if (_bakler.name == bakToCache[i].name) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(bakToCache[i]);
      }
    }
  }
}
