import 'package:eje/core/platform/Article.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class WebScraper {
  //Scraping a Webpage amd parsing to an List of article
  Future<List<Article>> scrapeWebPage(String url) async {
    List<Article> article = List();
    // Get data from Internet
    var response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    final parent = document.getElementsByClassName('col s12 default');
    for (int i = 0; i < parent.length; i++) {
      if (parent[i].id == 'c762177') print("Gotcha!");
      if (parent[i].id == 'c845041') print("Gotcha!");
      //checking if element is not header or footer of website
      if (parent[i].id != 'c762177') {
        if (parent[i].id != 'c845041') {
          print(parent[i].id);
          //Parse data to article
          String content = "";
          String title;
          List<String> hyperlinks = List();
          List<String> bilder = List();
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
            final List<String> contentList = parent[i]
                .getElementsByClassName('MsoNormal')
                .map((elements) =>
                    elements.getElementsByTagName('span')[0].outerHtml)
                .toList();
            content = contentList.toString();
          } else
            content = "";
          //check if picture links are in "text-pic-right" or "width100 center marginBottom10" class
          if (parent[i].getElementsByClassName('text-pic-right').isNotEmpty) {
            //picture-link is in text-pic-right class
            bilder = parent[i]
                .getElementsByClassName('text-pic-right')
                .map((elements) =>
                    "https://www.eje-esslingen.de/" +
                    elements.getElementsByTagName('img')[0].attributes['src'])
                .toList();
          } else if (parent[i]
              .getElementsByClassName("width100 center marginBottom10")
              .isNotEmpty) {
            //picture source is in "width100 center marginBottom10" class
            bilder = parent[i]
                .getElementsByClassName("width100 center marginBottom10")
                .map((elements) =>
                    "https://www.eje-esslingen.de/" +
                    elements.getElementsByTagName('img')[0].attributes['src'])
                .toList();
          } else if (parent[i].getElementsByTagName("img").isNotEmpty) {
            //picture source is in "width100 center marginBottom10" class
            bilder = parent[i]
                .getElementsByTagName("img")
                .map((elements) =>
                    "https://www.eje-esslingen.de/" +
                    elements.attributes['src'])
                .toList();
          } else
            bilder.add("");
          //check if hyperlinks is in parent or has another parent in document
          if (parent[i].getElementsByClassName("internal-link").isNotEmpty) {
            // hyperlinks are in existing parent class
            hyperlinks = parent[i]
                .getElementsByClassName('internal-link')
                .map((elements) => elements.attributes['href'])
                .toList();
          } else if (document.getElementById('row h-bulldozer default') !=
              null) {
            //hyperlinks are in another parent class
            hyperlinks = document
                .getElementById('row h-bulldozer default')
                .getElementsByClassName(
                    'row ctype-text listtype-none showmobdesk-0')
                .map((elements) => elements
                    .getElementsByClassName('internal-link')[0]
                    .attributes['href'])
                .toList();
          } else
            hyperlinks.add("");
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
