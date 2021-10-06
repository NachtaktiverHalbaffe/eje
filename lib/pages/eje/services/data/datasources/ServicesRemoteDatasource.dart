import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/webscraper.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServicesRemoteDatasource {
  final http.Client client;

  ServicesRemoteDatasource({@required this.client});

  Future<Service> getService(Service service) async {
    try {
      return await WebScraper().scrapeServices(service);
    } on ServerException {
      throw ServerException();
    } on ConnectionException {
      throw ConnectionException();
    }
  }
}
