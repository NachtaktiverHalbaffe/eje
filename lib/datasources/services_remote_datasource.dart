import 'package:eje/app_config.dart';
import 'package:eje/datasources/local_data_source.dart';
import 'package:eje/datasources/remote_data_source.dart';
import 'package:eje/models/article.dart';
import 'package:eje/models/hyperlink.dart';
import 'package:eje/models/offered_service.dart';
import 'package:eje/models/exception.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart';

class ServicesRemoteDatasource
    implements RemoteDataSource<OfferedService, String> {
  final Client client;
  final LocalDataSource<OfferedService, String> cache;
  final RemoteDataSource<Article, String> articleDataSource;

  ServicesRemoteDatasource(
      {required this.client,
      required this.cache,
      required this.articleDataSource});

  @override
  Future<List<OfferedService>> getAllElements() async {
    final List<OfferedService> scrapedServices = List.empty(growable: true);
    final List<OfferedService> services = await cache.getAllElements();

    for (int i = 0; i < services.length; i++) {
      final appConfig = await AppConfig.loadConfig();
      final String DOMAIN = appConfig.domain;

      List<Hyperlink> hyperlinks = services[i].hyperlinks.sublist(0, 1);
      List<String> links = List.empty(growable: true);
      List<String> description = List.empty(growable: true);

      Response response;
      try {
        response = await client.get(Uri.parse(services[i].hyperlinks[0].link));
      } catch (e) {
        throw ConnectionException();
      }
      if (response.statusCode == 200) {
        print("Services: Getting Data from Internet");
        dom.Document document = parser.parse(response.body);
        //Check if service is eje-info
        if (services[i].service == "eje-Info") {
          final parent = document
              .getElementsByClassName('download_list')
              .first
              .getElementsByTagName("a");
          if (hyperlinks.length > 1) {
            for (int i = 0; i < parent.length; i++) {
              bool isAlreadyInCache = false;
              for (int k = 0; k < hyperlinks.length; k++) {
                if ((DOMAIN + parent[i].attributes['href']!) ==
                    hyperlinks[k].link) {
                  isAlreadyInCache = true;
                }
              }
              if (!isAlreadyInCache) {
                links.add(DOMAIN + parent[i].attributes['href']!);
                description.add(parent[i]
                    .getElementsByClassName("dw-title")
                    .first
                    .text
                    .trim());
              }
            }
          } else {
            links.addAll(parent
                .map((element) => DOMAIN + element.attributes['href']!)
                .toList());
            description.addAll(parent
                .map((element) => element
                    .getElementsByClassName("dw-title")
                    .first
                    .text
                    .trim())
                .toList());
          }
          for (int k = 0; k < links.length; k++) {
            hyperlinks
                .add(Hyperlink(link: links[k], description: description[k]));
          }

          scrapedServices.add(OfferedService(
              service: services[i].service,
              images: services[i].images,
              description: services[i].description,
              hyperlinks: hyperlinks));
        }
        //Service is a webpage which to webscrape
        else {
          Article _article = await articleDataSource
              .getElement(services[i].hyperlinks[0].link);

          List<String> bilder = services[i].images.sublist(0, 1);
          bilder.addAll(_article.bilder);
          List<Hyperlink> hyperlinks = services[i].hyperlinks.sublist(0, 1);
          hyperlinks.addAll(_article.hyperlinks);
          String content = services[i].description;

          if (_article.content.isNotEmpty) {
            if (!content.contains(_article.content)) {
              content = _article.content;
            }
          }
          if (bilder.length > 1) {
            bilder = bilder.sublist(1);
          }

          scrapedServices.add(OfferedService(
            service: services[i].service,
            images: bilder,
            description: services[i].service == 'Verleih'
                ? services[i].description
                : content,
            hyperlinks: hyperlinks,
          ));
        }
      } else {
        throw ConnectionException();
      }
    }

    print(scrapedServices.length);
    return scrapedServices;
  }

  @override
  Future<OfferedService> getElement(String elementId) {
    throw UnimplementedError();
  }
}
