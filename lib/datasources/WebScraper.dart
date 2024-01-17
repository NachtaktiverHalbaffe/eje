// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, file_names
import 'package:eje/app_config.dart';
import 'package:eje/models/exception.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class WebScraper {
  //Scraping a Webpage amd parsing to an List of article

  Future<List<Element>> getHtmlElements(String url) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String ID_HEADER = appConfig.idHeader;
    final String ID_KONTAKT = appConfig.idContact;
    final String ID_ANSCHRIFT = appConfig.idAdress;

    // Get data from Internet
    var response;
    try {
      response = await http.get(Uri.parse(url));
    } catch (e) {
      throw ConnectionException(message: "Couldnt load url");
    }
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final parent =
          document.getElementsByClassName('container standard default ');

      List<Element> htmlElements = List.empty(growable: true);
      for (int i = 0; i < parent.length; i++) {
        // if html class "col s12 default" is present, then set this element as parent
        if (parent[i].getElementsByClassName("col s12 default").isNotEmpty) {
          parent[i] = parent[i].getElementsByClassName("col s12 default")[0];
        }
        //checking if element is not header or footer of website
        if (parent[i].id != ID_KONTAKT) {
          if (parent[i].id != ID_HEADER) {
            if (parent[i].id != ID_ANSCHRIFT) {
              if (parent[i].id != "c1128404") {
                htmlElements.add(parent[i]);
              }
            }
          }
        }
      }

      return htmlElements;
    } else {
      throw ConnectionException();
    }
  }
}
