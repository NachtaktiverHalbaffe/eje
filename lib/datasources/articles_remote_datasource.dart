import 'package:eje/app_config.dart';
import 'package:eje/datasources/remote_data_source.dart';
import 'package:eje/models/article.dart';
import 'package:eje/models/hyperlink.dart';
import 'package:eje/models/exception.dart';
import 'package:html/dom.dart';
import 'package:html2md/html2md.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:html2md/html2md.dart' as html2md;
import 'package:http/http.dart';

class ArticlesRemoteDatasource implements RemoteDataSource<Article, String> {
  final Client client;

  ArticlesRemoteDatasource({required this.client});

  @override
  Future<Article> getElement(String elementId) async {
    Article article;
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String domain = appConfig.domain;
    final String idHeader = appConfig.idHeader;
    final String idContact = appConfig.idContact;
    final String idFooter = appConfig.idAdress;

    // Get data from Internet
    Response response;
    try {
      response = await client.get(Uri.parse(elementId));
    } catch (e) {
      throw ConnectionException(
          message: "Couldnt load url $elementId", type: ExceptionType.notFound);
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
        List<Hyperlink> parsedHyperlinks = _parseHyperlinks(document, domain);
        hyperlinks.addAll(parsedHyperlinks);
      } catch (e) {
        print("Webscaper error: $e");
        // throw ServerException();
      }
      // ! pictures parsen
      try {
        List<String> parsedPictures = await _parsePictures(document, domain);
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
        if (parent[i].id != idContact) {
          if (parent[i].id != idHeader) {
            if (parent[i].id != idFooter) {
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
          url: elementId,
          titel: title,
          hyperlinks: hyperlinks,
          bilder: bilder,
          content: content.toString());
      return article;
    } else {
      // No Internet connection, returning empty Article
      print("Error: No internet Connection");
      throw ConnectionException(
          message: "Got bad statuscode ${response.statusCode}",
          type: ExceptionType.badRequest);
    }
  }

  @override
  Future<List<Article>> getAllElements() async {
    throw UnimplementedError();
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
