import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_hauptamtliche.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:hive/hive.dart';

class HauptamtlicheLocalDatasource {
  Box _box;

  Future<List<Hauptamtlicher>> getCachedHauptamtliche() async {
    _box = await Hive.openBox('Hauptamtliche');
    //Testdaten
    testdata_hauptamtliche(_box);
    if (_box.isNotEmpty) {
      List<Hauptamtlicher> temp = new List<Hauptamtlicher>();
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          temp.add(_box.getAt(i));
        }
      }
      Hive.box('Hauptamtliche').compact();
      Hive.box('Hauptamtliche').close();
      return temp;
    } else {
      throw CacheException();
    }
  }

  Future<Hauptamtlicher> getHauptamtliche(String name) async {
    _box = await Hive.openBox('Hauptamtliche');
    testdata_hauptamtliche(_box);
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Hauptamtlicher temp = _box.getAt(i);
        if (temp.name == name) {
          Hive.box('Hauptamtliche').compact();
          Hive.box('Hauptamtliche').close();
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheHauptamtliche(
      List<Hauptamtlicher> hauptamtlicheToCache) async {
    _box = await Hive.openBox('Hauptamtliche');
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
    Hive.box('Hauptamtliche').compact();
    //Hive.box('Hauptamtliche').close();
  }
}
