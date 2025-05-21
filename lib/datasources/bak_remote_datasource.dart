import 'package:eje/app_config.dart';
import 'package:eje/datasources/remote_data_source.dart';
import 'package:eje/models/bakler.dart';
import 'package:eje/models/exception.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart';

class BAKRemoteDatasource implements RemoteDataSource<BAKler, String> {
  final Client client;

  BAKRemoteDatasource({required this.client});

  @override
  Future<List<BAKler>> getAllElements() async {
    List<BAKler> bakler = List.empty(growable: true);
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String domain = appConfig.domain;
    final String url = domain + appConfig.bakEndpoint;
    final String idHeader = appConfig.idHeader;
    final String idFooter = appConfig.idContact;
    final String ID_ANSCHRIFT = appConfig.idAdress;

    // Get data from Internet
    var response;
    try {
      response = await client.get(Uri.parse(url));
    } catch (e) {
      throw ConnectionException(
          message: "Couldnt load url $url", type: ExceptionType.notFound);
    }
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final parent = document.getElementsByClassName('col s12 default');
      for (int i = 0; i < parent.length; i++) {
        //checking if element is not header or footer of website
        if (parent[i].id != idFooter) {
          if (parent[i].id != idHeader) {
            if (parent[i].id != ID_ANSCHRIFT) {
              //Parse data to article
              String vorstellung = "";
              String amt = "";
              String name = "";
              String bild = "";
              String email = "";
              String threema = "";
              // ! name parsen
              if (parent[i].getElementsByClassName('icon-left').isNotEmpty) {
                // get title
                String title =
                    parent[i].getElementsByClassName('icon-left')[0].text;
                // Split title into name and amt
                List<String> splitTitle;
                splitTitle = title.split(' - ');
                name = splitTitle[0].trimLeft().trimRight();
                if (splitTitle.length == 2) {
                  amt = splitTitle[1].trimLeft().trimRight();
                }
              }

              if (parent[i]
                  .getElementsByClassName(
                      'col s12 m8 l8 bildtextteaser-content halfpic')
                  .isNotEmpty) {
                parent[i].getElementsByClassName('bodytext').forEach((element) {
                  // ! Threema parsen
                  if (element.text.contains('Threema') |
                      element.getElementsByTagName('a').isNotEmpty) {
                    if (element.text.contains("ist:")) {
                      threema =
                          element.text.split('ist:')[1].trimLeft().trimRight();
                    } else {
                      threema = element.text.trimLeft().trimRight();
                      threema = threema.substring(threema.length - 8);
                      // If email was parsed as threema
                      if (threema == "ingen.de") {
                        threema = "";
                      }
                    }
                    // ! Email parsen
                    if (element.getElementsByTagName('a').isNotEmpty) {
                      email = element
                          .getElementsByTagName('a')[0]
                          .text
                          .replaceAll('dontospamme', '')
                          .replaceAll('gowaway.', '')
                          .trimLeft()
                          .trimRight();
                    }
                  }
                  // ! Beschreibung parsen
                  else if (element.text != "") {
                    vorstellung = "$vorstellung${element.text.trim()}\n\n";
                    vorstellung =
                        vorstellung.replaceAll("Ich bin erreichbar unter:", "");
                  }
                });
              }
              // ! bilder parsen
              //check if picture links are in "text-pic-right" or "width100 center marginBottom10" class
              if (parent[i]
                  .getElementsByClassName('copy-hover width100 ')
                  .isNotEmpty) {
                //picture-link is in text-pic-right class
                bild = domain +
                    parent[i]
                        .getElementsByClassName('copy-hover width100 ')[0]
                        .getElementsByTagName('img')[0]
                        .attributes['src']!
                        .trimLeft()
                        .trimRight();
              } else if (parent[i]
                  .getElementsByClassName(
                      'col s12 m4 l4 width100 bildtextteaser-image halfpic')
                  .isNotEmpty) {
                bild = domain +
                    parent[i]
                        .getElementsByClassName(
                            'col s12 m4 l4 width100 bildtextteaser-image halfpic')[0]
                        .getElementsByTagName('img')[0]
                        .attributes['src']!
                        .trimLeft()
                        .trimRight();
              }

              //add scraped Section to List of Articles
              if (name != "" ||
                  bild != "" ||
                  amt != "" ||
                  vorstellung != "" ||
                  email != "" ||
                  threema != "") {
                bakler.add(BAKler(
                    image: bild,
                    name: name,
                    function: amt,
                    introduction: vorstellung,
                    email: email,
                    threema: threema));
              }
            }
          }
        }
      }
      return bakler;
    } else {
      // No Internet connection, returning empty Article
      throw ConnectionException(
          message: "Got bad statuscode : ${response.statusCode}",
          type: ExceptionType.badRequest);
    }
  }

  @override
  Future<BAKler> getElement(String elementId) {
    throw UnimplementedError();
  }
}
