import 'package:hive_ce/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 10)
class Location {
  @HiveField(0)
  String adress;
  @HiveField(1)
  String street;
  @HiveField(2)
  String postalCode;

  Location(this.adress, this.street, this.postalCode);
}
