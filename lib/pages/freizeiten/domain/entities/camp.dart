import 'package:eje/pages/termine/domain/entities/Ort.dart';
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
  final int age;
  @HiveField(4)
  final int price;
  @HiveField(5)
  final String freePlaces;
  @HiveField(6)
  final Ort location;
  @HiveField(7)
  final String link;
  @HiveField(8)
  final List<String> pictures;
  @HiveField(9)
  final String description;
  @HiveField(10)
  final String registrationDeadline;
  @HiveField(11)
  final String catering;
  @HiveField(12)
  final String lodging;
  @HiveField(13)
  final String journey;
  @HiveField(14)
  final String otherServices;
  @HiveField(15)
  final String subtitle;
  @HiveField(16)
  final List<String> companion;

  Camp(
      {this.name,
      this.startDate,
      this.endDate,
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
        startDate,
        endDate,
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
