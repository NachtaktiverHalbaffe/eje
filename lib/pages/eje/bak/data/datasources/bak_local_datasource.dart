
import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_bak.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:hive/hive.dart';

class BAKLocalDatasource{
  Box _box;

  Future<List<BAKler>> getCachedBAK() async {
    _box = await Hive.openBox('BAK');
    //Testdaten
    testdata_bak(_box);
    if (_box.isNotEmpty) {
      List<BAKler> temp = new List<BAKler>();
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          temp.add(_box.getAt(i));
        }
      }
      Hive.box('BAK').compact();
      Hive.box('BAK').close();
      return temp;
    } else {
      throw CacheException();
    }
  }

  Future<BAKler> getBAKler(String name) async {
    _box = await Hive.openBox('Hauptamtliche');
    testdata_bak(_box);
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        BAKler temp = _box.getAt(i);
        if (temp.name == name) {
          Hive.box('BAK').compact();
          Hive.box('BAK').close();
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheBAK(List<BAKler> neuigkeitenToCache) async {
    _box = await Hive.openBox('BAK');
    _box.deleteAll(neuigkeitenToCache);
    _box.addAll(neuigkeitenToCache);
    Hive.box('BAK').compact();
    Hive.box('BAK').close();
  }

}