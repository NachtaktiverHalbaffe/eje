import 'package:eje/pages/neuigkeiten/data/models/neuigkeit_model.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:hive/hive.dart';

class NeuigkeitenLocalDatasource {
  Future<List<NeuigkeitenModel>> getCachedNeuigkeiten() {}

  Future<void> cacheNeuigkeiten(List<NeuigkeitenModel> neuigkeitenToCache) {
    Hive.box('Neuigkeiten').deleteAll(neuigkeitenToCache);
    Hive.box('Neuigkeiten').addAll(neuigkeitenToCache);
  }
}
