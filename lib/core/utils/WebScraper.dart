// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, file_names
import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/field_of_work.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:html2md/html2md.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:html2md/html2md.dart' as html2md;

class WebScraper {
  //Scraping a Webpage amd parsing to an List of article
  Future<Article> scrapeWebPage(String url) async {
    Article article;
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String DOMAIN = appConfig.domain;
    final String ID_HEADER = appConfig.idHeader;
    final String ID_KONTAKT = appConfig.idContact;
    final String ID_ANSCHRIFT = appConfig.idAdress;

    // Get data from Internet
    var response;
    try {
      response = await http.get(Uri.parse(url));
    } catch (e) {
      throw ConnectionException();
    }
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final parent =
          document.getElementsByClassName('container standard default ');

      // Content that needs to be scraped
      String content = "";
      String title = "";
      List<Hyperlink> hyperlinks = List.empty(growable: true);
      List<String> bilder = List.empty(growable: true);

      // ! Hyperlink parsing
      try {
        List<Hyperlink> parsedHyperlinks = _parseHyperlinks(document, DOMAIN);
        hyperlinks.addAll(parsedHyperlinks);
      } catch (e) {
        print("Webscaper error: $e");
        // throw ServerException();
      }
      // ! pictures parsen
      try {
        List<String> parsedPictures = await _parsePictures(document, DOMAIN);
        bilder.addAll(parsedPictures);
      } catch (e) {
        print("Webscaper error: $e");
        throw ServerException();
      }

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
                // ! Title parsen
                if (parent[i].getElementsByClassName('icon-left').isNotEmpty) {
                  if (parent[i]
                      .getElementsByClassName('icon-left')[0]
                      .getElementsByTagName("a")
                      .isEmpty) {
                    // Checking if article has already title, otherwise integrating it into content
                    if (title == "") {
                      title =
                          parent[i].getElementsByClassName('icon-left')[0].text;
                      title = title.substring(1);
                    }
                  } else {
                    // Checking if article has already title, otherwise integrating it into content
                    if (title == "") {
                      title = parent[i]
                          .getElementsByClassName('icon-left')[0]
                          .getElementsByTagName("a")[0]
                          .text;
                      title = title.substring(1);
                    }
                  }
                }
                // ! Content parsen
                content = content +
                    html2md.convert(parent[i].innerHtml, rules: [
                      Rule(
                        'remove picture',
                        filterFn: (node) {
                          if (node.nodeName == 'img') {
                            return true;
                          }
                          return false;
                        },
                        replacement: (content, node) {
                          return ''; // remove picture
                        },
                      ),
                      Rule(
                        'fix links',
                        filterFn: (node) {
                          if (node.nodeName == 'a') {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        replacement: (content, node) {
                          var href = node.getAttribute('href');
                          var text = node.textContent;
                          if (href != null && href.isNotEmpty) {
                            if (!href.contains('http')) {
                              return '[$text](https://www.eje-esslingen.de$href)'; // build the link
                            }
                          }
                          return '';
                        },
                      ),
                      Rule(
                        'remove video',
                        filterFn: (node) {
                          if (node.className ==
                              'ce-media video clickslider-triggered') {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        replacement: (content, node) {
                          return "";
                        },
                      ),
                      Rule(
                        'remove internal links',
                        filterFn: (node) {
                          if (node.nodeName == "blockquote") {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        replacement: (content, node) {
                          return "";
                        },
                      ),
                      Rule(
                        'remove divider',
                        filterFn: (node) {
                          if (node.className == "divider") {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        replacement: (content, node) {
                          return "";
                        },
                      ),
                      Rule(
                        'remove iframe',
                        filterFn: (node) {
                          if (node.nodeName == 'iframe') {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        replacement: (content, node) {
                          return "";
                        },
                      )
                    ]);
                content = content.replaceAll("dontospamme", "");
                content = content.replaceAll("gowaway.", "");
                content = content.substring(content.indexOf('\n') + 1);
                content = content.substring(content.indexOf('=\n') + 1);
                content = "$content\n\n";
              }
            }
          }
        }
      }
      article = Article(
          url: url,
          titel: title,
          hyperlinks: hyperlinks,
          bilder: bilder,
          content: content.toString());
      return article;
    } else {
      // No Internet connection, returning empty Article
      print("Error: No internet Connection");
      throw ServerException();
    }
  }

  Future<List<Employee>> scrapeHauptamliche() async {
    List<Employee> hauptamtliche = List.empty(growable: true);
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String DOMAIN = appConfig.domain;
    final String URL = DOMAIN + appConfig.employeesEndpoint;
    final String ID_HEADER = appConfig.idHeader;
    final String ID_KONTAKT = appConfig.idContact;
    final String ID_ANSCHRIFT = appConfig.idAdress;

    // Get data from Internet
    var response;
    try {
      response = await http.get(Uri.parse(URL));
    } catch (e) {
      throw ConnectionException();
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
                          .replaceAll(
                              new RegExp(r"\D"), "") // remove all Letters
                          .trimLeft()
                          .trimRight();
                    } else if (element.text.contains('Diensthandy')) {
                      if (element.text.contains(":")) {
                        handy =
                            element.text.split(':')[1].trimLeft().trimRight();
                      } else {
                        handy = element.text
                            .replaceAll(
                                new RegExp(r"\D"), "") //remove all letters
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
      print("Error: No internet Connection");
      throw ConnectionException();
    }
  }

  Future<List<BAKler>> scrapeBAKler() async {
    List<BAKler> bakler = List.empty(growable: true);
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String DOMAIN = appConfig.domain;
    final String URL = DOMAIN + appConfig.bakEndpoint;
    final String ID_HEADER = appConfig.idHeader;
    final String ID_KONTAKT = appConfig.idContact;
    final String ID_ANSCHRIFT = appConfig.idAdress;

    // Get data from Internet
    var response;
    try {
      response = await http.get(Uri.parse(URL));
    } catch (e) {
      throw ConnectionException();
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
              String amt = "";
              String name = "";
              String bild = "";
              String email = "";
              String threema = "";
              // ! name parsen
              if (parent[i].getElementsByClassName('icon-left').isNotEmpty) {
                // get title
                String _title =
                    parent[i].getElementsByClassName('icon-left')[0].text;
                // Split title into name and amt
                List<String> splitTitle;
                splitTitle = _title.split(' - ');
                name = splitTitle[0].trimLeft().trimRight();
                if (splitTitle.length == 2) {
                  amt = splitTitle[1].trimLeft().trimRight();
                }
              }
              // ! Beschreibung parsen
              if (parent[i]
                  .getElementsByClassName(
                      'col s12 m8 l8 bildtextteaser-content halfpic')
                  .isNotEmpty) {
                parent[i].getElementsByClassName('bodytext').forEach((element) {
                  if (element.text.contains('Threema') |
                      element.getElementsByTagName('a').isNotEmpty) {
                    if (element.text.contains("ist:")) {
                      threema =
                          element.text.split('ist:')[1].trimLeft().trimRight();
                    } else {
                      threema = element.text.trimLeft().trimRight();
                      threema = threema.substring(threema.length - 8);
                    }

                    if (element.getElementsByTagName('a').isNotEmpty) {
                      email = element
                          .getElementsByTagName('a')[0]
                          .text
                          .replaceAll('dontospamme', '')
                          .replaceAll('gowaway.', '')
                          .trimLeft()
                          .trimRight();
                    }
                  } else if (element.text != "") {
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
      print("Error: No internet Connection");
      throw ConnectionException();
    }
  }

  Future<List<FieldOfWork>> scrapeArbeitsbereiche() async {
    List<FieldOfWork> arbeitsbereiche = List.empty(growable: true);
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String DOMAIN = appConfig.domain;
    final String URL = DOMAIN + appConfig.fieldOfWorkEndpoint;
    final String ID_HEADER = appConfig.idHeader;
    final String ID_KONTAKT = appConfig.idContact;
    final String ID_ANSCHRIFT = appConfig.idAdress;

    // Get data from Internet
    var response;
    try {
      response = await http.get(Uri.parse(URL));
    } catch (e) {
      throw ConnectionException();
    }
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final parent = document.getElementsByClassName('card link-area');
      for (int i = 0; i < parent.length; i++) {
        //checking if element is not header or footer of website
        if (parent[i].id != ID_KONTAKT) {
          if (parent[i].id != ID_HEADER) {
            if (parent[i].id != ID_ANSCHRIFT) {
              //Parse data to article
              String arbeitsbereich = "";
              List<String> bild = List.empty(growable: true);
              String url = "";
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
                bild.add(DOMAIN +
                    parent[i]
                        .getElementsByClassName('card-image')[0]
                        .getElementsByTagName('img')[0]
                        .attributes['src']!
                        .trimLeft()
                        .trimRight());
              }
              // ! link parsen
              if (parent[i].getElementsByClassName('card-action').isNotEmpty) {
                url = DOMAIN +
                    parent[i]
                        .getElementsByClassName('card-action')[0]
                        .getElementsByTagName('a')[0]
                        .attributes['href']!;
              }

              //add scraped Section to List of Articles
              if (arbeitsbereich != "" || bild.isNotEmpty || url != "") {
                arbeitsbereiche.add(FieldOfWork(
                  name: arbeitsbereich,
                  images: bild,
                  description: "",
                  link: url,
                ));
              }
            }
          }
        }
      }
      return arbeitsbereiche;
    } else {
      // No Internet connection, returning empty Article
      print("Error: No internet Connection");
      throw ConnectionException();
    }
  }

  Future<Service> scrapeServices(Service service) async {
    final appConfig = await AppConfig.loadConfig();
    final String DOMAIN = appConfig.domain;

    List<Hyperlink> hyperlinks = service.hyperlinks.sublist(0, 1);
    List<String> links = List.empty(growable: true);
    List<String> description = List.empty(growable: true);

    var response;
    try {
      response = await http.get(Uri.parse(service.hyperlinks[0].link));
    } catch (e) {
      throw ConnectionException();
    }
    if (response.statusCode == 200) {
      print("Services: Getting Data from Internet");
      dom.Document document = parser.parse(response.body);
      //Check if service is eje-info
      if (service.service == "eje-Info") {
        final parent = document.getElementsByClassName('collection-item row');
        if (hyperlinks.length > 1) {
          for (int i = 0; i < parent.length; i++) {
            bool isAlreadyInCache = false;
            for (int k = 0; k < hyperlinks.length; k++) {
              if ((DOMAIN +
                      parent[i]
                          .getElementsByTagName('a')[0]
                          .attributes['href']!) ==
                  hyperlinks[k].link) {
                isAlreadyInCache = true;
              }
            }
            if (!isAlreadyInCache) {
              links.add(DOMAIN +
                  parent[i].getElementsByTagName('a')[0].attributes['href']!);
              description.add(
                  parent[i].getElementsByTagName('a')[0].attributes['title']!);
            }
          }
        } else {
          links.addAll(parent
              .map((element) =>
                  DOMAIN +
                  element.getElementsByTagName('a')[0].attributes['href']!)
              .toList());
          description.addAll(parent
              .map((element) => element.getElementsByTagName('a')[0].innerHtml)
              .toList());
        }
        for (int k = 0; k < links.length; k++) {
          hyperlinks
              .add(Hyperlink(link: links[k], description: description[k]));
        }

        return Service(
            service: service.service,
            images: service.images,
            description: service.description,
            hyperlinks: hyperlinks);
      }
      //Service is a webpage which to webscrape
      else {
        Article _article =
            await WebScraper().scrapeWebPage(service.hyperlinks[0].link);
        List<String> bilder = service.images.sublist(0, 1);
        bilder.addAll(_article.bilder);
        List<Hyperlink> hyperlinks = service.hyperlinks.sublist(0, 1);
        hyperlinks.addAll(_article.hyperlinks);
        String content = service.description;

        if (_article.content.isNotEmpty) {
          if (!content.contains(_article.content)) {
            content = _article.content;
          }
        }
        if (bilder.length > 1) {
          bilder = bilder.sublist(1);
        }

        return Service(
          service: service.service,
          images: bilder,
          description:
              service.service == 'Verleih' ? service.description : content,
          hyperlinks: hyperlinks,
        );
      }
    } else {
      throw ConnectionException();
    }
  }
}

List<Hyperlink> _parseHyperlinks(document, DOMAIN) {
  List<Hyperlink> hyperlinks = List.empty(growable: true);

  // Check if there is a table with links
  if (document.getElementsByClassName('internal-link').isNotEmpty) {
    var rootNodes = document.getElementsByClassName('internal-link');
    for (int i = 0; i < rootNodes.length; i++) {
      String link = rootNodes[i].attributes['href'].toString();
      if (!link.contains("http")) {
        link = DOMAIN + link;
      }
      String text = rootNodes[i].text.toString();
      hyperlinks.add((Hyperlink(link: link, description: text)));
    }
  }

  if (document.getElementsByClassName('external-link-new-window').isNotEmpty) {
    var rootNodes = document.getElementsByClassName('external-link-new-window');
    for (int i = 0; i < rootNodes.length; i++) {
      String link = rootNodes[i].attributes['href'].toString();
      if (!link.contains("http")) {
        link = DOMAIN + link;
      }
      String text = rootNodes[i].text.toString();
      hyperlinks.add((Hyperlink(link: link, description: text)));
    }
  }

  if (document.getElementsByClassName('col s9').isNotEmpty) {
    var rootNodes = document.getElementsByClassName('col s9');
    for (int i = 0; i < rootNodes.length; i++) {
      String link = rootNodes[i]
          .getElementsByTagName('a')[0]
          .attributes['href']
          .toString();
      if (!link.contains("http")) {
        link = DOMAIN + link;
      }
      String text =
          rootNodes[i].getElementsByTagName('a')[0].innerHtml.toString();
      hyperlinks.add((Hyperlink(link: link, description: text)));
    }
  }
  return hyperlinks;
}

Future<List<String>> _parsePictures(document, DOMAIN) async {
  final AppConfig appConfig = await AppConfig.loadConfig();
  final String BANNER_PICTURE = appConfig.bannerPicture;
  final String CONTACT_PICTURE = appConfig.contactPicture;
  List bilder = List.empty(growable: true);

  if (document.getElementsByTagName('img').isNotEmpty) {
    bilder = document
        .getElementsByTagName('img')
        .map((elements) => DOMAIN + elements.attributes['src'].toString())
        .toList();
    // Remove static pictures which is globally on page
    bilder.removeWhere((element) => element == "$DOMAIN$BANNER_PICTURE");
    bilder.removeWhere((element) => element == "$DOMAIN$CONTACT_PICTURE");
  }
  return bilder.cast<String>();
}
