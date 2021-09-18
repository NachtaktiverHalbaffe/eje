import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class HauptamtlicheRemoteDatasource {
  final http.Client client;

  HauptamtlicheRemoteDatasource({@required this.client});

  Future<List<Hauptamtlicher>> getHauptamliche() async {
    return await WebScraper().scrapeHauptamliche();
  }
}
