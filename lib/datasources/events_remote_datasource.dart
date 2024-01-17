// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:eje/datasources/RemoteDataSource.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/location.dart';
import 'package:eje/utils/env.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:http/http.dart';

class TermineRemoteDatasource implements RemoteDataSource<Event, int> {
  final Client client;

  TermineRemoteDatasource({required this.client});

  @override
  Future<List<Event>> getAllElements() async {
    final API_URL = Env.amosURL;
    final API_TOKEN = Env.amosToken;
    List<Event> events = List.empty(growable: true);

    // Get http Response
    Response response;
    try {
      response = await client.get(
        Uri.parse(API_URL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $API_TOKEN ',
        },
      );
    } catch (e) {
      print("EventsAPI error: $e");
      throw ConnectionException();
    }
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body)["data"];
      for (int i = 0; i < responseData.length; i++) {
        if (responseData[i]['type'] == "Event" ||
            responseData[i]['type'] == "Seminar") {
          // Parse image entry from response to list of links
          List<String> pictures = List.empty(growable: true);
          responseData[i]["images"].forEach((value) {
            pictures.add(value["url"]);
          });
          events.add(Event(
            ageFrom: responseData[i]['ageFrom'] ?? 0,
            ageTo: responseData[i]['ageTo'] ?? 99,
            id: responseData[i]['id'] ?? 0,
            name: responseData[i]['name'] ?? "",
            motto: responseData[i]['teaser'] ?? "",
            price: _parsePrice(responseData[i]['price']),
            price2: _parsePrice(responseData[i]['price2']),
            registrationEnd: responseData[i]['registrationEnd'] != null
                ? DateTime.tryParse(responseData[i]['registrationEnd']) ??
                    DateTime.now()
                : DateTime.now(),
            images: pictures.isNotEmpty ? pictures : [""],
            description: responseData[i]['description'] != null
                ? html2md.convert(responseData[i]['description'])
                : "",
            startDate: DateTime.tryParse(responseData[i]['startDate']) ??
                DateTime.now(),
            endDate:
                DateTime.tryParse(responseData[i]['endDate']) ?? DateTime.now(),
            location: responseData[i]['location'] != null
                ? _parseLocation(responseData[i]['location'])
                : Location("", "", ""),
            registrationLink: responseData[i]['registrationLink'] ?? "",
          ));
        }
      }
      events.sort((item1, item2) => item1.startDate.compareTo(item2.startDate));
      return List.of(events.reversed);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Event> getElement(int elementId) {
    throw UnimplementedError();
  }

  Location _parseLocation(responsedata) {
    var locationData = responsedata['address'];
    String adress = responsedata['name'] ?? "";

    String streetName = locationData['street'] ?? "";
    String houseNumber = locationData['houseNumber'] ?? "";
    String street = "$streetName $houseNumber";

    String zip = locationData['zip'] ?? "";
    String city = locationData['city'] ?? "";
    String postalCode = "$zip $city";
    return Location(adress, street, postalCode);
  }

  int _parsePrice(responseData) {
    print(responseData);
    if (responseData != null) {
      if (int.tryParse(responseData.replaceAll(',-', '')) != null) {
        return int.tryParse(responseData.replaceAll(',-', '')) ?? 0;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }
}
