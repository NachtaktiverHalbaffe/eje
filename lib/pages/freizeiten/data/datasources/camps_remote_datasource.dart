// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/platform/location.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:html2md/html2md.dart' as html2md;

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
      response =
          await client.get(Uri.parse(API_URL /*+ "?typeId=1"*/), headers: {
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
        // TODO Remove seminar from prod version!!!
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
          // Parse persons
          List<String> persons = List.empty(growable: true);
          responseData[i]["persons"].forEach((value) {
            faqs.add(value["name"]);
          });
          // Check values against null to avoid null fields
          camps.add(Camp(
            name: responseData[i]['name'] ?? "",
            subtitle: responseData[i]['teaser'] ?? "",
            startDate: responseData[i]['startDate'] != null
                ? DateTime.tryParse(responseData[i]['startDate'])
                : DateTime.now(),
            endDate: responseData[i]['endDate'] != null
                ? DateTime.tryParse(responseData[i]['endDate'])
                : DateTime.now(),
            ageFrom: responseData[i]['ageFrom'] ?? 0,
            ageTo: responseData[i]['ageTo'] ?? 99,
            price: _parsePrice(responseData[i]['price']),
            price2: _parsePrice(responseData[i]['price2']),
            occupancy: responseData[i]['occupancy'] ?? "",
            maxPlaces: responseData[i]['maxplaces'] ?? 0,
            location: responseData[i]['location'] != null
                ? _parseLocation(responseData[i]['location'])
                : Location("Musterort", "Musterstraße 1", "12345 Musterstadt"),
            registrationLink: responseData[i]['registrationLink'] ?? "",
            pictures: pictures.isNotEmpty ? pictures : [""],
            description: responseData[i]['description'] != null
                ? html2md.convert(responseData[i]['description'])
                : "",
            teaser: responseData[i]['teaser'] ?? "",
            registrationEnd: responseData[i]['registrationEnd'] != null
                ? DateTime.tryParse(responseData[i]['registrationEnd'])
                : DateTime.now(),
            catering: responseData[i]['catering'] ?? "",
            accommodation: responseData[i]['accommodation'] ?? "",
            journey: responseData[i]['arrivalDirections'] ?? "",
            otherServices: responseData[i]['services'] ?? "",
            companions: persons.isNotEmpty ? persons : [""],
            faq: faqs.isNotEmpty ? faqs : [""],
            categories: responseData[i]['categories'].length != 0
                ? _parseCategories(responseData[i]['categories'])
                : [""],
            termsDocument: responseData[i]['termsDocument'] ?? "",
            infosheetDocument: responseData[i]['infosheetDocument'] != null
                ? responseData[i]['infosheetDocument']['url']
                : "",
            privacyDocument: responseData[i]['privacyDocument'] ?? "",
            id: responseData[i]['id'] ?? 0,
          ));
        }
      }
      return camps;
    } else {
      throw ServerException();
    }
  }

  Location _parseLocation(responsedata) {
    var locationData = responsedata['address'];
    String adress = responsedata['name'] ?? "";

    String streetName = locationData['street'] ?? "";
    String houseNumber = locationData['houseNumber'] ?? "";
    String street = streetName + " " + houseNumber;

    String zip = locationData['zip'] ?? "";
    String city = locationData['city'] ?? "";
    String postalCode = zip + " " + city;
    return Location(adress, street, postalCode);
  }

  List<String> _parseCategories(responseData) {
    List<String> categories = new List.empty(growable: true);
    for (int i = 0; i < responseData.length; i++) {
      if (responseData[i]['Bezeichnung'] != null) {
        categories.add(responseData[i]['Bezeichnung']);
      }
    }
    return categories;
  }

  int _parsePrice(responseData) {
    if (responseData != null) {
      if (int.tryParse(responseData.replaceAll(RegExp('[^0-9.,]'), '')) !=
          null) {
        return int.tryParse(responseData
            .replaceAll(RegExp('[^0-9.,]'), '')
            .replaceAll(',', '.'));
      } else
        return 0;
    } else
      return 0;
  }

  // String html2markdown(String htmlString) {
  //   String markdownString = htmlString;

  //   // Bold Text
  //   markdownString = markdownString.replaceAll("<strong>", "**");
  //   markdownString = markdownString.replaceAll("</strong>", "**");
  //   // Parapgraphs
  //   markdownString = markdownString.replaceAll("<br>", "\n");
  //   // Links
  //   if (markdownString.contains("<img src=")) {
  //     // Get indeces of String
  //     int indexStartLinkTag = markdownString.indexOf("<a");
  //     int indexEndLinkTag = markdownString.indexOf(">");

  //     String linkTag =
  //         markdownString.substring(indexStartLinkTag, indexEndLinkTag);

  //     markdownString = markdownString.replaceAll("<!--StartFragment-->", "");
  //   }
  //   // Remove html-only parts
  //   markdownString = markdownString.replaceAll("<!--StartFragment-->", "");
  //   markdownString = markdownString.replaceAll("<!--EndFragment-->", "");
  // }
}
