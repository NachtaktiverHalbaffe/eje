import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/neuigkeiten/data/models/neuigkeit_model.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:hive/hive.dart';

class NeuigkeitenLocalDatasource {
  List<NeuigkeitenModel> getCachedNeuigkeiten() {
    if (Hive.box('Neuigkeiten').isNotEmpty) {
      List<NeuigkeitenModel> temp = new List<NeuigkeitenModel>();
      for (int i = 0; i < Hive.box('Neuigkeiten').length; i++) {
        temp.add(Hive.box('Neuigkeiten').getAt(i));
      }
      return temp;
    } else {
      throw CacheException();
    }
  }

  NeuigkeitenModel getNeuigkeit(String titel) {
    if (Hive.box('Neuigkeiten').isNotEmpty) {
      for (int i = 0; i < Hive.box('Neuigkeiten').length; i++) {
        NeuigkeitenModel temp = Hive.box('Neuigkeiten').getAt(i);
        if (temp.titel == titel) {
          return temp;
          break;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheNeuigkeiten(List<NeuigkeitenModel> neuigkeitenToCache) {
    Hive.box('Neuigkeiten').deleteAll(neuigkeitenToCache);
    Hive.box('Neuigkeiten').addAll(neuigkeitenToCache);
  }
}
