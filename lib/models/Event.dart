// ignore_for_file: file_names
import 'package:eje/models/location.dart';
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String name;
  final String motto;
  final String description;
  final List<String> images;
  final DateTime startDate;
  final DateTime endDate;
  final Location location;
  final int id;
  final String registrationLink;
  final int price;
  final int price2;
  final int ageFrom;
  final int ageTo;
  final DateTime registrationEnd;

  Event(
      {this.price = 0,
      this.price2 = 0,
      this.ageFrom = 0,
      this.ageTo = 0,
      required this.registrationEnd,
      required this.name,
      this.motto = "",
      this.description = "",
      required this.images,
      required this.startDate,
      required this.endDate,
      required this.location,
      required this.id,
      this.registrationLink = ""});

  @override
  List<Object> get props => [
        price,
        price2,
        ageFrom,
        ageTo,
        registrationEnd,
        name,
        motto,
        description,
        images,
        startDate,
        endDate,
        location,
        id,
        registrationLink,
      ];

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        price: json["price"] as int,
        price2: json["price2"] as int,
        ageFrom: json["ageFrom"] as int,
        ageTo: json["ageTo"] as int,
        motto: json["motto"] as String,
        description: json["description"] as String,
        registrationEnd: json["registrationEnd"] as DateTime,
        name: json["name"] as String,
        images: (json["images"] as List).cast<String>(),
        startDate: json["startDate"] as DateTime,
        endDate: json["endDate"] as DateTime,
        location: Location.fromJson(json["location"] as Map<String, dynamic>),
        id: json["id"] as int,
        registrationLink: json["registrationLink"] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "price": price,
      "price2": price2,
      "ageFrom": ageFrom,
      "ageTo": ageTo,
      "motto": motto,
      "description": description,
      "registrationEnd": registrationEnd,
      "name": name,
      "images": images,
      "startDate": startDate,
      "endDate": endDate,
      "location": location.toJson(),
      "id": id,
      "registrationLink": registrationLink
    };
  }
}
