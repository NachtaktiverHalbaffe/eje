import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class ArbeitsbereichRemoteDatasource {
  final http.Client client;

  ArbeitsbereichRemoteDatasource({@required this.client});

  Future<List<Arbeitsbereich>> getArtbeitsbereiche() async {
    return await WebScraper().scrapeArbeitsbereiche();
  }
}
