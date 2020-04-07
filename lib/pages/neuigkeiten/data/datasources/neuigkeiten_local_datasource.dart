import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_neuigkeiten.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:hive/hive.dart';

class NeuigkeitenLocalDatasource {

  Future<List<Neuigkeit>> getCachedNeuigkeiten() async {
    Box _box ;
    _box = await Hive.openBox('Neuigkeiten');
    //Testdaten
   testdata_neuigkeiten(_box);
    if (_box.isNotEmpty) {
      List<Neuigkeit> temp = new List<Neuigkeit>();
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          temp.add(_box.getAt(i));
        }
      }
      Hive.box('Neuigkeiten').compact();
      Hive.box('Neuigkeiten').close();
      return temp;
    } else {
      throw CacheException();
    }
  }

  Future<Neuigkeit> getNeuigkeit(String titel) async {
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
  }

  Future<void> cacheNeuigkeiten(List<Neuigkeit> neuigkeitenToCache) async {
    Box _box = await Hive.openBox('Neuigkeiten');

    _box.deleteAll(neuigkeitenToCache);
    _box.addAll(neuigkeitenToCache);
    Hive.box('Neuigkeiten').compact();
    Hive.box('Neuigkeiten').close();
  }
}
