import 'package:eje/datasources/RemoteDataSource.dart';
import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/exception.dart';
import 'package:http/http.dart' as http;

class EmployeesRemoteDatasource implements RemoteDataSource<Employee, String> {
  final http.Client client;

  EmployeesRemoteDatasource({required this.client});

  @override
  Future<List<Employee>> getAllElements() async {
    try {
      return await WebScraper().scrapeHauptamliche();
    } on ServerException {
      throw ServerException();
    } on ConnectionException {
      throw ConnectionException();
    }
  }

  @override
  Future<Employee> getElement(String elementId) {
    throw UnimplementedError();
  }
}
