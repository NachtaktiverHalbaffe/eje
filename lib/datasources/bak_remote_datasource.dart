import 'package:eje/datasources/RemoteDataSource.dart';
import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/exception.dart';
import 'package:http/http.dart' as http;

class BAKRemoteDatasource implements RemoteDataSource<BAKler, String> {
  final http.Client client;

  BAKRemoteDatasource({required this.client});

  @override
  Future<List<BAKler>> getAllElements() async {
    try {
      return await WebScraper().scrapeBAKler();
    } on ServerException {
      throw ServerException();
    } on ConnectionException {
      throw ConnectionException();
    }
  }

  @override
  Future<BAKler> getElement(String elementId) {
    throw UnimplementedError();
  }
}
