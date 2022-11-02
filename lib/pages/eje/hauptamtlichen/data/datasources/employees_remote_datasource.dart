import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';
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
