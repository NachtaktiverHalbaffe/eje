import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/webscraper.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class HauptamtlicheRemoteDatasource {
  final http.Client client;

  HauptamtlicheRemoteDatasource({@required this.client});

  Future<List<Hauptamtlicher>> getHauptamliche() async {
    try {
      return await WebScraper().scrapeHauptamliche();
    } on ServerException {
      throw ServerException();
    } on ConnectionException {
      throw ConnectionException();
    }
  }
}
