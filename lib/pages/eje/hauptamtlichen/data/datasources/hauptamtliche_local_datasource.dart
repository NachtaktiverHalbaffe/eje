
import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_hauptamtliche.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:hive/hive.dart';

class HauptamtlicheLocalDatasource{
  Box box;
  HauptamtlicheLocalDatasource(this.box);

  Future<List<Hauptamtlicher>> getCachedHauptamtliche() async {
    Box _box;
    if (!box.isOpen) {
      _box = await Hive.openBox('Hauptamtliche');
    } else
      _box = box;
    //Testdaten
    testdata_hauptamtliche(_box);
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

  Future<Hauptamtlicher> getHauptamtliche(String name) async {
    Box _box;
    if (!box.isOpen) {
      _box = await Hive.openBox('Hauptamtliche');
    } else
      _box = box;
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

  Future<void> cacheHauptamtliche(List<Hauptamtlicher> neuigkeitenToCache) async {
    Box _box;
    if (!box.isOpen) {
      _box = await Hive.openBox('Hauptamtliche');
    } else
      _box = box;
    box.deleteAll(neuigkeitenToCache);
    _box.addAll(neuigkeitenToCache);
  }

}