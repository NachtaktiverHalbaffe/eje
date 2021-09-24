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
  final int startAge;
  @HiveField(4)
  final int endAge;
  @HiveField(5)
  final int price;
  @HiveField(6)
  final String freePlaces;
  @HiveField(7)
  final Ort location;
  @HiveField(8)
  final String link;
  @HiveField(9)
  final List<String> pictures;
  @HiveField(10)
  final String description;
  @HiveField(11)
  final String registrationDeadline;
  @HiveField(12)
  final String catering;
  @HiveField(13)
  final String lodging;
  @HiveField(14)
  final String journey;
  @HiveField(15)
  final String otherServices;
  @HiveField(16)
  final String subtitle;
  @HiveField(17)
  final List<String> companion;

  Camp(
      {this.name,
      this.startDate,
      this.endDate,
      this.startAge,
      this.endAge,
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
        startAge,
        endAge,
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
