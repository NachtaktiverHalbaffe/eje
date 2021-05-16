import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/errorHauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:meta/meta.dart';

class HauptamtlicheRemoteDatasource {
  final http.Client client;
  final String apiUrl = "";

  HauptamtlicheRemoteDatasource({@required this.client});

  //TODO: Implementierung der Onlineanbindung

  Future<List<Hauptamtlicher>> getHauptamliche() async {
    return await WebScraper().scrapeHauptamliche();
  }
}
