import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class FreizeitenRemoteDatasource {
  final http.Client client;
  final String apiUrl ="";

  FreizeitenRemoteDatasource({@required this.client});

  //TODO: Implementierung der Onlineanbindung

  Future<List<Freizeit>> getFreizeiten() async {
    final response = await client.get(apiUrl);
    if (response.statusCode == 200) {
      // return Freizeit.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}