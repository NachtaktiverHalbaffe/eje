import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class BAKRemoteDatasource {
  final http.Client client;
  final String apiUrl = "";

  BAKRemoteDatasource({@required this.client});

  //TODO: Implementierung der Onlineanbindung

  Future<List<BAKler>> getBAK() async {
    final response = await client.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // return Hauptamtliche.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
