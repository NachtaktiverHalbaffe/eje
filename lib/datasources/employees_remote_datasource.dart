import 'package:eje/app_config.dart';
import 'package:eje/datasources/webscraper_remote_datasource.dart';
import 'package:eje/models/employee.dart';
import 'package:html/dom.dart' as dom;

class EmployeesRemoteDatasource extends WebScraperRemoteDatasource<Employee> {
  static const String nameCssSelector = "header-default header-icon-pos-left";
  static const String pictureCssSelector = "media-image";
  static const String contentCssSelector = "container";

  EmployeesRemoteDatasource({required super.client})
      : super(
            getAllElementsUrl:
                'https://www.eje-esslingen.de/ueber-uns/hauptamtliche-mitarbeiter',
            sectionsCssClass: "ekd-element element-textmedia");

  @override
  Future<List<Employee>> scrapeWebElementsForMultipleItem(
      List<dom.Element> hmtlElements) async {
    List<Employee> hauptamtliche = List.empty(growable: true);
    final AppConfig appConfig = await AppConfig.loadConfig();
    final String domain = appConfig.domain;

    for (int i = 0; i < hmtlElements.length; i++) {
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
      if (hmtlElements[i].getElementsByClassName(nameCssSelector).isNotEmpty) {
        // get title
        String title =
            hmtlElements[i].getElementsByClassName(nameCssSelector).first.text;
        // Split title into name and amt
        List<String> splitTitle;
        splitTitle = title.split('-');
        name = splitTitle.first.trim();
        if (splitTitle.length == 2) {
          bereich = splitTitle[1].trim();
        }
      }

      // ! Beschreibung parsen
      String content = '';
      if (hmtlElements[i]
          .getElementsByClassName(contentCssSelector)
          .isNotEmpty) {
        hmtlElements[i].getElementsByTagName("p").forEach((element) {
          if (element.text.contains('Ich bin erreichbar unter')) {
            final text = element.text;
            final phoneRegExp =
                RegExp(r'(\d{3,5} *(\/|-) *[\d ]+)', caseSensitive: false);
            final mobileRegExp = RegExp(
                r'Diensthandy: *(\d{3,5} *(\/|-) *[\d ]+)',
                caseSensitive: false);
            final threemaRegExp = RegExp(r'([A-Z0-9]{8})');

            telefon = phoneRegExp.firstMatch(text)?.group(1) ?? "";
            handy = mobileRegExp.firstMatch(text)?.group(1) ?? "";
            threema = threemaRegExp.firstMatch(text)?.group(1) ?? "";

            if (element.getElementsByTagName('a').isNotEmpty) {
              email = element
                  .getElementsByTagName('a')[0]
                  .text
                  .replaceAll('dontospamme', '')
                  .replaceAll('gowaway.', '')
                  .trim();
            }
          } else if (element.text != "") {
            vorstellung += "\n\n${element.text.trim()}";
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
                .getElementsByTagName('img')[0]
                .attributes['src']!
                .trim();
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
      content = "$content\n\n";
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
        hauptamtliche.add(Employee(
            image: bild,
            name: name,
            function: bereich,
            introduction: vorstellung,
            email: email,
            telefon: telefon.contains("0711") ? telefon : "",
            handy: !handy.contains("0711") ? handy : "",
            threema: threema));
      }
    }
    return hauptamtliche;
  }

  @override
  Future<Employee> getElement(String elementId) {
    throw UnimplementedError();
  }

  @override
  Future<Employee> scrapeWebElementsForSingleItem(
      List<dom.Element> hmtlElements) {
    throw UnimplementedError();
  }
}
