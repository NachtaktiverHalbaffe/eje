import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'camp.g.dart';

@HiveType(typeId: 5)
class Camp extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String datum;
  @HiveField(2)
  final String age;
  @HiveField(3)
  final String price;
  @HiveField(4)
  final String freePlaces;
  @HiveField(5)
  final Ort location;
  @HiveField(6)
  final String link;
  @HiveField(7)
  final List<String> pictures;
  @HiveField(8)
  final String description;
  @HiveField(9)
  final String registrationDeadline;
  @HiveField(10)
  final String catering;
  @HiveField(11)
  final String lodging;
  @HiveField(12)
  final String journey;
  @HiveField(13)
  final String otherServices;
  @HiveField(14)
  final String subtitle;
  @HiveField(15)
  final List<String> companion;

  Camp(
      {this.name,
      this.datum,
      this.age,
      this.price,
      this.freePlaces,
      this.location,
      this.link,
      this.pictures,
      this.description,
      this.registrationDeadline,
      this.catering,
      this.lodging,
      this.journey,
      this.otherServices,
      this.subtitle,
      this.companion});

  @override
  List<Object> get props => [
        name,
        datum,
        age,
        price,
        freePlaces,
        location,
        link,
        pictures,
        description,
        registrationDeadline,
        catering,
        lodging,
        journey,
        otherServices,
        companion
      ];
}
