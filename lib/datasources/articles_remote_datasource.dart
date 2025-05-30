import 'package:eje/app_config.dart';
import 'package:eje/datasources/webscraper_remote_datasource.dart';
import 'package:eje/models/article.dart';
import 'package:eje/models/hyperlink.dart';
import 'package:eje/models/exception.dart';
import 'package:html/dom.dart';
import 'package:html2md/html2md.dart';
import 'package:html2md/html2md.dart' as html2md;

class ArticlesRemoteDatasource extends WebScraperRemoteDatasource<Article> {
  ArticlesRemoteDatasource({required super.client});

  @override
  Future<Article> scrapeWebElements(List<Element> hmtlElements) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String domain = appConfig.domain;

    Article article;
    String content = "";
    String title = "";
    List<Hyperlink> hyperlinks = List.empty(growable: true);
    List<String> bilder = List.empty(growable: true);

    // ! Hyperlink parsing
    try {
      List<Hyperlink> parsedHyperlinks =
          _parseHyperlinks(this.document, domain);
      hyperlinks.addAll(parsedHyperlinks);
    } catch (e) {
      print("Webscaper error: $e");
      // throw ServerException();
    }
    // ! pictures parsen
    try {
      List<String> parsedPictures = await _parsePictures(this.document, domain);
      bilder.addAll(parsedPictures);
    } catch (e) {
      print("Webscaper error: $e");
      throw ServerException();
    }

    for (int i = 0; i < hmtlElements.length; i++) {
      // ! Title parsen
      if (hmtlElements[i].getElementsByTagName("h2").isNotEmpty) {
        // Checking if article has already title, otherwise integrating it into content
        if (title == "") {
          title = hmtlElements[i].getElementsByTagName("h2").first.text.trim();
        } else {
          // Checking if article has already title, otherwise integrating it into content
          if (title == "") {
            title =
                hmtlElements[i].getElementsByTagName("h2").first.text.trim();
          }
        }
      }
      // ! Content parsen
      content = content +
          html2md.convert(hmtlElements[i].innerHtml, rules: [
            Rule('h1',
                filterFn: (node) {
                  if (node.nodeName == 'h1') {
                    return true;
                  }
                  return false;
                },
                replacement: (content, node) => "# $content"),
            Rule('h2',
                filterFn: (node) {
                  if (node.nodeName == 'h2') {
                    return true;
                  }
                  return false;
                },
                replacement: (content, node) => "## $content"),
            Rule('h3',
                filterFn: (node) {
                  if (node.nodeName == 'h3') {
                    return true;
                  }
                  return false;
                },
                replacement: (content, node) => "### $content"),
            Rule('h4',
                filterFn: (node) {
                  if (node.nodeName == 'h4') {
                    return true;
                  }
                  return false;
                },
                replacement: (content, node) => "#### $content"),
            Rule('h5',
                filterFn: (node) {
                  if (node.nodeName == 'h5') {
                    return true;
                  }
                  return false;
                },
                replacement: (content, node) => "##### $content"),
            Rule('h6',
                filterFn: (node) {
                  if (node.nodeName == 'h6') {
                    return true;
                  }
                  return false;
                },
                replacement: (content, node) => "###### $content"),
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
                if (node.className == 'ce-media video clickslider-triggered') {
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
      content = content.replaceAll("--", "");
      content = content.replaceAll("dontospamme", "");
      content = content.replaceAll("gowaway.", "");

      if (content.contains(title)) {
        content = content.substring(content.indexOf(title) + title.length);
      }
      content = "$content\n\n";
    }
    article = Article(
        url: this.url,
        titel: title,
        hyperlinks: hyperlinks,
        bilder: bilder,
        content: content.toString());
    return article;
  }

  Future<List<String>> _parsePictures(Document document, String domain) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String bannerPicture = appConfig.bannerPicture;
    final String contactPicture = appConfig.contactPicture;
    List bilder = List.empty(growable: true);

    if (document.getElementsByTagName('img').isNotEmpty) {
      bilder = document
          .getElementsByTagName('img')
          .map((elements) => domain + elements.attributes['src'].toString())
          .toList();
      // Remove static pictures which is globally on page
      bilder.removeWhere((element) => element == "$domain$bannerPicture");
      bilder.removeWhere((element) => element == "$domain$contactPicture");
      bilder.removeWhere((element) => (element as String).contains("_assets"));
    }
    return bilder.cast<String>();
  }

  List<Hyperlink> _parseHyperlinks(Document document, String domain) {
    List<Hyperlink> hyperlinks = List.empty(growable: true);

    // Check if there is a table with links
    if (document.getElementsByClassName('internal-link').isNotEmpty) {
      var rootNodes = document.getElementsByClassName('internal-link');
      for (int i = 0; i < rootNodes.length; i++) {
        String link = rootNodes[i].attributes['href'].toString();
        if (!link.contains("http")) {
          link = domain + link;
        }
        String text = rootNodes[i].text.toString();
        hyperlinks.add((Hyperlink(link: link, description: text)));
      }
    }

    if (document
        .getElementsByClassName('external-link-new-window')
        .isNotEmpty) {
      var rootNodes =
          document.getElementsByClassName('external-link-new-window');
      for (int i = 0; i < rootNodes.length; i++) {
        String link = rootNodes[i].attributes['href'].toString();
        if (!link.contains("http")) {
          link = domain + link;
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
          link = domain + link;
        }
        String text =
            rootNodes[i].getElementsByTagName('a')[0].innerHtml.toString();
        hyperlinks.add((Hyperlink(link: link, description: text)));
      }
    }
    return hyperlinks;
  }
}
