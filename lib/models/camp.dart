import 'package:eje/models/location.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'camp.g.dart';

@HiveType(typeId: 26)
class Camp extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final DateTime startDate;
  @HiveField(2)
  final DateTime endDate;
  @HiveField(3)
  final int ageFrom;
  @HiveField(4)
  final int ageTo;
  @HiveField(5)
  final int price;
  @HiveField(6)
  final int price2;
  @HiveField(7)
  final String occupancy;
  @HiveField(8)
  final int maxPlaces;
  @HiveField(9)
  final Location location;
  @HiveField(10)
  final String registrationLink;
  @HiveField(11)
  final List<String> pictures;
  @HiveField(12)
  final String description;
  @HiveField(13)
  final String teaser;
  @HiveField(14)
  final DateTime registrationEnd;
  @HiveField(15)
  final String catering;
  @HiveField(16)
  final String accommodation;
  @HiveField(17)
  final String journey;
  @HiveField(18)
  final String otherServices;
  @HiveField(19)
  final String subtitle;
  @HiveField(20)
  final List<String> companions;
  @HiveField(21)
  final List<String> faq;
  @HiveField(22)
  final List<String> categories;
  @HiveField(23)
  final String termsDocument;
  @HiveField(24)
  final String infosheetDocument;
  @HiveField(25)
  final String privacyDocument;
  @HiveField(26)
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
}
