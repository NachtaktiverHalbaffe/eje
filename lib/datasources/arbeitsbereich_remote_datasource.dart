import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:http/http.dart' as http;

class ArbeitsbereichRemoteDatasource {
  final http.Client client;
  ArbeitsbereichRemoteDatasource({required this.client});

  Future<List<FieldOfWork>> getArtbeitsbereiche() async {
    try {
      return await WebScraper().scrapeArbeitsbereiche();
    } on ServerException {
      throw ServerException();
    } on ConnectionException {
      throw ConnectionException();
    }
  }
}
