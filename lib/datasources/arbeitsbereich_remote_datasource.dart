import 'package:eje/datasources/RemoteDataSource.dart';
import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:http/http.dart' as http;

class ArbeitsbereichRemoteDatasource
    implements RemoteDataSource<FieldOfWork, String> {
  final http.Client client;
  ArbeitsbereichRemoteDatasource({required this.client});

  @override
  Future<List<FieldOfWork>> getAllElement() async {
    try {
      return await WebScraper().scrapeArbeitsbereiche();
    } on ServerException {
      throw ServerException();
    } on ConnectionException {
      throw ConnectionException();
    }
  }

  @override
  Future<FieldOfWork> getElement(String elementId) {
    throw UnimplementedError();
  }
}
