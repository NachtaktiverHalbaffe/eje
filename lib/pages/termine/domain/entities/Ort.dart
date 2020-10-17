import 'package:hive/hive.dart';

part 'Ort.g.dart';

@HiveType(typeId: 10)
class Ort {
  @HiveField(0)
  String Anschrift;
  @HiveField(1)
  String Strasse;
  @HiveField(2)
  String PLZ;

  Ort(this.Anschrift, this.Strasse, this.PLZ);
}
