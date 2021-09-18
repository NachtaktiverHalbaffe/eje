import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'Termin.g.dart';

@HiveType(typeId: 4)
class Termin extends Equatable {
  @HiveField(0)
  final String veranstaltung;
  @HiveField(1)
  final String motto;
  @HiveField(2)
  final String text;
  @HiveField(3)
  final String bild;
  @HiveField(4)
  final String datum;
  @HiveField(5)
  final Ort ort;

  Termin(
      {@required this.veranstaltung,
      this.motto,
      this.text,
      @required this.bild,
      @required this.datum,
      @required this.ort});

  @override
  List<Object> get props => [veranstaltung, motto, text, bild, datum, ort];
}
