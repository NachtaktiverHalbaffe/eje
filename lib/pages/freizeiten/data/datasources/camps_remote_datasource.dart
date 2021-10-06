// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/platform/location.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CampsRemoteDatasource {
  final http.Client client = http.Client();

  Future<List<Camp>> getFreizeiten() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final API_URL = appConfig.ejwManager;
    final API_TOKEN = appConfig.ejwManagerToken;
    List<Camp> camps = List.empty(growable: true);

    // Get http Response
    Response response;
    try {
      response = await client.get(Uri.parse(API_URL + "?typeId=1"), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $API_TOKEN ',
      });
    } catch (e) {
      print("CampsAPI error: " + e.toString());
      throw ConnectionException();
    }

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body)["data"];
      for (int i = 0; i < responseData.length; i++) {
        if (responseData[i]['type'] == "Freizeit") {
          // Parse image entry from response to list of links
          List<String> pictures = List.empty(growable: true);
          responseData[i]["images"].forEach((value) {
            pictures.add(value["url"]);
          });
          // Parse companions
          List<String> companions = List.empty(growable: true);
          responseData[i]["persons"].forEach((value) {
            companions.add(value["name"]);
          });
          // Parse faqs
          List<String> faqs = List.empty(growable: true);
          responseData[i]["faqs"].forEach((value) {
            faqs.add(value["question"] + ": " + value["answer"]);
          });

          // Check values against null to avoid null fields
          camps.add(Camp(
            name: responseData[i]['name'] ?? "",
            subtitle: "",
            startDate: responseData[i]['startDate'] != null
                ? DateTime.tryParse(responseData[i]['startDate'])
                : DateTime.now(),
            endDate: responseData[i]['endDate'] != null
                ? DateTime.tryParse(responseData[i]['endDate'])
                : DateTime.now(),
            ageFrom: responseData[i]['ageFrom'] ?? 0,
            ageTo: responseData[i]['ageTo'] ?? 0,
            price: responseData[i]['price'] != null
                ? int.parse(
                    responseData[i]['price'].replaceAll(RegExp('[^0-9]'), ''))
                : 0,
            price2: responseData[i]['price2'] != null
                ? int.parse(
                    responseData[i]['price2'].replaceAll(RegExp('[^0-9]'), ''))
                : 0,
            occupancy: responseData[i]['occupancy'] ?? "",
            maxPlaces: responseData[i]['maxplaces'] ?? 0,
            location: responseData[i]['location'] != null
                ? Location(responseData[i]['location'],
                    responseData[i]['location'], responseData[i]['location'])
                : Location("Musterort", "Musterstraße 1", "12345 Musterstadt"),
            registrationLink: responseData[i]['registrationLink'] ?? "",
            pictures: pictures.isNotEmpty ? pictures : [""],
            description: responseData[i]['description'] ?? "",
            teaser: responseData[i]['teaser'] ?? "",
            registrationEnd: responseData[i]['registrationEnd'] != null
                ? DateTime.tryParse(responseData[i]['registrationEnd'])
                : DateTime.now(),
            catering: responseData[i]['catering'] ?? "",
            accommodation: responseData[i]['accommodation'] ?? "",
            journey: responseData[i]['arrivalDirections'] ?? "",
            otherServices: responseData[i]['services'] ?? "",
            companions: companions.isNotEmpty ? companions : [""],
            faq: faqs.isNotEmpty ? faqs : [""],
            categories: responseData[i]['categories'].length != 0
                ? responseData[i]['categories']
                : [""],
            termsDocument: responseData[i]['termsDocument'] ?? "",
            infosheetDocument: responseData[i]['infosheetDocument'] ?? "",
            privacyDocument: responseData[i]['privacyDocument'] ?? "",
          ));
        }
      }
      return camps;
    } else {
      throw ServerException();
    }
  }
}
