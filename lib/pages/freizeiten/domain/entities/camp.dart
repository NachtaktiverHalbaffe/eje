import 'package:eje/core/platform/location.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'camp.g.dart';

@HiveType(typeId: 5)
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

  Camp(
      {this.maxPlaces,
      this.faq,
      this.categories,
      this.name,
      this.startDate,
      this.endDate,
      this.ageFrom,
      this.ageTo,
      this.price,
      this.price2,
      this.occupancy,
      this.location,
      this.registrationLink,
      this.pictures,
      this.description,
      this.teaser,
      this.registrationEnd,
      this.catering,
      this.accommodation,
      this.journey,
      this.otherServices,
      this.subtitle,
      this.companions,
      this.termsDocument,
      this.infosheetDocument,
      this.privacyDocument});

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
        privacyDocument
      ];
}
