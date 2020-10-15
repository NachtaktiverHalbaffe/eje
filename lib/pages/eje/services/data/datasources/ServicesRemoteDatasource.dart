import 'package:eje/core/error/exception.dart';
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
      }
      if (document.getElementsByClassName('col s12 default').isNotEmpty) {
        final parent = document.getElementsByClassName('col s12 default');
        if (bilder.length > 1) {
          for (int i = 0; i < parent.length; i++) {
            bool isAlreadyInCache = false;
            if (parent[i].getElementsByTagName('img').isNotEmpty) {
              for (int k = 0; k < bilder.length; k++) {
                if ("https://www.eje-esslingen.de" +
                        parent[i]
                            .getElementsByTagName('img')[0]
                            .attributes['src'] ==
                    hyperlinks[k]) {
                  isAlreadyInCache = true;
                }
              }
              if (!isAlreadyInCache) {
                bilder.add("https://www.eje-esslingen.de" +
                    parent[i].getElementsByTagName('img')[0].attributes['src']);
              }
            }
          }
        } else if (parent[0]
            .getElementsByTagName('img')[0]
            .attributes['src']
            .isNotEmpty) {
          for (int i = 0; i < parent.length; i++) {
            if (parent[i].getElementsByTagName('img').isNotEmpty) {
              bilder.add("https://www.eje-esslingen.de" +
                  parent[i].getElementsByTagName('img')[0].attributes['src']);
            }
          }
        }
      }
      return Service(
          service: service.service,
          bilder: bilder,
          inhalt: service.inhalt,
          hyperlinks: hyperlinks);
    } else {
      throw ServerException();
    }
  }
}
