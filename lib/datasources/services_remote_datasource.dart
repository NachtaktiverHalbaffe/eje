import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/exception.dart';
import 'package:http/http.dart' as http;

class ServicesRemoteDatasource {
  final http.Client client;

  ServicesRemoteDatasource({required this.client});

  Future<OfferedService> getService(OfferedService service) async {
    try {
      return await WebScraper().scrapeServices(service);
    } on ServerException {
      throw ServerException();
    } on ConnectionException {
      throw ConnectionException();
    }
  }
}
