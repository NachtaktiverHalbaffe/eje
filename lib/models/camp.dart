import 'package:eje/models/location.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class Camp extends Equatable {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int ageFrom;
  final int ageTo;
  final int price;
  final int price2;
  final String occupancy;
  final int maxPlaces;
  final Location location;
  final String registrationLink;
  final List<String> pictures;
  final String description;
  final String teaser;
  final DateTime registrationEnd;
  final String catering;
  final String accommodation;
  final String journey;
  final String otherServices;
  final String subtitle;
  final List<String> companions;
  final List<String> faq;
  final List<String> categories;
  final String termsDocument;
  final String infosheetDocument;
  final String privacyDocument;
  final int id;

  Camp(
      {required this.maxPlaces,
      required this.faq,
      required this.categories,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.ageFrom,
      required this.ageTo,
      required this.price,
      required this.price2,
      required this.occupancy,
      required this.location,
      required this.registrationLink,
      required this.pictures,
      required this.description,
      required this.teaser,
      required this.registrationEnd,
      required this.catering,
      required this.accommodation,
      required this.journey,
      required this.otherServices,
      required this.subtitle,
      required this.companions,
      required this.termsDocument,
      required this.infosheetDocument,
      required this.privacyDocument,
      required this.id});

  @override
  List<Object> get props => [
        name,
        startDate,
        endDate,
        ageFrom,
        ageTo,
        price,
        price2,
        occupancy,
        maxPlaces,
        location,
        registrationLink,
        pictures,
        description,
        teaser,
        registrationEnd,
        catering,
        accommodation,
        journey,
        otherServices,
        companions,
        faq,
        categories,
        termsDocument,
        infosheetDocument,
        privacyDocument,
        id
      ];

  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
        maxPlaces: json["maxPlaces"] as int,
        faq: (json["faq"] as List).cast<String>(),
        categories: (json["categories"] as List).cast<String>(),
        name: json["name"] as String,
        startDate: json["startDate"] as DateTime,
        endDate: json["endDate"] as DateTime,
        ageFrom: json["ageFrom"] as int,
        ageTo: json["ageTo"] as int,
        price: json["int"] as int,
        price2: json["price2"] as int,
        occupancy: json["occupancy"] as String,
        location: Location.fromJson(json["location"] as Map<String, dynamic>),
        registrationLink: json["registrationLink"] as String,
        pictures: (json["pictures"] as List).cast<String>(),
        description: json["description"] as String,
        teaser: json["teaser"] as String,
        registrationEnd: json["registrationEnd"] as DateTime,
        catering: json["catering"] as String,
        accommodation: json["accommodation"] as String,
        journey: json["journey"] as String,
        otherServices: json["otherServices"],
        subtitle: json["subtitle"] as String,
        companions: (json["companions"] as List).cast<String>(),
        termsDocument: json["termsDocument"] as String,
        infosheetDocument: json["infosheetDocument"] as String,
        privacyDocument: json["privacyDocument"] as String,
        id: json["id"] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "startDate": startDate,
      "endDate": endDate,
      "endDate": ageFrom,
      "ageTo": ageTo,
      "price": price,
      "price2": price2,
      "occupancy": occupancy,
      "maxPlaces": maxPlaces,
      "location": location.toJson(),
      "registrationLink": registrationLink,
      "pictures": pictures,
      "description": description,
      "teaser": teaser,
      "registrationEnd": registrationEnd,
      "catering": catering,
      "accommodation": accommodation,
      "journey": journey,
      "otherServices": otherServices,
      "companions": companions,
      "faq": faq,
      "categories": categories,
      "termsDocument": termsDocument,
      "infosheetDocument": infosheetDocument,
      "privacyDocument": privacyDocument,
      "id": id
    };
  }
}
