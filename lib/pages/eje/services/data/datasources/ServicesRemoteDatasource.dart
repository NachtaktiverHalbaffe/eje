import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
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
    const String DOMAIN = "https://www.eje-esslingen.de";

    List<Hyperlink> hyperlinks = service.hyperlinks.sublist(0, 1);
    List<String> links = List();
    List<String> description = List();
    List<String> bilder = service.bilder;
    final response = await client.get(service.hyperlinks[0].link);
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
              if (DOMAIN +
                      parent[i]
                          .getElementsByTagName('a')[0]
                          .attributes['href'] ==
                  hyperlinks[k]) {
                isAlreadyInCache = true;
              }
            }
            if (!isAlreadyInCache) {
              links.add(DOMAIN +
                  parent[i].getElementsByTagName('a')[0].attributes['href']);
              description.add(
                  parent[i].getElementsByTagName('a')[0].attributes['title']);
            }
          }
        } else {
          links.addAll(parent
              .map((element) =>
                  DOMAIN +
                  element.getElementsByTagName('a')[0].attributes['href'])
              .toList());
          description.addAll(parent
              .map((element) =>
                  element.getElementsByTagName('a')[0].attributes['title'])
              .toList());
        }
        for (int k = 0; k < links.length; k++) {
          hyperlinks
              .add(Hyperlink(link: links[k], description: description[k]));
        }
        return Service(
            service: service.service,
            bilder: service.bilder,
            inhalt: service.inhalt,
            hyperlinks: hyperlinks);
      } //Service is a webpage which to webscrape
      else {
        List<Article> _article =
            await WebScraper().scrapeWebPage(service.hyperlinks[0].link);
        List<String> bilder = service.bilder.sublist(0, 1);
        List<Hyperlink> hyperlinks = service.hyperlinks.sublist(0, 1);
        String content = service.inhalt;
        for (int i = 0; i < _article.length; i++) {
          if (_article[i].bilder[0] != "") {
            bilder.addAll(_article[i].bilder);
          }
          if (_article[i].hyperlinks[0].link != "") {
            hyperlinks.addAll(_article[i].hyperlinks);
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
        if (hyperlinks.length == 1) {
          hyperlinks.add(Hyperlink(link: "", description: ""));
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
