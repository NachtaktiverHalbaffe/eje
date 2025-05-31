import 'package:eje/app_config.dart';
import 'package:eje/datasources/webscraper_remote_datasource.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:html/dom.dart' as dom;

class ArbeitsbereichRemoteDatasource
    extends WebScraperRemoteDatasource<FieldOfWork> {
  ArbeitsbereichRemoteDatasource({required super.client})
      : super(
            getAllElementsUrl: "https://www.eje-esslingen.de/arbeitsfelder",
            sectionsCssClass: "element-teaserbox");

  static const String nameCssSelector = "header-default header-icon-pos-left  ";
  static const String imageCssSelector = "image-link";
  static const String linkCssSelector = "btn  ";

  @override
  Future<List<FieldOfWork>> scrapeWebElementsForMultipleItem(
      List<dom.Element> hmtlElements) async {
    List<FieldOfWork> arbeitsbereiche = List.empty(growable: true);
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String domain = appConfig.domain;

    for (int i = 0; i < hmtlElements.length; i++) {
      //Parse data to article
      String arbeitsbereich = "";
      List<String> bild = List.empty(growable: true);
      String linkUrl = "";
      // ! Parse Name
      if (hmtlElements[i].getElementsByClassName(nameCssSelector).isNotEmpty) {
        arbeitsbereich = hmtlElements[i]
            .getElementsByClassName(nameCssSelector)
            .first
            .text
            .trim();
      }

      // ! bilder parsen
      //check if picture links are in "text-pic-right" or "width100 center marginBottom10" class
      if (hmtlElements[i].getElementsByClassName(imageCssSelector).isNotEmpty) {
        //picture-link is in text-pic-right class
        bild.add(domain +
            hmtlElements[i]
                .getElementsByClassName(imageCssSelector)
                .first
                .getElementsByTagName('img')
                .first
                .attributes['src']!
                .trim());
      }
      // ! link parsen
      if (hmtlElements[i].getElementsByClassName(linkCssSelector).isNotEmpty) {
        linkUrl = domain +
            hmtlElements[i]
                .getElementsByClassName(linkCssSelector)
                .first
                .attributes['href']!
                .trim();
      }

      //add scraped Section to List of Articles
      if (arbeitsbereich != "" || bild.isNotEmpty || linkUrl != "") {
        arbeitsbereiche.add(FieldOfWork(
          name: arbeitsbereich,
          images: bild,
          description: "",
          link: linkUrl,
        ));
      }
    }
    return arbeitsbereiche;
  }

  @override
  Future<FieldOfWork> scrapeWebElementsForSingleItem(
      List<dom.Element> hmtlElements) {
    throw UnimplementedError();
  }
}
