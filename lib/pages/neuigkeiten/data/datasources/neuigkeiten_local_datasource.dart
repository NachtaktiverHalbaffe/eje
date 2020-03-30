import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class NeuigkeitenLocalDatasource {
  final Box box;

  NeuigkeitenLocalDatasource({@required this.box});

  List<Neuigkeit> getCachedNeuigkeiten() {
    if (box.isNotEmpty) {
      List<Neuigkeit> temp = new List<Neuigkeit>();
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i) != null) {
          temp.add(box.getAt(i));
        }
      }
      return temp;
    } else {
      throw CacheException();
    }
  }

  Neuigkeit getNeuigkeit(String titel) {
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        Neuigkeit temp =box.getAt(i);
        if (temp.titel == titel) {
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheNeuigkeiten(List<Neuigkeit> neuigkeitenToCache) {
    box.deleteAll(neuigkeitenToCache);
    box.addAll(neuigkeitenToCache);
  }
}
