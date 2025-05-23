import 'package:eje/app_config.dart';
import 'package:eje/datasources/remote_data_source.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart';

class ArbeitsbereichRemoteDatasource
    implements RemoteDataSource<FieldOfWork, String> {
  final Client client;
  ArbeitsbereichRemoteDatasource({required this.client});

  @override
  Future<List<FieldOfWork>> getAllElements() async {
    List<FieldOfWork> arbeitsbereiche = List.empty(growable: true);
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String domain = appConfig.domain;
    final String url = domain + appConfig.fieldOfWorkEndpoint;
    final String idHeader = appConfig.idHeader;
    final String idContact = appConfig.idContact;
    final String idFooter = appConfig.idAdress;

    // Get data from Internet
    Response response;
    try {
      response = await client.get(Uri.parse(url));
    } catch (e) {
      throw ConnectionException(message: "Couldn't load url");
    }
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final parent = document.getElementsByClassName('card link-area');
      for (int i = 0; i < parent.length; i++) {
        //checking if element is not header or footer of website
        if (parent[i].id != idContact) {
          if (parent[i].id != idHeader) {
            if (parent[i].id != idFooter) {
              //Parse data to article
              String arbeitsbereich = "";
              List<String> bild = List.empty(growable: true);
              String linkUrl = "";
              // ! arbeitsfeld parsen
              if (parent[i]
                  .getElementsByClassName('card-title icon-left ')
                  .isNotEmpty) {
                arbeitsbereich = parent[i]
                    .getElementsByClassName('card-title icon-left ')[0]
                    .text
                    .trimLeft()
                    .trimRight();
              }

              // ! bilder parsen
              //check if picture links are in "text-pic-right" or "width100 center marginBottom10" class
              if (parent[i].getElementsByClassName('card-image').isNotEmpty) {
                //picture-link is in text-pic-right class
                bild.add(domain +
                    parent[i]
                        .getElementsByClassName('card-image')[0]
                        .getElementsByTagName('img')[0]
                        .attributes['src']!
                        .trimLeft()
                        .trimRight());
              }
              // ! link parsen
              if (parent[i].getElementsByClassName('card-action').isNotEmpty) {
                linkUrl = domain +
                    parent[i]
                        .getElementsByClassName('card-action')[0]
                        .getElementsByTagName('a')[0]
                        .attributes['href']!;
              }

              //add scraped Section to List of Articles
              if (arbeitsbereich != "" || bild.isNotEmpty || linkUrl != "") {
                arbeitsbereiche.add(FieldOfWork(
                  name: arbeitsbereich,
                  images: bild,
                  description: "",
                  link: linkUrl,
                ));
              }
            }
          }
        }
      }
      return arbeitsbereiche;
    } else {
      throw ConnectionException(message: "Bad Request");
    }
  }

  @override
  Future<FieldOfWork> getElement(String elementId) {
    throw UnimplementedError();
  }
}
