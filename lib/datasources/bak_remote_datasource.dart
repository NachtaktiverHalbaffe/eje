import 'package:eje/app_config.dart';
import 'package:eje/datasources/webscraper_remote_datasource.dart';
import 'package:eje/models/bakler.dart';
import 'package:html/dom.dart' as dom;

class BAKRemoteDatasource extends WebScraperRemoteDatasource<BAKler> {
  static const String nameCssSelector = "header-default header-icon-pos-left";
  static const String pictureCssSelector = "media-image";
  static const String contentCssSelector = "container";

  BAKRemoteDatasource({required super.client})
      : super(
            getAllElementsUrl:
                'https://www.eje-esslingen.de/ueber-uns/vorstand-bak',
            sectionsCssClass: 'ekd-element element-textmedia');

  @override
  Future<List<BAKler>> scrapeWebElementsForMultipleItem(
      List<dom.Element> hmtlElements) async {
    List<BAKler> bakler = List.empty(growable: true);
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String domain = appConfig.domain;

    for (int i = 0; i < hmtlElements.length; i++) {
      //Parse data to article
      String vorstellung = "";
      String amt = "";
      String name = "";
      String bild = "";
      String email = "";
      String threema = "";

      // ! name parsen
      if (hmtlElements[i].getElementsByClassName(nameCssSelector).isNotEmpty) {
        // get title
        String title = hmtlElements[i]
            .getElementsByClassName(nameCssSelector)
            .first
            .text
            .trim();
        // Split title into name and amt
        List<String> splitTitle;
        splitTitle = title.split(' - ');
        name = splitTitle[0].trim();
        if (splitTitle.length == 2) {
          amt = splitTitle[1].trim();
        }
      }

      if (hmtlElements[i]
          .getElementsByClassName(contentCssSelector)
          .isNotEmpty) {
        hmtlElements[i].getElementsByTagName('p').forEach((element) {
          // ! Threema parsen
          if (element.text.contains('Threema') |
              element.getElementsByTagName('a').isNotEmpty) {
            if (element.text.contains("ist:")) {
              threema = element.text.split('ist:')[1].trimLeft().trimRight();
            } else {
              threema = element.text.trimLeft().trimRight();
              threema = threema.substring(threema.length - 8);
              // If email was parsed as threema
              if (threema == "ingen.de") {
                threema = "";
              }
            }
            // ! Email parsen
            if (element.getElementsByTagName('a').isNotEmpty) {
              email = element
                  .getElementsByTagName('a')[0]
                  .text
                  .replaceAll('dontospamme', '')
                  .replaceAll('gowaway.', '')
                  .trimLeft()
                  .trimRight();
            }
          }
          // ! Beschreibung parsen
          else if (element.text != "") {
            vorstellung = "$vorstellung${element.text.trim()}\n\n";
            vorstellung =
                vorstellung.replaceAll("Ich bin erreichbar unter:", "");
          }
        });
      }

      // ! bilder parsen
      //check if picture links are in "text-pic-right" or "width100 center marginBottom10" class
      if (hmtlElements[i]
          .getElementsByClassName(pictureCssSelector)
          .isNotEmpty) {
        //picture-link is in text-pic-right class
        bild = domain +
            hmtlElements[i]
                .getElementsByClassName(pictureCssSelector)
                .first
                .getElementsByTagName('img')
                .first
                .attributes['src']!
                .trim();
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
    return bakler;
  }

  @override
  Future<BAKler> scrapeWebElementsForSingleItem(
      List<dom.Element> hmtlElements) {
    throw UnimplementedError();
  }
}
