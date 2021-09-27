// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:http/http.dart' as http;

class CampsRemoteDatasource {
  final http.Client client = http.Client();
  //TODO: Params testing wiith non null test values

  Future<List<Camp>> getFreizeiten() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final API_URL = appConfig.ejwManager;
    final API_TOKEN = appConfig.ejwManagerToken;
    List<Camp> camps = List.empty(growable: true);

    // Get http Response
    final response =
        await client.get(Uri.parse(API_URL + "/?typeId=1"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $API_TOKEN ',
    });
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body)["data"];
      for (int i = 0; i < responseData.length; i++) {
        if (responseData[i]['type'] == "Freizeit") {
          // Parse image entry from response to list of links
          List<String> pictures = List.empty(growable: true);
          responseData[i]["images"].forEach((value) {
            pictures.add(value["url"]);
          });

          // Check values against null to avoid null fields
          camps.add(Camp(
            name:
                responseData[i]['name'] != null ? responseData[i]['name'] : "",
            subtitle: "",
            startDate: responseData[i]['startDate'] != null
                ? DateTime.tryParse(responseData[i]['startDate'])
                : DateTime.now(),
            endDate: responseData[i]['endDate'] != null
                ? DateTime.tryParse(responseData[i]['endDate'])
                : DateTime.now(),
            ageFrom: responseData[i]['ageFrom'] != null
                ? responseData[i]['ageFrom']
                : 0,
            ageTo:
                responseData[i]['ageTo'] != null ? responseData[i]['ageTo'] : 0,
            price:
                responseData[i]['price'] != null ? responseData[i]['price'] : 0,
            price2: responseData[i]['price2'] != null
                ? responseData[i]['price2']
                : 0,
            occupancy: responseData[i]['occupancy'] != null
                ? responseData[i]['occupancy']
                : "",
            maxPlaces: responseData[i]['maxplaces'] != null
                ? responseData[i]['maxplaces']
                : 0,
            location: responseData[i]['location'] != null
                ? Ort(responseData[i]['location'], responseData[i]['location'],
                    responseData[i]['location'])
                : Ort("Musterort", "Musterstraße 1", "12345 Musterstadt"),
            registrationLink: responseData[i]['registrationLink'] != null
                ? responseData[i]['registrationLink']
                : "",
            pictures: pictures.length != 0 ? pictures : [""],
            description: responseData[i]['description'] != null
                ? responseData[i]['description']
                : "",
            teaser: responseData[i]['teaser'] != null
                ? responseData[i]['teaser']
                : "",
            registrationEnd: responseData[i]['registrationEnd'] != null
                ? DateTime.tryParse(responseData[i]['registrationEnd'])
                : DateTime.now(),
            catering: responseData[i]['catering'] != null
                ? responseData[i]['catering']
                : "",
            accommodation: responseData[i]['accommodation'] != null
                ? responseData[i]['accommodation']
                : "",
            journey: responseData[i]['arrivalDirections'] != null
                ? responseData[i]['arrivalDirections']
                : "",
            otherServices: responseData[i]['services'] != null
                ? responseData[i]['services']
                : "",
            companions: responseData[i]['persons'].length != 0
                ? responseData[i]['persons']
                : [""],
            faq: responseData[i]['faqs'].length != 0
                ? responseData[i]['faqs']
                : [""],
            categories: responseData[i]['categories'].length != 0
                ? responseData[i]['categories']
                : [""],
            termsDocument: responseData[i]['termsDocument'] != null
                ? responseData[i]['termsDocument']
                : "",
            infosheetDocument: responseData[i]['infosheetDocument'] != null
                ? responseData[i]['infosheetDocument']
                : "",
            privacyDocument: responseData[i]['privacyDocument'] != null
                ? responseData[i]['privacyDocument']
                : "",
          ));
        }
      }
      return camps;
    } else {
      throw ServerException();
    }
  }
}
