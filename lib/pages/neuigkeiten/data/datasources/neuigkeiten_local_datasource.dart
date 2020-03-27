import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:hive/hive.dart';

class NeuigkeitenLocalDatasource {
  List<Neuigkeit> getCachedNeuigkeiten() {
    if (Hive.box('Neuigkeiten').isNotEmpty) {
      List<Neuigkeit> temp = new List<Neuigkeit>();
      for (int i = 0; i < Hive.box('Neuigkeiten').length; i++) {
        temp.add(Hive.box('Neuigkeiten').getAt(i));
      }
      return temp;
    } else {
      throw CacheException();
    }
  }

  Neuigkeit getNeuigkeit(String titel) {
    if (Hive.box('Neuigkeiten').isNotEmpty) {
      for (int i = 0; i < Hive.box('Neuigkeiten').length; i++) {
        Neuigkeit temp = Hive.box('Neuigkeiten').getAt(i);
        if (temp.titel == titel) {
          return temp;
          break;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheNeuigkeiten(List<Neuigkeit> neuigkeitenToCache) {
    Hive.box('Neuigkeiten').deleteAll(neuigkeitenToCache);
    Hive.box('Neuigkeiten').addAll(neuigkeitenToCache);
  }
}
