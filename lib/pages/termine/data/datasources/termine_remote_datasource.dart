import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class TermineRemoteDatasource {
  final http.Client client;
  final String apiUrl = "";

  TermineRemoteDatasource({@required this.client});

  //TODO: Implementierung der Onlineanbindung

  Future<List<Termin>> getTermine() async {
    final response = await client.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // return Termine.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
