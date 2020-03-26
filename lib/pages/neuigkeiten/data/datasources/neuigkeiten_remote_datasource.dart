
import 'package:eje/pages/neuigkeiten/data/models/neuigkeit_model.dart';

abstract class NeuigkeitenRemoteDatasource{
  //TODO: Implementierung der Onlineanbindung

  Future<NeuigkeitenModel> getNeuigkeit(String Titel);

  Future<List<NeuigkeitenModel>> getNeuigkeiten();

}