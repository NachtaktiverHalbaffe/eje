import 'dart:convert';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class NeuigkeitenRemoteDatasource {
  final http.Client client;
  final String apiUrl;

  NeuigkeitenRemoteDatasource({@required this.client, @required this.apiUrl});

  //TODO: Implementierung der Onlineanbindung

  Future<List<Neuigkeit>> getNeuigkeiten() async {
    final response = await client.get(apiUrl);
    if (response.statusCode == 200) {
      // return NeuigkeitenModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
