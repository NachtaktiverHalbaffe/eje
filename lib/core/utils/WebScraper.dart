// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables
import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class WebScraper {
  //Scraping a Webpage amd parsing to an List of article
  Future<Article> scrapeWebPage(String url) async {
    print(url);
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
      final parent = document.getElementsByClassName('col s12 default');
      // Content that needs to be scraped
      String content = "";
      String title = "";
      List<Hyperlink> hyperlinks = List.empty(growable: true);
      List<String> bilder = List.empty(growable: true);
      for (int i = 0; i < parent.length; i++) {
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
                    } else {
                      content = content +
                          "\n## " +
                          parent[i]
                              .getElementsByClassName('icon-left')[0]
                              .text +
                          "\n\n";
                    }
                  } else {
                    // Checking if article has already title, otherwise integrating it into content
                    if (title == "") {
                      title = parent[i]
                          .getElementsByClassName('icon-left')[0]
                          .getElementsByTagName("a")[0]
                          .text;
                      title = title.substring(1);
                    } else {
                      content += "\n## " +
                          parent[i]
                              .getElementsByClassName('icon-left')[0]
                              .getElementsByTagName("a")[0]
                              .text +
                          "\n\n";
                    }
                  }
                }
                // ! Content parsen
                content = content + _parseContent(parent[i], DOMAIN);
                // ! pictures parsen
                bilder.addAll(_parsePictures(parent[i], DOMAIN));

                content = content + "\n\n";
                // ! Hyperlink parsing
                if (i == 1) {
                  hyperlinks.addAll(_parseHyperlinks(document, DOMAIN));
                }
                //Default values if no hyperlinks are scraped
                if (hyperlinks.isEmpty) {
                  hyperlinks.add(Hyperlink(link: "", description: ""));
                }
                //add scraped Section to List of Articles

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
      throw ConnectionException();
    }
  }

  Future<List<Hauptamtlicher>> scrapeHauptamliche() async {
    List<Hauptamtlicher> hauptamtliche = List.empty(growable: true);
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
                      telefon = element.text.trimLeft().trimRight();
                    } else if (element.text.contains('Diensthandy')) {
                      handy = element.text.split(':')[1].trimLeft().trimRight();
                    } else if (element.text.contains('Threema')) {
                      threema = element.text
                          .split('unter:')[1]
                          .trimLeft()
                          .trimRight();
                    } else if (element.getElementsByTagName('a').isNotEmpty) {
                      email = element
                          .getElementsByTagName('a')[0]
                          .text
                          .replaceAll('dontospamme', '')
                          .replaceAll('gowaway.', '')
                          .trimLeft()
                          .trimRight();
                    } else if (element.text != "") {
                      vorstellung = vorstellung +
                          element.text.trimLeft().trimRight() +
                          "\n";
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
                        .attributes['src']
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
                        .attributes['src']
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
              content = content + "\n\n";
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
                hauptamtliche.add(Hauptamtlicher(
                    bild: bild,
                    name: name,
                    bereich: bereich,
                    vorstellung: vorstellung,
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
                splitTitle = _title.split('-');
                name = splitTitle[0].trimLeft().trimRight();
                if (splitTitle.length == 2) {
                  amt = splitTitle[1].trimLeft().trimRight();
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
                    if (element.text.contains('Threema')) {
                      threema = element.text
                          .split('Mein Threema-ID ist:')[1]
                          .trimLeft()
                          .trimRight();
                    } else if (element.getElementsByTagName('a').isNotEmpty) {
                      email = element
                          .getElementsByTagName('a')[0]
                          .text
                          .replaceAll('dontospamme', '')
                          .replaceAll('gowaway.', '')
                          .trimLeft()
                          .trimRight();
                    } else if (element.text != "") {
                      vorstellung = vorstellung + element.text.trim() + "\n\n";
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
                        .attributes['src']
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
                        .attributes['src']
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
              content = content + "\n\n";
              //Default values if no hyperlinks are scraped

              //add scraped Section to List of Articles
              if (name != "" ||
                  bild != "" ||
                  amt != "" ||
                  vorstellung != "" ||
                  email != "" ||
                  threema != "") {
                bakler.add(BAKler(
                    bild: bild,
                    name: name,
                    amt: amt,
                    vorstellung: vorstellung,
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
                        .attributes['src']
                        .trimLeft()
                        .trimRight());
              }
              // ! link parsen
              if (parent[i].getElementsByClassName('card-action').isNotEmpty) {
                url = DOMAIN +
                    parent[i]
                        .getElementsByClassName('card-action')[0]
                        .getElementsByTagName('a')[0]
                        .attributes['href'];
              }

              //add scraped Section to List of Articles
              if (arbeitsbereich != "" || bild.isNotEmpty || url != "") {
                arbeitsbereiche.add(FieldOfWork(
                  arbeitsfeld: arbeitsbereich,
                  bilder: bild,
                  inhalt: "",
                  url: url,
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
      if (document.getElementsByClassName('collection-item row').isNotEmpty) {
        final parent = document.getElementsByClassName('collection-item row');
        if (hyperlinks.length > 1) {
          for (int i = 0; i < parent.length; i++) {
            bool isAlreadyInCache = false;
            for (int k = 0; k < hyperlinks.length; k++) {
              if ((DOMAIN +
                      parent[i]
                          .getElementsByTagName('a')[0]
                          .attributes['href']) ==
                  hyperlinks[k].link) {
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
              .map((element) => element.getElementsByTagName('a')[0].innerHtml)
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
        Article _article =
            await WebScraper().scrapeWebPage(service.hyperlinks[0].link);
        List<String> bilder = service.bilder.sublist(0, 1);
        bilder.addAll(_article.bilder);
        List<Hyperlink> hyperlinks = service.hyperlinks.sublist(0, 1);
        hyperlinks.addAll(_article.hyperlinks);
        String content = service.inhalt;
        if (_article.content.isNotEmpty) {
          if (!content.contains(_article.content)) {
            content = _article.content;
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
      throw ConnectionException();
    }
  }
}

//Parses content in order of appearing in parent class
String _parseContent(parent, DOMAIN) {
  String content = "";
  for (int r = 0; r < parent.children.length; r++) {
    final child = parent.children[r];
    var parsed = child.text;

    // Remove Hyperlinks from content
    if (child.localName == "blockquote") {
      continue;
    } else if (child.getElementsByTagName("blockquote").isNotEmpty) {
      continue;
    }
    // Remove Heading if heading is in text
    if (child.getElementsByClassName("card-title icon-left ").isNotEmpty) {
      for (int i = 0;
          i < child.getElementsByClassName("card-title icon-left ").length;
          i++) {
        final heading =
            child.getElementsByClassName("card-title icon-left ")[i].text;
        parsed = parsed.replaceFirst(heading, "\n## " + heading + "\n");
      }
    } else if (child.className == 'icon-left') {
      parsed = "";
      continue;
    } else if (child.className == 'icon-left ') {
      parsed = "";
      continue;
    } else if (child.getElementsByClassName('icon-left ').isNotEmpty) {
      for (int i = 0;
          i < child.getElementsByClassName('icon-left ').length;
          i++) {
        final heading = child.getElementsByClassName('icon-left ')[i].text;
        parsed = parsed.replaceAll(heading, "");
      }
    }

    // Making Parapgraphs
    if (child.getElementsByClassName('card-action').isNotEmpty) {
      for (int i = 0;
          i < child.getElementsByClassName('card-action').length;
          i++) {
        final bodyText = child.getElementsByClassName('card-action')[i].text;
        parsed = parsed.replaceAll(bodyText, bodyText + "\n\n");
      }
    } else if (child.getElementsByClassName('bodytext').isNotEmpty) {
      for (int i = 0;
          i < child.getElementsByClassName('bodytext').length;
          i++) {
        final bodyText = child.getElementsByClassName('bodytext')[i].text;
        parsed = parsed.replaceAll(bodyText, bodyText + "\n\n");
      }
    }

    // Hyperlinks
    if (child.getElementsByTagName('a').isNotEmpty) {
      if (child.getElementsByTagName('a')[0].attributes['href'].contains("/")) {
        for (int index = 0;
            index < child.getElementsByTagName('a').length;
            index++) {
          // Check if link was already parsed to avoid links nested inside links
          if (!parsed.contains(
              "[" + child.getElementsByTagName('a')[index].text + "]")) {
            parsed = parsed.replaceAll(
                child.getElementsByTagName('a')[index].text,
                !child
                        .getElementsByTagName('a')[index]
                        .attributes['href']
                        .contains("http")
                    ? "[" +
                        child.getElementsByTagName('a')[index].text.trim() +
                        "]" +
                        "(" +
                        DOMAIN +
                        child
                            .getElementsByTagName('a')[index]
                            .attributes['href'] +
                        ")"
                    : "[" +
                        child.getElementsByTagName('a')[index].text.trim() +
                        "]" +
                        "(" +
                        child
                            .getElementsByTagName('a')[index]
                            .attributes['href'] +
                        ")");
          }
        }
      }
    }

    // Listing Points
    if (child.getElementsByTagName('li').isNotEmpty) {
      for (int i = 0; i < child.getElementsByTagName('li').length; i++) {
        final listingPoint = child.getElementsByTagName('li')[i].text;
        parsed = parsed.replaceAll(listingPoint, "\n\n- " + listingPoint);
      }
    } else if (child.localName == "li") {
      parsed = "\n\n- " + parsed;
    } else if (parsed.contains("•")) {
      parsed = parsed.replaceAll("•", "\n\n- ");
    }

    // bold text
    if (child.getElementsByTagName('strong').isNotEmpty) {
      for (int i = 0; i < child.getElementsByTagName('strong').length; i++) {
        final boldText = child.getElementsByTagName('strong')[i].text;
        parsed = parsed.replaceAll(boldText, "**" + boldText.trim() + "**");
      }
    } // bold heading
    else if (child.localName == "p") {
      if (child.getElementsByTagName('strong').isNotEmpty) {
        parsed = parsed.replaceFirst(parsed, "**" + parsed.trim() + "**");
      }
    }

    // Italic
    if (child.getElementsByTagName('em').isNotEmpty) {
      for (int i = 0; i < child.getElementsByTagName('em').length; i++) {
        final italicText = child.getElementsByTagName('em')[i].text;
        parsed = parsed.replaceFirst(italicText, "*" + italicText.trim() + "*");
      }
    }

    // Heading
    if (child.localName == "h3" || child.localName == "h2") {
      if (parsed.length != 1) {
        parsed = "\n## " + parsed.trim() + "\n";
      }
    }
    // if (child.getElementsByTagName("h3").isNotEmpty) {
    //   for (int i = 0; i < child.getElementsByTagName("h3").length; i++) {
    //     final heading = child.getElementsByTagName("h3")[i].text;
    //     parsed = parsed.replaceFirst(heading, "\n## " + heading.trim() + "\n");
    //   }
    // }
    if (child.getElementsByTagName("h2").isNotEmpty) {
      for (int i = 0; i < child.getElementsByTagName("h2").length; i++) {
        final heading = child.getElementsByTagName("h2")[i].text;
        parsed = parsed.replaceFirst(heading, "\n## " + heading.trim() + "\n");
      }
    }

    // Do Formatting
    if (parsed.contains("dontospamme")) {
      parsed = parsed.replaceAll("dontospamme", "");
    }
    if (parsed.contains("gowaway.")) {
      parsed = parsed.replaceAll("gowaway.", "");
    }
    if (child.getElementsByClassName("description").isNotEmpty) {
      for (int i = 0;
          i < child.getElementsByClassName("description").length;
          i++) {
        final italicText = child.getElementsByClassName("description")[i].text;
        parsed = parsed.replaceAll(italicText, "");
      }
    }
    if (child.getElementsByTagName("script").isNotEmpty) {
      for (int i = 0; i < child.getElementsByTagName("script").length; i++) {
        final javascripts = child.getElementsByTagName("script")[i].text;
        parsed = parsed.replaceAll(javascripts, "");
      }
    }

    content += parsed.trim() + "\n\n";
  }

  return content;
}

List<Hyperlink> _parseHyperlinks(document, DOMAIN) {
  List<Hyperlink> hyperlinks = List.empty(growable: true);
  // ! Hyperlinks parsen
  //check if hyperlinks are in a seperate special section
  if (document.getElementsByClassName('row h-bulldozer default').isNotEmpty) {
    if (document
        .getElementsByClassName('row h-bulldozer default')[0]
        .getElementsByClassName('row ctype-text listtype-none showmobdesk-0')
        .isNotEmpty) {
      if (document
          .getElementsByClassName('row h-bulldozer default')[0]
          .getElementsByClassName(
              'row ctype-text listtype-none showmobdesk-0')[0]
          .getElementsByClassName('internal-link')
          .isNotEmpty) {
        List links = document
            .getElementsByClassName('row h-bulldozer default')[0]
            .getElementsByClassName(
                'row ctype-text listtype-none showmobdesk-0')
            .map((elements) =>
                DOMAIN +
                elements
                    .getElementsByClassName('internal-link')[0]
                    .attributes['href']
                    .toString())
            .toList();
        List description = document
            .getElementsByClassName('row h-bulldozer default')[0]
            .getElementsByClassName(
                'row ctype-text listtype-none showmobdesk-0')
            .map((elements) =>
                elements.getElementsByClassName('internal-link')[0].text)
            .toList();
        //map webscraped links and descriptions to hyperlinks
        for (int k = 0; k < links.length; k++) {
          hyperlinks
              .add(Hyperlink(link: links[k], description: description[k]));
        }
      }
    }
  }
  // Check if there is a table with links
  if (document.getElementsByClassName('collection-item row').isNotEmpty) {
    List<String> links;
    List<String> description;
    links.addAll(document
        .getElementsByClassName('collection-item row')
        .map((element) =>
            DOMAIN + element.getElementsByTagName('a')[0].attributes['href'])
        .toList());
    description.addAll(document
        .getElementsByClassName('collection-item row')
        .map((element) =>
            element.getElementsByTagName('a')[0].attributes['title'])
        .toList());

    for (int k = 0; k < links.length; k++) {
      hyperlinks.add(Hyperlink(link: links[k], description: description[k]));
    }
  }

  return hyperlinks;
}

List<String> _parsePictures(parent, DOMAIN) {
  List bilder = List.empty(growable: true);
  //check if picture links are in "text-pic-right" or "width100 center marginBottom10" class
  if (parent.getElementsByClassName('text-pic-right').isNotEmpty) {
    //picture-link is in text-pic-right class
    bilder = parent
        .getElementsByClassName('text-pic-right')
        .map((elements) =>
            DOMAIN +
            elements
                .getElementsByTagName('img')[0]
                .attributes['src']
                .toString())
        .toList();
  } else if (parent
      .getElementsByClassName("width100 center marginBottom10")
      .isNotEmpty) {
    //picture source is in "width100 center marginBottom10" class
    bilder = parent
        .getElementsByClassName("width100 center marginBottom10")
        .map((elements) =>
            DOMAIN +
            elements
                .getElementsByTagName('img')[0]
                .attributes['src']
                .toString())
        .toList();
  } else if (parent.getElementsByTagName("img").isNotEmpty) {
    //picture source is in "width100 center marginBottom10" class
    bilder = parent
        .getElementsByTagName("img")
        .map((elements) => DOMAIN + elements.attributes['src'].toString())
        .toList();
  }

  return bilder.cast<String>();
}
