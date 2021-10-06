import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/webscraper.dart';
import 'package:eje/pages/eje/bak/domain/entitys/bakler.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class BAKRemoteDatasource {
  final http.Client client;

  BAKRemoteDatasource({@required this.client});

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
