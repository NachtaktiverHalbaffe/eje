import 'package:eje/app_config.dart';
import 'package:eje/datasources/remote_data_source.dart';
import 'package:eje/models/exception.dart';
import 'package:equatable/equatable.dart';
import 'package:html/dom.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart';

abstract class WebScraperRemoteDatasource<T extends Equatable>
    implements RemoteDataSource<T, String> {
  final Client client;

  static const String sectionsCssClass = "ekd-element";
  late dom.Document document;
  late String url;

  WebScraperRemoteDatasource({required this.client});

  Future<T> scrapeWebElements(List<Element> hmtlElements);

  @override
  Future<T> getElement(String elementId) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String idHeader = appConfig.idHeader;
    final String idContact = appConfig.idContact;
    final String idFooter = appConfig.idAdress;

    this.url = elementId;
    // Get data from Internet
    Response response;

    try {
      response = await client.get(Uri.parse(elementId));
    } catch (e) {
      throw ConnectionException(
          message: "Couldnt load url $elementId", type: ExceptionType.notFound);
    }
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      this.document = document;
      final parent = document
          .getElementsByClassName(sectionsCssClass)
          .where((htmlElement) =>
              htmlElement.id != idContact &&
              htmlElement.id != idHeader &&
              htmlElement.id != idFooter)
          .toList();

      return await scrapeWebElements(parent);
    } else {
      // No Internet connection, returning empty Article
      print("Error: No internet Connection");
      throw ConnectionException(
          message: "Got bad statuscode ${response.statusCode}",
          type: ExceptionType.badRequest);
    }
  }

  @override
  Future<List<T>> getAllElements() async {
    throw UnimplementedError();
  }
}
