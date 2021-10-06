import 'package:eje/core/platform/location.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'event.g.dart';

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

  Event(
      {@required this.name,
      this.motto,
      this.description,
      @required this.images,
      @required this.startDate,
      @required this.endDate,
      @required this.location,
      @required this.id,
      this.registrationLink});

  @override
  List<Object> get props => [
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
