// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/platform/location.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../app_config.dart';

class TermineRemoteDatasource {
  final http.Client client;
  TermineRemoteDatasource({@required this.client});

  Future<List<Event>> getTermine() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final API_URL = appConfig.ejwManager;
    final API_TOKEN = appConfig.ejwManagerToken;
    List<Event> events = List.empty(growable: true);

    // Get http Response
    final response =
        await client.get(Uri.parse(API_URL + "?typeId=3"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $API_TOKEN ',
    });
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body)["data"];
      for (int i = 0; i < responseData.length; i++) {
        if (responseData[i]['type'] == "Event") {
          // Parse image entry from response to list of links
          List<String> pictures = List.empty(growable: true);
          responseData[i]["images"].forEach((value) {
            pictures.add(value["url"]);
          });
          events.add(Event(
            id: responseData[i]['id'] != null ? responseData[i]['name'] : 0,
            name:
                responseData[i]['name'] != null ? responseData[i]['name'] : "",
            images: pictures.length != 0 ? pictures : [""],
            startDate: responseData[i]['startDate'] != null
                ? DateTime.tryParse(responseData[i]['startDate'])
                : DateTime.now(),
            endDate: responseData[i]['endDate'] != null
                ? DateTime.tryParse(responseData[i]['endDate'])
                : DateTime.now(),
            location: responseData[i]['location'] != null
                ? Location(responseData[i]['location'],
                    responseData[i]['location'], responseData[i]['location'])
                : Location("Musterort", "Musterstraße 1", "12345 Musterstadt"),
            registrationLink: responseData[i]['registrationLink'] != null
                ? responseData[i]['registrationLink']
                : "",
          ));
        }
      }
      return events;
    } else {
      throw ServerException();
    }
  }
}
