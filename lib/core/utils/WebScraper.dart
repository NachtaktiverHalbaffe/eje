import 'package:eje/core/platform/Article.dart';
import 'package:eje/core/platform/Hyperlink.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class WebScraper {
  //Scraping a Webpage amd parsing to an List of article
  Future<List<Article>> scrapeWebPage(String url) async {
    List<Article> article = List();
    const String DOMAIN = "https://www.eje-esslingen.de";
    // Get data from Internet
    var response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    final parent = document.getElementsByClassName('col s12 default');
    for (int i = 0; i < parent.length; i++) {
      //checking if element is not header or footer of website
      if (parent[i].id != 'c762177') {
        if (parent[i].id != 'c845041') {
          print(parent[i].id);
          //Parse data to article
          String content = "";
          String title;
          List<Hyperlink> hyperlinks = List();
          List<String> bilder = List();
          // ! Title parsen
          if (parent[i].getElementsByClassName('icon-left').isNotEmpty) {
            if (parent[i].getElementsByClassName('icon-left')[0].innerHtml !=
                " Kontakt ") {
              if (parent[i]
                  .getElementsByClassName('icon-left')[0]
                  .getElementsByTagName("a")
                  .isEmpty) {
                title =
                    parent[i].getElementsByClassName('icon-left')[0].innerHtml;
              } else {
                title = parent[i]
                    .getElementsByClassName('icon-left')[0]
                    .getElementsByTagName("a")[0]
                    .innerHtml;
              }
              // Delete first space in title
              title = title.substring(1);
            }
          }
          // ! Content parsen
          // check if content is in "news-teaser" or "bodytext class"
          if (parent[i].getElementsByClassName('news-teaser').isNotEmpty) {
            content =
                parent[i].getElementsByClassName('news-teaser')[0].innerHtml;
          } else if (parent[i].getElementsByClassName('bodytext').isNotEmpty) {
            for (int k = 0;
                k < parent[i].getElementsByClassName('bodytext').length;
                k++) {
              if (parent[i]
                  .getElementsByClassName('bodytext')[k]
                  .getElementsByTagName('a')
                  .isEmpty) {
                content = content +
                    parent[i].getElementsByClassName('bodytext')[k].innerHtml +
                    "\n\n";
              }
            }
          } else if (parent[i].getElementsByClassName('MsoNormal').isNotEmpty) {
            //TODO Fix webscraping für komisches msonormal
            for (int k = 0;
                k < parent[i].getElementsByClassName('MsoNormal').length;
                k++) {
              for (int j = 0;
                  j <
                      parent[i]
                          .getElementsByClassName('MsoNormal')[k]
                          .getElementsByTagName('span')
                          .length;
                  j++) {
                if (!parent[i]
                    .getElementsByClassName('MsoNormal')[k]
                    .getElementsByTagName('span')[j]
                    .innerHtml
                    .contains("font")) {
                  content = content +
                      parent[i]
                          .getElementsByClassName('MsoNormal')[k]
                          .getElementsByTagName('span')[j]
                          .innerHtml;
                }
              }
            }
          } else
            content = "";
          // ! pictures parsen
          //check if picture links are in "text-pic-right" or "width100 center marginBottom10" class
          if (parent[i].getElementsByClassName('text-pic-right').isNotEmpty) {
            //picture-link is in text-pic-right class
            bilder = parent[i]
                .getElementsByClassName('text-pic-right')
                .map((elements) =>
                    DOMAIN +
                    elements.getElementsByTagName('img')[0].attributes['src'])
                .toList();
          } else if (parent[i]
              .getElementsByClassName("width100 center marginBottom10")
              .isNotEmpty) {
            //picture source is in "width100 center marginBottom10" class
            bilder = parent[i]
                .getElementsByClassName("width100 center marginBottom10")
                .map((elements) =>
                    DOMAIN +
                    elements.getElementsByTagName('img')[0].attributes['src'])
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
          if (parent[i].getElementsByClassName("internal-link").isNotEmpty) {
            // hyperlinks are in existing parent class
            List<String> links = parent[i]
                .getElementsByClassName('internal-link')
                .map((elements) => DOMAIN + elements.attributes['href'])
                .toList();
            List<String> description = parent[i]
                .getElementsByClassName('internal-link')
                .map((elements) => DOMAIN + elements.innerHtml)
                .toList();
            //map webscraped links and descriptions to hyperlinks
            for (int k = 0; k < links.length; k++) {
              hyperlinks
                  .add(Hyperlink(link: links[k], description: description[k]));
            }
          } else if (document.getElementById('row h-bulldozer default') !=
              null) {
            //hyperlinks are in another parent class
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
                .map((elements) =>
                    DOMAIN +
                    elements
                        .getElementsByClassName('internal-link')[0]
                        .attributes['href'])
                .toList();
            //map webscraped links and descriptions to hyperlinks
            for (int k = 0; k < links.length; k++) {
              hyperlinks
                  .add(Hyperlink(link: links[k], description: description[k]));
            }
          } else
            hyperlinks.add(Hyperlink(link: "", description: ""));

          // ! Formatting if needed
          //Einrückungen bei neuen Paragraph entfernen
          if (content.contains("<br>")) {
            content = content.replaceAll("<br> ", "\n");
            content = content.replaceAll("<br>", "\n");
          }
          //HTML-Formatierungszeichen bei neuen Paragraph entfernen
          if (content.contains("&nbsp;")) {
            content = content.replaceAll("&nbsp;", " ");
          }
          content = content + "\n\n";

          article.add(Article(
              url: url,
              titel: title,
              hyperlinks: hyperlinks,
              bilder: bilder,
              content: content.toString()));
        }
      }
    }
    return article;
  }
}
