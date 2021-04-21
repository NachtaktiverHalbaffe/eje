import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class ArbeitsbereichRemoteDatasource {
  final http.Client client;
  final String apiUrl = "";

  ArbeitsbereichRemoteDatasource({@required this.client});

  //TODO: Implementierung der Onlineanbindung

  Future<List<Arbeitsbereich>> getArtbeitsbereiche() async {
    final response = await client.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // return Arbeitsbereich.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
