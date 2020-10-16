import 'package:eje/core/error/exception.dart';
import 'package:eje/core/platform/Article.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/domain/usecases/GetServices.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class ServicesRemoteDatasource {
  final http.Client client;

  ServicesRemoteDatasource({@required this.client});

  //TODO: Implementierung der Onlineanbindung

  Future<Service> getService(Service service) async {
    List<String> hyperlinks = service.hyperlinks;
    List<String> bilder = service.bilder;
    final response = await client.get(hyperlinks[0]);
    if (response.statusCode == 200) {
      print("Services: Getting Data from Internet");
      dom.Document document = parser.parse(response.body);
      //Check if service is eje-info
      if (document.getElementsByClassName('collection-item row').isNotEmpty) {
        final parent = document.getElementsByClassName('collection-item row');
        if (hyperlinks.length > 1) {
          for (int i = 0; i < parent.length; i++) {
            bool isAlreadyInCache = false;
            for (int k = 0; k < hyperlinks.length; k++) {
              if ("https://www.eje-esslingen.de/" +
                      parent[i]
                          .getElementsByTagName('a')[0]
                          .attributes['href'] ==
                  hyperlinks[k]) {
                isAlreadyInCache = true;
              }
            }
            if (!isAlreadyInCache) {
              hyperlinks.add("https://www.eje-esslingen.de/" +
                  parent[i].getElementsByTagName('a')[0].attributes['href']);
            }
          }
        } else {
          print("https://www.eje-esslingen.de/" +
              parent[0].getElementsByTagName('a')[0].attributes['href']);
          hyperlinks.addAll(parent
              .map((element) =>
                  "https://www.eje-esslingen.de/" +
                  element.getElementsByTagName('a')[0].attributes['href'])
              .toList());
        }
        return Service(
            service: service.service,
            bilder: service.bilder,
            inhalt: service.inhalt,
            hyperlinks: hyperlinks);
      } //Service is a webpage which to webscrape
      else {
        List<Article> _article =
            await WebScraper().scrapeWebPage(service.hyperlinks[0]);
        List<String> bilder = List();
        List<String> hyperlinks = service.hyperlinks;
        String content = service.inhalt;
        for (int i = 0; i < _article.length; i++) {
          if (_article[i].bilder[0] != "") {
            for (int k = 0; k < _article[i].bilder.length; k++) {
              if (!bilder.contains(_article[i].bilder[k])) {
                bilder.add(_article[i].bilder[k]);
              }
            }
          }
          if (_article[i].hyperlinks.isNotEmpty) {
            for (int k = 0; k < _article[i].hyperlinks.length; k++) {
              if (!hyperlinks.contains(_article[i].hyperlinks[k])) {
                hyperlinks.add(_article[i].hyperlinks[k]);
              }
            }
          }
          if (_article[i].content.isNotEmpty) {
            if (!content.contains(_article[i].content)) {
              content = content + _article[i].content;
            }
          }
        }
        if (bilder.length > 1) {
          bilder = bilder.sublist(1);
        }
        return Service(
          service: service.service,
          bilder: bilder,
          inhalt: content,
          hyperlinks: hyperlinks,
        );
      }
    } else {
      throw ServerException();
    }
  }
}
