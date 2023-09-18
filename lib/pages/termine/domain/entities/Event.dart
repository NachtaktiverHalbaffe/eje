// ignore_for_file: file_names
import 'package:eje/core/platform/location.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'Event.g.dart';

@HiveType(typeId: 4)
class Event extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String motto;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final List<String> images;
  @HiveField(4)
  final DateTime startDate;
  @HiveField(5)
  final DateTime endDate;
  @HiveField(6)
  final Location location;
  @HiveField(7)
  final int id;
  @HiveField(8)
  final String registrationLink;
  @HiveField(9)
  final int price;
  @HiveField(10)
  final int price2;
  @HiveField(11)
  final int ageFrom;
  @HiveField(12)
  final int ageTo;
  @HiveField(13)
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
}
