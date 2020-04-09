
import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'Termin.g.dart';

@HiveType(typeId: 4)
class Termin extends Equatable{
  @HiveField(0)
  String veranstaltung;
  @HiveField(1)
  String motto;
  @HiveField(2)
  String text;
  @HiveField(3)
  String bild;
  @HiveField(4)
  String datum;
  @HiveField(5)
  Ort ort;

  @override
  List<Object> get props => [veranstaltung,motto,text,bild,datum,ort];

}