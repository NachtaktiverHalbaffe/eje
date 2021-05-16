import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/ErrorArticle.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/errorArbeitsbereich.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/bak/domain/entitys/ErrorBAKler.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/errorHauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class WebScraper {
  //Scraping a Webpage amd parsing to an List of article
  Future<List<Article>> scrapeWebPage(String url) async {
    List<Article> article = List();
    const String DOMAIN = "https://www.eje-esslingen.de";
    const String ID_HEADER = 'c845041';
    const String ID_KONTAKT = 'c762177';
    const String ID_ANSCHRIFT = 'c762175';
    bool alreadyHasTitele = false;
    // Get data from Internet

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final parent = document.getElementsByClassName('col s12 default');
      for (int i = 0; i < parent.length; i++) {
        //checking if element is not header or footer of website
        if (parent[i].id != ID_KONTAKT) {
          if (parent[i].id != ID_HEADER) {
            if (parent[i].id != ID_ANSCHRIFT) {
              //Parse data to article
              String content = "";
              String title;
              List<Hyperlink> hyperlinks = List();
              List<String> bilder = List();
              // ! Title parsen
              if (parent[i].getElementsByClassName('icon-left').isNotEmpty) {
                if (parent[i]
                    .getElementsByClassName('icon-left')[0]
                    .getElementsByTagName("a")
                    .isEmpty) {
                  // Checking if article has already title, otherwise integrating it into content
                  if (!alreadyHasTitele) {
                    title =
                        parent[i].getElementsByClassName('icon-left')[0].text;
                    alreadyHasTitele = true;
                    title = title.substring(1);
                  } else
                    content = content +
                        parent[i].getElementsByClassName('icon-left')[0].text +
                        "\n\n";
                } else {
                  // Checking if article has already title, otherwise integrating it into content
                  if (!alreadyHasTitele) {
                    title = parent[i]
                        .getElementsByClassName('icon-left')[0]
                        .getElementsByTagName("a")[0]
                        .text;
                    title = title.substring(1);
                    alreadyHasTitele = true;
                  } else
                    content = content +
                        parent[i]
                            .getElementsByClassName('icon-left')[0]
                            .getElementsByTagName("a")[0]
                            .text +
                        "\n\n";
                }
                // Delete first space in title

              } else
                title = "";
              // ! Content parsen
              content = content + _parseContent(parent[i]);

              // ! pictures parsen
              //check if picture links are in "text-pic-right" or "width100 center marginBottom10" class
              if (parent[i]
                  .getElementsByClassName('text-pic-right')
                  .isNotEmpty) {
                //picture-link is in text-pic-right class
                bilder = parent[i]
                    .getElementsByClassName('text-pic-right')
                    .map((elements) =>
                        DOMAIN +
                        elements
                            .getElementsByTagName('img')[0]
                            .attributes['src'])
                    .toList();
              } else if (parent[i]
                  .getElementsByClassName("width100 center marginBottom10")
                  .isNotEmpty) {
                //picture source is in "width100 center marginBottom10" class
                bilder = parent[i]
                    .getElementsByClassName("width100 center marginBottom10")
                    .map((elements) =>
                        DOMAIN +
                        elements
                            .getElementsByTagName('img')[0]
                            .attributes['src'])
                    .toList();
              } else if (parent[i].getElementsByTagName("img").isNotEmpty) {
                //picture source is in "width100 center marginBottom10" class
                bilder = parent[i]
                    .getElementsByTagName("img")
                    .map((elements) => DOMAIN + elements.attributes['src'])
                    .toList();
              } else
                bilder.add("");
              // ! Hyperlinks parsen
              //check if hyperlinks is in parent or has another parent in document
              if (parent[i]
                  .getElementsByClassName("internal-link")
                  .isNotEmpty) {
                // hyperlinks are in existing parent class
                List<String> links = parent[i]
                    .getElementsByClassName('internal-link')
                    .map((elements) => elements.attributes['href'] != null
                        ? DOMAIN + elements.attributes['href']
                        : "")
                    .toList();
                List<String> description = parent[i]
                    .getElementsByClassName('internal-link')
                    .map((elements) => elements.text)
                    .toList();
                //map webscraped links and descriptions to hyperlinks
                for (int k = 0; k < links.length; k++) {
                  hyperlinks.add(
                      Hyperlink(link: links[k], description: description[k]));
                }
              }
              // Hyperlinks are links to external websites
              if (parent[i]
                  .getElementsByClassName("external-link-new-window")
                  .isNotEmpty) {
                // hyperlinks are in existing parent class
                List<String> links = parent[i]
                    .getElementsByClassName("external-link-new-window")
                    .map((elements) => elements.attributes['href'])
                    .toList();
                List<String> description = parent[i]
                    .getElementsByClassName("external-link-new-window")
                    .map((elements) => elements.text)
                    .toList();
                //map webscraped links and descriptions to hyperlinks
                for (int k = 0; k < links.length; k++) {
                  hyperlinks.add(
                      Hyperlink(link: links[k], description: description[k]));
                }
              }
              //check if hyperlinks are in a seperate special section
              if (document.getElementById('row h-bulldozer default') != null) {
                List<String> links = document
                    .getElementsByClassName('row h-bulldozer default')[0]
                    .getElementsByClassName(
                        'row ctype-text listtype-none showmobdesk-0')
                    .map((elements) =>
                        DOMAIN +
                        elements
                            .getElementsByClassName('internal-link')[0]
                            .innerHtml)
                    .toList();
                List<String> description = document
                    .getElementsByClassName('row h-bulldozer default')[0]
                    .getElementsByClassName(
                        'row ctype-text listtype-none showmobdesk-0')
                    .map((elements) => elements
                        .getElementsByClassName('internal-link')[0]
                        .attributes['href'])
                    .toList();
                //map webscraped links and descriptions to hyperlinks
                for (int k = 0; k < links.length; k++) {
                  hyperlinks.add(
                      Hyperlink(link: links[k], description: description[k]));
                }
              }
              if (document
                  .getElementsByClassName('collection-item row')
                  .isNotEmpty) {
                List<String> links = List();
                List<String> description = List();
                links.addAll(parent[i]
                    .getElementsByClassName('collection-item row')
                    .map((element) =>
                        DOMAIN +
                        element.getElementsByTagName('a')[0].attributes['href'])
                    .toList());
                description.addAll(parent[i]
                    .getElementsByClassName('collection-item row')
                    .map((element) => element
                        .getElementsByTagName('a')[0]
                        .attributes['title'])
                    .toList());

                for (int k = 0; k < links.length; k++) {
                  hyperlinks.add(
                      Hyperlink(link: links[k], description: description[k]));
                }
              }
              if (document.getElementsByClassName('download').isNotEmpty) {
                List<String> links = List();
                List<String> description = List();
                links.addAll(parent[i]
                    .getElementsByClassName('download')
                    .map((element) => DOMAIN + element.attributes['href'])
                    .toList());
                description.addAll(parent[i]
                    .getElementsByClassName('download')
                    .map((element) => element.text)
                    .toList());

                for (int k = 0; k < links.length; k++) {
                  hyperlinks.add(
                      Hyperlink(link: links[k], description: description[k]));
                }
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
              if (hyperlinks.isEmpty) {
                hyperlinks.add(Hyperlink(link: "", description: ""));
              }
              //add scraped Section to List of Articles
              article.add(Article(
                  url: url,
                  titel: title,
                  hyperlinks: hyperlinks,
                  bilder: bilder,
                  content: content.toString()));
            }
          }
        }
      }
      return article;
    } else {
      // No Internet connection, returning empty Article
      print("Error: No internet Connection");
      return [getErrorArticle()];
    }
  }

  Future<List<Hauptamtlicher>> scrapeHauptamliche() async {
    List<Hauptamtlicher> hauptamtliche = new List<Hauptamtlicher>();
    const String DOMAIN = "https://www.eje-esslingen.de";
    const String URL = DOMAIN + "/?id=246889";
    const String ID_HEADER = 'c845041';
    const String ID_KONTAKT = 'c762177';
    const String ID_ANSCHRIFT = 'c762175';
    // Get data from Internet
    var response = await http.get(Uri.parse(URL));
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
                hauptamtliche.add(new Hauptamtlicher(
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
      return [getErrorHauptamtlicher()];
    }
  }

  Future<List<BAKler>> scrapeBAKler() async {
    List<BAKler> bakler = new List<BAKler>();
    const String DOMAIN = "https://www.eje-esslingen.de";
    const String URL = DOMAIN + "/?id=246890";
    const String ID_HEADER = 'c845041';
    const String ID_KONTAKT = 'c762177';
    const String ID_ANSCHRIFT = 'c762175';
    // Get data from Internet
    var response = await http.get(Uri.parse(URL));
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
                  amt != "" ||
                  vorstellung != "" ||
                  email != "" ||
                  threema != "") {
                bakler.add(new BAKler(
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
      return [getErrorBAKler()];
    }
  }

  Future<List<Arbeitsbereich>> scrapeArbeitsbereiche() async {
    List<Arbeitsbereich> arbeitsbereiche = new List<Arbeitsbereich>();
    const String DOMAIN = "https://www.eje-esslingen.de";
    const String URL = DOMAIN + "/?id=246887";
    const String ID_HEADER = 'c845041';
    const String ID_KONTAKT = 'c762177';
    const String ID_ANSCHRIFT = 'c762175';
    // Get data from Internet
    var response = await http.get(Uri.parse(URL));
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
              List<String> bild = List<String>();
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
                arbeitsbereiche.add(new Arbeitsbereich(
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
      return [getErrorArbeitsbereich()];
    }
  }
}

//Parses content in order of appearing in parent class
String _parseContent(parent) {
  String content = "";
  for (int r = 0; r < parent.children.length; r++) {
    final child = parent.children[r];
    print(child.className);

    // check if content is in "news-teaser" or "bodytext class"
    if (child.className == 'news-teaser') {
      content = child.innerHtml;
    }
    if (child.className == 'bodytext') {
      if (!child.innerHtml.contains("<br>") ||
          child.getElementsByTagName('span').isNotEmpty) {
        content = content + child.text + "\n\n";
      } else if (child.getElementsByTagName('a').isEmpty)
        content = content + child.innerHtml + "\n\n";
    }
    // Content is in MSoNormal class, not often used
    if (child.className == 'MsoNormal') {
      for (int j = 0; j < child.getElementsByTagName('span').length; j++) {
        if (child.getElementsByTagName('span')[j].text != "-") {
          content = content + child.getElementsByTagName('span')[j].text + "\n";
        } else
          content = content + child.getElementsByTagName('span')[j].text + " ";
      }
    }
    //Auflistung mit speziellen Symbolen
    if (child.className == 'cms') {
      for (int j = 0; j < child.getElementsByTagName('li').length; j++) {
        String _parsed = child.getElementsByTagName('li')[j].text;
        if (!content.contains(_parsed)) {
          content = content + "• " + _parsed + "\n";
        }
      }
      content = content + "\n";
    }
    if (child.hasChildNodes()) {
      content = content + _parseContent(child);
    }
  }
  //check if current child has more children which have to been checked
  return content;
}
