import 'package:dartz/dartz_unsafe.dart';
import 'package:eje/app_config.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/RemoteDataSource.dart';
import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/exception.dart';
import 'package:http/http.dart' as http;

class ServicesRemoteDatasource
    implements RemoteDataSource<OfferedService, String> {
  final LocalDataSource<OfferedService, String> cache;

  ServicesRemoteDatasource({required this.cache});

  @override
  Future<List<OfferedService>> getAllElements() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final List<OfferedService> scrapedServices = List.empty(growable: true);
    final List<OfferedService> services =
        await cache.getAllElements(appConfig.servicesBox);

    for (int i = 0; i < services.length; i++) {
      try {
        final OfferedService scrapedService =
            await WebScraper().scrapeServices(services[i]);

        scrapedServices.add(scrapedService);
      } on ServerException {
        throw ServerException();
      } on ConnectionException {
        throw ConnectionException();
      }
    }

    print(scrapedServices.length);
    return scrapedServices;
  }

  @override
  Future<OfferedService> getElement(String elementId) {
    // TODO: implement getElement
    throw UnimplementedError();
  }
}
