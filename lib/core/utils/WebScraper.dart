import 'package:eje/core/platform/Article.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class WebScraper {
  //Scraping a Webpage amd parsing to an List of article
  Future<List<Article>> scrapeWebPage(String url) async {
    List<Article> article;
    // Get data from Internet
    var response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    final parent = document.getElementsByClassName('col s12 default');
    for (int i = 0; i < parent.length; i++) {
      //Parse data to article
      String content;
      String title;
      List<String> hyperlinks;
      List<String> bilder;
      title = parent[i].getElementsByClassName('icon-left')[0].innerHtml;
      // check if content is in "news-teaser" or "bodytext class"
      if (parent[i].getElementsByClassName('news-teaser')[0].innerHtml !=
          null) {
        content = parent[i].getElementsByClassName('news-teaser')[0].innerHtml;
      } else if (parent[i].getElementsByClassName('bodytext')[0].innerHtml !=
          null) {
        final List<String> contentList = parent[i]
            .getElementsByClassName('bodytext')
            .map((elements) => elements.innerHtml)
            .toList();
        content = contentList.toString();
      } else
        content = "";
      //check if picture links are in "text-pic-right" or "width100 center marginBottom10" class
      if (parent[i].getElementsByClassName('text-pic-right')[0] != null) {
        //picture-link is in text-pic-right class
        bilder = parent[i]
            .getElementsByClassName('text-pic-right')
            .map((elements) =>
                elements.getElementsByTagName('img')[0].attributes['src'])
            .toList();
      } else if (parent[i]
              .getElementsByClassName("width100 center marginBottom10")[0] !=
          null) {
        //picture source is in "width100 center marginBottom10" class
        bilder = parent[i]
            .getElementsByClassName("width100 center marginBottom10")
            .map((elements) =>
                elements.getElementsByTagName('img')[0].attributes['src'])
            .toList();
      } else
        bilder.add("");

      //check if hyperlinks is in parent or has another parent in document
      if (parent[i].getElementsByClassName("internal-link")[0].innerHtml !=
          null) {
        // hyperlinks are in existing parent class
        hyperlinks = parent[i]
            .getElementsByClassName('internal-link')
            .map((elements) => elements.attributes['href'])
            .toList();
      } else if (document.getElementById('row h-bulldozer default') != null) {
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
    return article;
  }
}
