import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/exception.dart';
import 'package:http/http.dart' as http;

class EmployeesRemoteDatasource {
  final http.Client client;

  EmployeesRemoteDatasource({required this.client});

  Future<List<Employee>> getEmployees() async {
    try {
      return await WebScraper().scrapeHauptamliche();
    } on ServerException {
      throw ServerException();
    } on ConnectionException {
      throw ConnectionException();
    }
  }
}
