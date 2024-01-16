import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/exception.dart';
import 'package:http/http.dart' as http;

class BAKRemoteDatasource {
  final http.Client client;

  BAKRemoteDatasource({required this.client});

  Future<List<BAKler>> getBAK() async {
    try {
      return await WebScraper().scrapeBAKler();
    } on ServerException {
      throw ServerException();
    } on ConnectionException {
      throw ConnectionException();
    }
  }
}
