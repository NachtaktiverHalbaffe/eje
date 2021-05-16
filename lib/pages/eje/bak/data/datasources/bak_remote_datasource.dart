import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class BAKRemoteDatasource {
  final http.Client client;
  final String apiUrl = "";

  BAKRemoteDatasource({@required this.client});

  Future<List<BAKler>> getBAK() async {
    return await WebScraper().scrapeBAKler();
  }
}
