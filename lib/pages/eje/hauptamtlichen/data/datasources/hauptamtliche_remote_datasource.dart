import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class HauptamtlicheRemoteDatasource {
  final http.Client client;
  final String apiUrl ="";

  HauptamtlicheRemoteDatasource({@required this.client});

  //TODO: Implementierung der Onlineanbindung

  Future<List<Hauptamtlicher>> getHauptamliche() async {
    final response = await client.get(apiUrl);
    if (response.statusCode == 200) {
      // return Hauptamtliche.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
