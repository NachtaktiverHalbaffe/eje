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

  final String sectionsCssClass;
  late dom.Document document;
  late String singleElementUrl;
  final String getAllElementsUrl;

  WebScraperRemoteDatasource(
      {required this.client,
      required this.getAllElementsUrl,
      this.sectionsCssClass = "ekd-element"});

  Future<T> scrapeWebElementsForSingleItem(List<Element> hmtlElements);

  Future<List<T>> scrapeWebElementsForMultipleItem(List<Element> hmtlElements);

  @override
  Future<T> getElement(String elementId) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String idHeader = appConfig.idHeader;
    final String idContact = appConfig.idContact;
    final String idFooter = appConfig.idAdress;

    this.singleElementUrl = elementId;
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
          .getElementsByTagName('main')
          .first
          .getElementsByClassName(sectionsCssClass)
          .where((htmlElement) =>
              htmlElement.id != idContact &&
              htmlElement.id != idHeader &&
              htmlElement.id != idFooter)
          .toList();

      return await scrapeWebElementsForSingleItem(parent);
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
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String idHeader = appConfig.idHeader;
    final String idContact = appConfig.idContact;
    final String idFooter = appConfig.idAdress;

    // Get data from Internet
    Response response;
    try {
      response = await client.get(Uri.parse(this.getAllElementsUrl));
    } catch (e) {
      throw ConnectionException(
          message: "Couldnt load url $getAllElementsUrl",
          type: ExceptionType.notFound);
    }
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      this.document = document;
      final parent = document
          .getElementsByTagName('main')
          .first
          .getElementsByClassName(sectionsCssClass)
          .where((htmlElement) =>
              htmlElement.id != idContact &&
              htmlElement.id != idHeader &&
              htmlElement.id != idFooter)
          .toList();

      return await scrapeWebElementsForMultipleItem(parent);
    } else {
      // No Internet connection, returning empty Article
      print("Error: No internet Connection");
      throw ConnectionException(
          message: "Got bad statuscode ${response.statusCode}",
          type: ExceptionType.badRequest);
    }
  }
}
