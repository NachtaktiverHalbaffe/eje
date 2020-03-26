import 'package:eje/pages/neuigkeiten/data/models/neuigkeit_model.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';

abstract class NeuigkeitenLocalDatasource {
  Future<NeuigkeitenModel> getLastNeuigkeiten();

  Future<void> cacheNeuigkeiten(List<Neuigkeit> neuigkeitenToCache);
}
