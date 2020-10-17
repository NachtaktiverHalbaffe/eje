import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_freizeiten.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:hive/hive.dart';

class FreizeitenLocalDatasource {
  Box _box;

  List<Freizeit> getCachedFreizeiten() {
    _box = Hive.box('Freizeiten');
    testdata_freizeiten(_box);
    if (_box.isNotEmpty) {
      List<Freizeit> temp = new List<Freizeit>();
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

  Future<Freizeit> getFreizeit(Freizeit freizeit) async {
    Box _box = Hive.box('Freizeiten');
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Freizeit temp = _box.getAt(i);
        if (temp == freizeit) {
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheFreizeiten(List<Freizeit> freizeitenToCache) {
    _box = Hive.box('Freizeiten');
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
