import 'package:eje/app_config.dart';
import 'package:eje/datasources/RemoteDataSource.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/exception.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart';

class EmployeesRemoteDatasource implements RemoteDataSource<Employee, String> {
  final Client client;

  EmployeesRemoteDatasource({required this.client});

  @override
  Future<List<Employee>> getAllElements() async {
    List<Employee> hauptamtliche = List.empty(growable: true);
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String DOMAIN = appConfig.domain;
    final String URL = DOMAIN + appConfig.employeesEndpoint;
    final String ID_HEADER = appConfig.idHeader;
    final String ID_KONTAKT = appConfig.idContact;
    final String ID_ANSCHRIFT = appConfig.idAdress;

    // Get data from Internet
    Response response;
    try {
      response = await client.get(Uri.parse(URL));
    } catch (e) {
      throw ConnectionException(
          message: "Couldnt load url: $URL", type: ExceptionType.NOT_FOUND);
    }
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final parent = document.getElementsByClassName('col s12 default');
      for (int i = 0; i < parent.length; i++) {
        //checking if element is not header or footer of website
        if (parent[i].id != ID_KONTAKT) {
          if (parent[i].id != ID_HEADER) {
            if (parent[i].id != ID_ANSCHRIFT) {
              //Parse data to article
              String vorstellung = "";
              String bereich = "";
              String name = "";
              String bild = "";
              String email = "";
              String telefon = "";
              String handy = "";
              String threema = "";
              // ! name parsen
              if (parent[i].getElementsByClassName('icon-left').isNotEmpty) {
                // get title
                String _title =
                    parent[i].getElementsByClassName('icon-left')[0].text;
                // Split title into name and amt
                List<String> splitTitle;
                splitTitle = _title.split('-');
                name = splitTitle[0].trimLeft().trimRight();
                if (splitTitle.length == 2) {
                  bereich = splitTitle[1].trimLeft().trimRight();
                }
              }
              // ! Beschreibung parsen
              String content = '';
              if (parent[i]
                  .getElementsByClassName(
                      'col s12 m8 l8 bildtextteaser-content halfpic')
                  .isNotEmpty) {
                parent[i].getElementsByClassName('bodytext').forEach((element) {
                  if (!element.text.contains('Ich bin erreichbar unter')) {
                    if (element.text.contains('0711')) {
                      telefon = element.text
                          .replaceAll(RegExp(r"\D"), "") // remove all Letters
                          .trimLeft()
                          .trimRight();
                    } else if (element.text.contains('Diensthandy')) {
                      if (element.text.contains(":")) {
                        handy =
                            element.text.split(':')[1].trimLeft().trimRight();
                      } else {
                        handy = element.text
                            .replaceAll(RegExp(r"\D"), "") //remove all letters
                            .trim();
                      }
                    } else if (element.text.contains('Threema')) {
                      if (element.text.contains("unter:")) {
                        threema = element.text
                            .split('unter:')[1]
                            .trimLeft()
                            .trimRight();
                      } else {
                        threema = element.text
                            // .split('unter:')[1]
                            .trimLeft()
                            .trimRight();
                        threema = threema.substring(threema.length - 8);
                      }
                    } else if (element.getElementsByTagName('a').isNotEmpty) {
                      email = element
                          .getElementsByTagName('a')[0]
                          .text
                          .replaceAll('dontospamme', '')
                          .replaceAll('gowaway.', '')
                          .trimLeft()
                          .trimRight();
                    } else if (element.text != "") {
                      vorstellung =
                          "$vorstellung${element.text.trimLeft().trimRight()}\n";
                    }
                  }
                });
              }
              // ! bilder parsen
              //check if picture links are in "text-pic-right" or "width100 center marginBottom10" class
              if (parent[i]
                  .getElementsByClassName('copy-hover width100 ')
                  .isNotEmpty) {
                //picture-link is in text-pic-right class
                bild = DOMAIN +
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
                bild = DOMAIN +
                    parent[i]
                        .getElementsByClassName(
                            'col s12 m4 l4 width100 bildtextteaser-image halfpic')[0]
                        .getElementsByTagName('img')[0]
                        .attributes['src']!
                        .trimLeft()
                        .trimRight();
              }

              // ! Formatting if needed
              //Einrückungen bei neuen Paragraph entfernen
              if (content.contains("<br>")) {
                content = content.replaceAll("<br> ", "\n");
                content = content.replaceAll("<br>", "\n");
              }
              //HTML-Formatierungszeichen bei neuen Paragraph entfernen
              //und neuen Abschnitt für content anfangen
              if (content.contains("&nbsp;")) {
                content = content.replaceAll("&nbsp;", " ");
              }
              content = "$content\n\n";
              //Default values if no hyperlinks are scraped

              //add scraped Section to List of Articles
              if (name != "" ||
                  bild != "" ||
                  bereich != "" ||
                  vorstellung != "" ||
                  email != "" ||
                  telefon != "" ||
                  handy != "" ||
                  threema != "") {
                hauptamtliche.add(Employee(
                    image: bild,
                    name: name,
                    function: bereich,
                    introduction: vorstellung,
                    email: email,
                    telefon: telefon,
                    handy: handy,
                    threema: threema));
              }
            }
          }
        }
      }
      return hauptamtliche;
    } else {
      // No Internet connection, returning empty Article
      throw ConnectionException(
          message: "Got wrong statuscode: ${response.statusCode}",
          type: ExceptionType.BAD_RESPONSE);
    }
  }

  @override
  Future<Employee> getElement(String elementId) {
    throw UnimplementedError();
  }
}
