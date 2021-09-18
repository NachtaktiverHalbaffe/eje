import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class ArbeitsbereichRemoteDatasource {
  final http.Client client;
  ArbeitsbereichRemoteDatasource({@required this.client});

  Future<List<FieldOfWork>> getArtbeitsbereiche() async {
    return await WebScraper().scrapeArbeitsbereiche();
  }
}
