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
      //checking if element is not header or footer of website
      if (parent[i].getElementsByClassName('icon-left').isNotEmpty) {
        if (parent[i].getElementsByClassName('icon-left')[0].innerHtml !=
            " Kontakt ") {
          //Parse data to article
          String content;
          String title;
          List<String> hyperlinks = List();
          List<String> bilder = List();
          title = parent[i].getElementsByClassName('icon-left')[0].innerHtml;
          // Delete first space in title
          title = title.substring(1);
          // check if content is in "news-teaser" or "bodytext class"
          if (parent[i].getElementsByClassName('news-teaser').isNotEmpty) {
            content =
                parent[i].getElementsByClassName('news-teaser')[0].innerHtml;
            if (content.contains("<br> ")) {
              //Einrückungen bei neuen Paragraph entfernen
              content = content.replaceAll("<br> ", "\n");
              content = content.replaceAll("<br>", "\n");
            }
          } else if (parent[i].getElementsByClassName('bodytext') != null) {
            final List<String> contentList = parent[i]
                .getElementsByClassName('bodytext')
                .map((elements) => elements.innerHtml)
                .toList();
            content = contentList.toString();
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
